#!/usr/bin/env python
from flask import Flask, request

application = Flask(__name__)

@application.route("/")
def ipcheckfunction():
    return "%s\n" % request.remote_addr

if __name__ == "__main__":
    app.run()

# request.url
# request.remote_addr
# request.headers