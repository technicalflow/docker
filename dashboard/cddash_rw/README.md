# Caddy Reverse Proxy Dashboard - Caddyfile read and write

## Quick Start

### 1. Run with Docker Compose
```bash
docker compose up -d
```

Open your browser at `http://localhost:8080`.

### 2. Run with Docker CLI

```bash
docker build -t caddy-dashboard .
docker run -d \
  --name caddy-dashboard \
  -p 8080:80 \
  -v /path/to/caddy/folder:/etc/caddy:ro \
  caddy-dashboard
```
---

## Caddyfile is editable
By adding serive using 'Add Service' button you are edditing Caddyfile and adding new entries to it. Make sure your Caddy server reloads properly

---

## Sharing Your Caddyfile

You can mount your host's Caddy directory or single `Caddyfile` as a folder share:

```yaml
volumes:
  # Share host folder containing Caddyfile:
  - /path/to/caddy-directory:/etc/caddy:ro
```

Whenever the `Caddyfile` is edited on the host, the container automatically regenerates the view within seconds. If the `Caddyfile` has no services configured, the dashboard gracefully displays an empty view.
