#!/bin/sh
set -e

# Gather container runtime metadata
HOSTNAME=$(cat /etc/hostname 2>/dev/null)

# Detect Linux distribution
DIST=$(cat /etc/os-release | grep PRETTY | cut -c 13-50 | sed 's/\// /' | cut -c 1-20)

# Detect container IP address
IP=$(awk '/32 host/ { print f } {f=$2}' /proc/net/fib_trie | sort | uniq | grep -v 127 | sed ':a; N; $!ba; s/\n/ /g')

# Prepare endpoint directories
mkdir -p /usr/local/apache2/htdocs/host /usr/local/apache2/htdocs/ip

# Write plain text endpoint responses for curl checking
echo "Hostname: $HOSTNAME" > /usr/local/apache2/htdocs/host/index.html
echo "IP: $IP" > /usr/local/apache2/htdocs/ip/index.html

# Generate main website landing page
cat << EOF > /usr/local/apache2/htdocs/index.html
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
            background-color: azure;
        }
    </style>
</head>
<body>
    <h2>Hello World !</h2>
    <img style="padding: 20px;" src="https://github.com/technicalflow/docker/raw/master/Docker.png" alt="Blue container"><br>
    <h2>Hostname: $HOSTNAME</h2>
    <h2>Distribution: $DIST</h2>
    <h2>Container IP: $IP</h2><br>
</body>
</html>
EOF

exec "$@"
