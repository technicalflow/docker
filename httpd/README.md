# Apache HTTPD Load Balancing Demo

Lightweight Apache HTTPD container designed to demonstrate and verify load balancing across multiple replicas using **Docker Swarm routing mesh**, **Docker Compose**, or external reverse proxies (e.g. HAProxy, Nginx).

The container runs as an unprivileged user (`www-data`) and dynamically generates landing pages and plain text endpoints displaying the active container's identity.

---

## Endpoints

| Endpoint | Method | Response Example | Description |
| :--- | :--- | :--- | :--- |
| `/` | `GET` | HTML Page | Visual dashboard with container image, Hostname, OS, and IP |
| `/host/` | `GET` | `Hostname: 64f30d9a9878` | Plain text endpoint for automated scripting & testing |
| `/ip/` | `GET` | `IP: 172.17.0.2` | Plain text endpoint showing container internal IP |

---

## Usage

### 1. Build Image Locally
```bash
docker build -t techfellow/httpdappa:latest .
```

### 2. Run with Docker Compose
Start the service with Docker Compose:
```bash
docker compose up -d
```
Scale instances horizontally across port range `8081-8085`:
```bash
docker compose up -d --scale website=3
```

### 3. Deploy in Docker Swarm (Ingress Load Balancing)
Deploy 6 replicas using the Swarm ingress routing mesh:
```bash
docker stack deploy -c dockerstack.yml website
```

Check running tasks:
```bash
docker stack ps website
```

---

## Verifying & Counting Load Balanced Requests

When deployed in Swarm mode (or behind an upstream proxy), the Swarm ingress routing mesh automatically distributes requests in a round-robin fashion across replicas.

Send multiple requests and count distribution per replica using `sort | uniq -c`:

```bash
# Verify hostname distribution across 30 requests
for i in {1..30}; do curl -s http://localhost:8081/host/; done | sort | uniq -c
```

**Example Output:**
```text
      5 Hostname: 18b76ce83d12
      5 Hostname: 37f191a27e33
      5 Hostname: 44e3925a6b74
      5 Hostname: 5ac642e39198
      5 Hostname: 82df3125d012
      5 Hostname: 99a12c448fe1
```

You can also count by IP address:
```bash
for i in {1..30}; do curl -s http://localhost:8081/ip/; done | sort | uniq -c
```

---

## Clean Up

- **Docker Compose:**
  ```bash
  docker compose down
  ```
- **Docker Swarm:**
  ```bash
  docker stack rm website
  ```
