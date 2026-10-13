#!/usr/bin/env python3
"""
Home Lab Caddy Reverse Proxy Dashboard
Reads Caddyfile and creates entries in index.html.
"""

import os
import re
import sys
import threading
import time
from datetime import datetime
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

# Color palettes cycling for icon backgrounds (bg, fg)
PALETTES = [
    ("#fff7ed", "#ea580c"),  # Orange
    ("#eff6ff", "#2563eb"),  # Blue
    ("#f0fdf4", "#16a34a"),  # Green
    ("#fef2f2", "#dc2626"),  # Red
    ("#f0f9ff", "#0284c7"),  # Cyan
    ("#faf5ff", "#9333ea"),  # Purple
    ("#fffbeb", "#d97706"),  # Amber
    ("#f5f3ff", "#7c3aed"),  # Indigo
]

# Pool of default Font Awesome icons
DEFAULT_ICONS = [
    "fa-solid fa-server",
    "fa-solid fa-globe",
    "fa-solid fa-desktop",
    "fa-solid fa-gauge-high",
    "fa-solid fa-heart-pulse",
    "fa-solid fa-code",
    "fa-solid fa-database",
    "fa-solid fa-hard-drive",
    "fa-solid fa-network-wired",
    "fa-solid fa-shield-halved",
    "fa-solid fa-tv",
    "fa-solid fa-sliders",
    "fa-solid fa-cloud",
    "fa-solid fa-cubes",
    "fa-solid fa-terminal",
]

# Keyword rules for icon and color auto-detection
KEYWORD_ICON_RULES = [
    (r"rdp|desktop|vnc|remote|windows|pc", "fa-solid fa-desktop", "#fff7ed", "#ea580c"),
    (r"speed|gauge|metric|stat|monitor|prometheus|grafana", "fa-solid fa-gauge-high", "#eff6ff", "#2563eb"),
    (r"uptime|kuma|health|ping|status", "fa-solid fa-heart-pulse", "#f0fdf4", "#16a34a"),
    (r"cockpit|admin|dash|control|settings|panel", "fa-solid fa-sliders", "#fef2f2", "#dc2626"),
    (r"code|vscode|git|dev|ide|gitlab|github", "fa-solid fa-code", "#f0f9ff", "#0284c7"),
    (r"jellyfin|plex|media|video|tv|movie|stream", "fa-solid fa-tv", "#fff7ed", "#ea580c"),
    (r"vmware|proxmox|hypervisor|server|node|cluster", "fa-solid fa-server", "#f0fdf4", "#16a34a"),
    (r"web|apache|nginx|http|site|portal", "fa-solid fa-globe", "#f0f9ff", "#0284c7"),
    (r"database|db|sql|postgres|mysql|redis|mongo", "fa-solid fa-database", "#faf5ff", "#9333ea"),
    (r"nas|disk|storage|truenas|synology|drive|s3|minio", "fa-solid fa-hard-drive", "#fffbeb", "#d97706"),
    (r"auth|vault|key|pass|shield|vpn|wireguard|firewall", "fa-solid fa-shield-halved", "#f0fdf4", "#16a34a"),
    (r"net|wifi|router|pihole|dns|switch|dhcp", "fa-solid fa-network-wired", "#eff6ff", "#2563eb"),
    (r"docker|container|k8s|pod|portainer", "fa-solid fa-cubes", "#eff6ff", "#2563eb"),
    (r"cloud|nextcloud|owncloud", "fa-solid fa-cloud", "#f0f9ff", "#0284c7"),
]


def resolve_caddyfile():
    """Detect Caddyfile path from environment or standard locations."""
    env_path = os.environ.get("CADDYFILE_PATH")
    candidates = [
        env_path,
        "/etc/caddy/Caddyfile",
        "/etc/caddy",
        "/caddy/Caddyfile",
        "/caddy",
        "./Caddyfile",
    ]
    for loc in candidates:
        if not loc:
            continue
        p = Path(loc)
        if p.is_file():
            return str(p)
        if p.is_dir():
            target = p / "Caddyfile"
            if target.is_file() or loc == env_path:
                return str(target)

    return env_path or "./Caddyfile"


def resolve_index_html():
    """Detect index.html path from environment or standard location."""
    return os.environ.get("OUTPUT_PATH") or "./index.html"


