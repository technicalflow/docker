#!/usr/bin/env python
from flask import Flask, request

application = Flask(__name__)

@application.route("/")
def geturlfunction():
    return f"{request.url}\n"

if __name__ == "__main__":
    application.run(host="0.0.0.0")

# request.url
# request.remote_addr
# request.headers