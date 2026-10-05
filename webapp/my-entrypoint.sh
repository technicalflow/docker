#!/bin/sh
# set -e

# Gather container information
HOSTNAME=$(cat /etc/hostname)
DIST=$(cat /etc/os-release | grep PRETTY | cut -c 13-50 | sed 's/\// /' | cut -c 1-20)
IP=$(awk '/32 host/ { print f } {f=$2}' /proc/net/fib_trie | sort | uniq | grep -v 127 | sed ':a; N; $!ba; s/\n/ /g')

# NGINX_VERSION=$(/usr/sbin/nginx -v)
# NGINX_ALPINE=$(apk info -q nginx  | grep nginx | head -q -c 15)
# NGINX_DEBIAN=$(apt info nginx | grep Version)

#ip a | grep inet |  grep -v 127 | cut -c 10-22 | tail -n 3 >> /tmp/IP
#awk '/32 host/ { print f } {f=$2}' << < "$(</proc/net/fib_trie)" |  grep -v 127 | tail -n 3 >> /tmp/IP
#awk '/32 host/ { print f } {f=$2}' /proc/net/fib_trie | sort | uniq | grep -v 127 > /IP


# Generate main index.html
cat << EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Docker Website !</title>
    <style>
        body {
            width: 35em;
            margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif;
            text-align: center;
            background-color: lightyellow;
        }
    </style>
</head>
<body>
    <h2>Hello World !</h2>
    <img style="padding: 20px;" src="https://github.com/technicalflow/docker/raw/master/Docker.png" alt="Blue container"><br>
    <h2>Hostname: ${HOSTNAME}</h2>
    <h2>Distribution: ${DIST}</h2>
    <h2>Container IP: ${IP}</h2><br>
</body>
</html>
EOF

# Create host and ip endpoints for easy curl querying
mkdir -p /usr/share/nginx/html/host
echo "Hostname: ${HOSTNAME}" > /usr/share/nginx/html/host/index.html

mkdir -p /usr/share/nginx/html/ip
echo "IP: ${IP}" > /usr/share/nginx/html/ip/index.html

chown -R nginx:nginx /usr/share/nginx/html/

exec "$@"
