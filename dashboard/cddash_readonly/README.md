# Caddy Reverse Proxy Dashboard - Caddyfile read Only

## Quick Start

### 1. Run with Docker Compose

From the `cdd` directory:

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

## Sharing Your Caddyfile

You can mount your host's Caddy directory or single `Caddyfile` as a folder share:

```yaml
volumes:
  # Share host folder containing Caddyfile:
  - /path/to/caddy-directory:/etc/caddy:ro
```

Whenever the `Caddyfile` is edited on the host, the container automatically regenerates the view within seconds. If the `Caddyfile` has no services configured, the dashboard gracefully displays an empty view.
