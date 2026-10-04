FROM python:3.12-alpine

RUN adduser -D -u 1000 appuser

WORKDIR /app
COPY ipcheck.py .

RUN pip install --no-cache-dir flask gunicorn

USER appuser

HEALTHCHECK --interval=1m --timeout=5s CMD wget -q --spider http://127.0.0.1/ || exit 1

EXPOSE 80
# CMD ["gunicorn", "--bind", "0.0.0.0:80", "ipcheck:application"]
CMD ["gunicorn", "--bind", "0.0.0.0:80", "--proxy-protocol", "--proxy-allow-from", "*", "ipcheck:application"]


# For IPv6
# CMD ["gunicorn", "--bind", "[::]:80", "ipcheck:application"]