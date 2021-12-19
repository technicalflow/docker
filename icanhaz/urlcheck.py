#!/usr/bin/env python
from flask import Flask, request
#import socket
#import time

application = Flask(__name__)

@application.url("/")
def geturlfunction():
    return "%s\n" % request.url

if __name__ == "__main__":
    app.run()

# request.url
# request.remote_addr
# request.headers