def normalize_icon(icon_str):
    """Normalize icon name to Font Awesome class format."""
    icon = (icon_str or "").strip()
    if not icon:
        return ""
    if re.match(r"^fa-(solid|regular|brands)\s+", icon):
        return icon
    if icon.startswith("fa-"):
        return f"fa-solid {icon}"
    return f"fa-solid fa-{icon}"


def parse_caddyfile(caddyfile_path):
    """Parse Caddyfile for site blocks, reverse_proxy directives, and comment annotations."""
    if not os.path.isfile(caddyfile_path):
        return []

    try:
        with open(caddyfile_path, "r", encoding="utf-8") as f:
            lines = f.readlines()
    except Exception as e:
        print(f"Error reading {caddyfile_path}: {e}", file=sys.stderr)
        return []

    services = []
    pending_title = ""
    pending_icon = ""
    current = None

    for line in lines:
        s = line.strip()
        if not s:
            continue

        # Comments and directives (# title: ..., # icon: ...)
        if s.startswith("#"):
            comment = s.lstrip("#").strip()
            if m := re.match(r"^icon[:=]\s*(.*)$", comment, re.I):
                if current:
                    current["icon"] = m.group(1).strip()
                else:
                    pending_icon = m.group(1).strip()
            elif m := re.match(r"^title[:=]\s*(.*)$", comment, re.I):
                if current:
                    current["title"] = m.group(1).strip()
                else:
                    pending_title = m.group(1).strip()
            elif not current:
                pending_title = comment
            continue

        # Skip global options '{' and snippet blocks '(name) {'
        if not current and (s == "{" or s.startswith("(")):
            continue

        # Start of a site block (e.g. 'domain.com {')
        if not current and "{" in s:
            site = s.split("{")[0].strip()
            if site and not re.match(r"^(import|log|root)\b", site):
                current = {
                    "site": site,
                    "title": pending_title,
                    "icon": pending_icon,
                    "proxy": "",
                }
                pending_title = ""
                pending_icon = ""
            continue

        # Inside a site block
        if current:
            if s == "}":
                services.append(current)
                current = None
            elif m := re.match(r"^reverse_proxy\s+(.*)$", s):
                proxy_val = m.group(1).split("{")[0].split("#")[0].strip()
                current["proxy"] = proxy_val

    if current:
        services.append(current)

    return services


def generate_entries_html(services):
    """Build HTML card entries for parsed services."""
    cards = []
    for idx, s in enumerate(services):
        site = s["site"]
        domain = re.sub(r"^https?://", "", site).rstrip("/")
        if domain.endswith(":443"):
            domain = domain[:-4]

        if site.startswith("http://") or site.startswith("https://"):
            url = site
        elif ":80" in site:
            url = f"http://{site}"
        else:
            url = f"https://{domain}"

        title = s["title"] or domain.split(".")[0].replace("-", " ").replace("_", " ").title()
        proxy = re.sub(r"^https?://", "", s["proxy"]).strip() or domain

        palette_bg, palette_fg = PALETTES[idx % len(PALETTES)]
        icon = normalize_icon(s["icon"])
        bg, fg = palette_bg, palette_fg

        if not icon:
            search_str = f"{title} {domain}".lower()
            for pattern, icon_class, c_bg, c_fg in KEYWORD_ICON_RULES:
                if re.search(pattern, search_str):
                    icon = icon_class
                    bg, fg = c_bg, c_fg
                    break
            if not icon:
                icon = DEFAULT_ICONS[idx % len(DEFAULT_ICONS)]

        cards.append(f"""        <a href="{url}" target="_blank" rel="noopener noreferrer" class="service-card" title="Open {domain}">
          <div class="card-icon" style="background-color: {bg}; color: {fg};">
            <i class="{icon}"></i>
          </div>
          <div class="card-info">
            <h3 class="card-title">{title}</h3>
            <div class="card-detail">
              <span class="detail-label">Address:</span>
              <span class="detail-value">{proxy}</span>
            </div>
            <div class="card-detail">
              <span class="detail-label">Domain:</span>
              <span class="detail-value domain-value">{domain}</span>
            </div>
          </div>
        </a>""")

    return "\n".join(cards)


