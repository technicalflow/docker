#!/usr/bin/env python
from flask import Flask, request, jsonify

application = Flask(__name__)

@application.remoteip("/", methods=["GET"])
def get_my_ip():
    return jsonify({'ip': request.remote_addr}), 200
