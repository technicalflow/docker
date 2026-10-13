FROM python:3-alpine

WORKDIR /app

# Copy application files
COPY generate.py /app/generate.py
COPY style.css /app/style.css
COPY index.html /app/index.html

# Environment variables
ENV PYTHONUNBUFFERED=1 \
    CADDYFILE_PATH=/etc/caddy \
    PORT=80

EXPOSE 80

CMD ["python3", "/app/generate.py", "--serve"]
