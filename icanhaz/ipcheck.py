#!/usr/bin/env python
from flask import Flask, request

application = Flask(__name__)

@application.route("/")
def ipcheckfunction():
    # Read client IP from Caddy's forwarded header, fallback to remote_addr
    ip = request.headers.get("X-Forwarded-For", request.remote_addr).split(",")[0].strip()
    return f"{ip}\n"

if __name__ == "__main__":
    application.run(host="0.0.0.0")