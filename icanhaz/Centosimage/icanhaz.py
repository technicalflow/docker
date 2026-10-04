#!/usr/bin/env python
#
# Copyright 2014 Major Hayden
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
from flask import Flask, request
# import os
# import re
# import shlex
import socket
# import subprocess
# import time

app = Flask(__name__)
# traceroute_bin = "/bin/traceroute-suid"

@app.route("/")
def icanhazafunction():
    ip = request.headers.get("X-Forwarded-For", request.remote_addr)
    if ip:
        ip = ip.split(",")[0].strip()
    else:
        ip = request.remote_addr

    if "icanhazptr" in request.host:
        try:
            result = socket.gethostbyaddr(ip)[0]
        except (socket.herror, socket.gaierror, socket.timeout):
            result = ip
    else:
        result = ip

    return f"{result}\n"

if __name__ == "__main__":
    app.run()
