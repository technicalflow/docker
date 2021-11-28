#!/bin/sh

set -e

cat << EOFhtml > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>
Docker Website !
</title>
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
<img style="padding: 20px;" src="https://www.docker.com/sites/default/files/social/docker_facebook_share.png" alt="Blue container">
<br>
<h2>Hostname: </h2>
<h2>Distribution: </h2>
<h2>Container IP: </h2>
<br>
</body>
</html>
EOFhtml

HOSTNAME=$(cat /etc/hostname)
DISTRO=$(cat /etc/os-release  | grep PRETTY | cut -c 13-50)
DI=$(echo $DISTRO | sed 's/\// /')
IP=$(awk '/32 host/ { print f } {f=$2}' /proc/net/fib_trie | sort | uniq | grep -v 127)
# NGINX_VERSION=$(/usr/sbin/ngintx -v)

#ip a | grep inet |  grep -v 127 | cut -c 10-22 | tail -n 3 >> /tmp/IP
#awk '/32 host/ { print f } {f=$2}' << < "$(</proc/net/fib_trie)" |  grep -v 127 | tail -n 3 >> /tmp/IP
#awk '/32 host/ { print f } {f=$2}' /proc/net/fib_trie | sort | uniq | grep -v 127 > /IP
#sed -i 's/\// /' 

#sed ' {n;/<h2>Hostname: </h2>/ {s/is/was/}}' /usr/share/nginx/html/index.html
sed -i 's/<h2>Distribution:.*/<h2>Distribution: '"$DI"'<\/h2>/' /usr/share/nginx/html/index.html
sed -i 's/<h2>Hostname:.*/<h2>Hostname: '"$HOSTNAME"'<\/h2>/' /usr/share/nginx/html/index.html
sed -i 's/<h2>Container IP:.*/<h2>Container IP: '"$IP"'<\/h2>/' /usr/share/nginx/html/index.html

# echo DONE
exec "$@"
