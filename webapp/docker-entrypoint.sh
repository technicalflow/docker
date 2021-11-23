#!/bin/sh

set -e

style="padding: 20px;"
COLOR="Blue"

HOSTNAME=$(cat /etc/hostname)
DISTRO=$(cat /etc/os-release  | grep PRETTY | cut -c 13-50)
# NGINX_VERSION=$(/usr/sbin/nginx -v)

sed -i '/<br>/ i <h2>Distribution: '"$DISTRO"'<\/h2>' /usr/share/nginx/html/index.html
sed -i '/Distribution/ i <h2>Hostname: '"$HOSTNAME"'<\/h2>' /usr/share/nginx/html/index.html
# sed -i '/Hostname/ i <h2>'"$NGINX_VERSION"'<br>' /usr/share/nginx/html/index.html

tmpfile=$(mktemp -p /tmp)
echo '<h2>Container IP: ' > /tmp/IP
#ip a | grep inet |  grep -v 127 | cut -c 10-22 | tail -n 3 >> /tmp/IP
#awk '/32 host/ { print f } {f=$2}' << < "$(</proc/net/fib_trie)" |  grep -v 127 | tail -n 3 >> /tmp/IP
awk '/32 host/ { print f } {f=$2}' /proc/net/fib_trie | sort | uniq | grep -v 127 >> /tmp/IP
echo '</h2>' >> /tmp/IP

src="https://www.docker.com/sites/default/files/social/docker_facebook_share.png"
alt="$(echo $COLOR)  container"
echo "<img style=\""$style"\" src=\""$src"\" alt=\""$alt"\">" > $tmpfile

sed -i '/Hello/ r '"$tmpfile"'' /usr/share/nginx/html/index.html
sed -i '/Distribution/ r '"/tmp/IP"'' /usr/share/nginx/html/index.html

rm -rf /tmp/"${tmpfile}"
rm -rf /tmp/IP

# echo DONE
exec "$@"
