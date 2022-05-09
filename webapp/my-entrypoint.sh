#!/bin/sh

set -x

cat << EOFhtml > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html><head>
<title>Docker Website !</title>
<style>
    body {
        width: 30em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
        text-align: center;
        background-color: liteyellow;
    }
</style></head>
<body>
<h2>Hello World !</h2>
<img style="padding: 20px;" src="https://www.docker.com/wp-content/uploads/2021/09/Moby-share-900x551.png.webp" alt="Blue container"><br>
<h2>Hostname: </h2>
<h2>Distribution: </h2>
<h2>Container IP: </h2><br>
</body></html>
EOFhtml

mkdir -p /usr/share/nginx/html/host
cat << EOFhost > /usr/share/nginx/html/host/index.html
<h2>Hostname: </h2>
EOFhost

HOSTNAME=$(cat /etc/hostname)
DISTRO=$(cat /etc/os-release | grep PRETTY | cut -c 13-50)
DIST=$(echo $DISTRO | sed 's/\// /' | cut -c 1-20)
IP=$(awk '/32 host/ { print f } {f=$2}' /proc/net/fib_trie | sort | uniq | grep -v 127 | sed ':a; N; $!ba; s/\n/ /g')
# NGINX_VERSION=$(/usr/sbin/nginx -v)
# NGINX_ALPINE=$(apk info -q nginx  | grep nginx | head -q -c 15)
# NGINX_DEBIAN=$(apt info nginx | grep Version)

#ip a | grep inet |  grep -v 127 | cut -c 10-22 | tail -n 3 >> /tmp/IP
#awk '/32 host/ { print f } {f=$2}' << < "$(</proc/net/fib_trie)" |  grep -v 127 | tail -n 3 >> /tmp/IP
#awk '/32 host/ { print f } {f=$2}' /proc/net/fib_trie | sort | uniq | grep -v 127 > /IP

sed -i 's/<h2>Hostname:.*/<h2>Hostname: '"$HOSTNAME"'<\/h2> /' /usr/share/nginx/html/index.html
sed -i 's/<h2>Distribution:.*/<h2>Distribution: '"$DIST"'<\/h2> /' /usr/share/nginx/html/index.html
# sed -i 's/<h2>Nginx Version:.*/<h2>Nginx Version: '"$NGINX_ALPINE"'<\/h2> /' /usr/share/nginx/html/index.html
sed -i 's/<h2>Container IP:.*/<h2>Container IP: '"$IP"'<\/h2> /' /usr/share/nginx/html/index.html

sed -i 's/<h2>Hostname:.*/<h2>Hostname: '"$HOSTNAME"'<\/h2> /' /usr/share/nginx/html/host/index.html
# echo DONE
exec "$@"