def update_index_html(caddyfile_path=None, html_path=None):
    """Read Caddyfile and create/update entries in index.html."""
    caddyfile_path = caddyfile_path or resolve_caddyfile()
    html_path = html_path or resolve_index_html()

    if not os.path.isfile(html_path):
        print(f"Template {html_path} not found.", file=sys.stderr)
        return 0

    services = parse_caddyfile(caddyfile_path)
    count = len(services)
    scan_time = datetime.now().strftime("%m/%d/%Y, %I:%M:%S %p")
    entries_html = generate_entries_html(services)

    with open(html_path, "r", encoding="utf-8") as f:
        html = f.read()

    # Update services grid
    grid_inner = f"\n{entries_html}\n        " if entries_html else "\n        <!-- SERVICES_PLACEHOLDER -->\n        "
    html = re.sub(
        r'(<!-- SERVICES_START -->).*?(<!-- SERVICES_END -->)',
        r'\g<1>' + grid_inner + r'\g<2>',
        html,
        flags=re.DOTALL
    )

    # Update status indicators
    html = re.sub(r'<strong>\d+</strong> Services Active', f'<strong>{count}</strong> Services Active', html)
    html = re.sub(r'<span class="badge-count">\d+</span>', f'<span class="badge-count">{count}</span>', html)
    html = re.sub(r'<span class="scan-time">Last scan: [^<]+</span>', f'<span class="scan-time">Last scan: {scan_time}</span>', html)

    with open(html_path, "w", encoding="utf-8") as f:
        f.write(html)

    print(f"Updated {html_path} with {count} services from {caddyfile_path}")
    return count


_last_mtime = None


def check_and_update(caddyfile_path, html_path):
    """Check if Caddyfile has changed and update index.html."""
    global _last_mtime
    target = caddyfile_path
    if os.path.isdir(target):
        target = os.path.join(target, "Caddyfile")

    if os.path.isfile(target):
        try:
            mtime = os.path.getmtime(target)
            if mtime != _last_mtime:
                _last_mtime = mtime
                update_index_html(target, html_path)
        except OSError:
            pass
    elif _last_mtime is not None:
        _last_mtime = None
        update_index_html(target, html_path)


def watch_and_update(caddyfile_path, html_path, interval=5):
    """Background loop to periodically sync index.html with Caddyfile every 5 seconds."""
    while True:
        try:
            check_and_update(caddyfile_path, html_path)
        except Exception as e:
            print(f"Watcher error: {e}", file=sys.stderr)
        time.sleep(interval)


def run_server(port=80):
    """Serve static directory and watch Caddyfile for changes."""
    caddy_target = resolve_caddyfile()
    html_target = resolve_index_html()
    serve_dir = str(Path(html_target).parent.resolve())

    # Initial update (handles case where Caddyfile is present or not yet mounted)
    check_and_update(caddy_target, html_target)
    if not os.path.isfile(caddy_target):
        update_index_html(caddy_target, html_target)

    # Background watcher thread running every 5 seconds
    watcher = threading.Thread(
        target=watch_and_update,
        args=(caddy_target, html_target, 5),
        daemon=True
    )
    watcher.start()

    class DashboardHandler(SimpleHTTPRequestHandler):
        def address_string(self):
            # Disable slow reverse DNS lookups on client IP in Docker
            return self.client_address[0]

        def do_GET(self):
            if self.path in ("/", "/index.html"):
                check_and_update(caddy_target, html_target)
            super().do_GET()

        def end_headers(self):
            if self.path in ("/", "/index.html"):
                self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
                self.send_header("Pragma", "no-cache")
                self.send_header("Expires", "0")
            super().end_headers()

    print(f"[caddy-dashboard] Serving {serve_dir} on port {port} (watcher refresh every 5s)...")
    httpd = ThreadingHTTPServer(("", port), lambda *args, **kwargs: DashboardHandler(*args, directory=serve_dir, **kwargs))
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n[caddy-dashboard] Server stopped.")
        httpd.server_close()


if __name__ == "__main__":
    port_env = os.environ.get("PORT")
    port = int(port_env) if port_env else 80

    if "--serve" in sys.argv or "-s" in sys.argv or os.environ.get("SERVE") == "1":
        run_server(port)
    else:
        update_index_html()
