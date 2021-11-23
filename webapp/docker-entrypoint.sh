#!/bin/bash

set -e

style="padding: 20px;"
src=""
alt=""
COLOR="Blue"

# Cater for legacy version of image that required a bind mount of the host's
# /etc/hostname onto /etc/docker-hostname inside the container
NODE_NAME=$(cat /etc/hostname)
DISTRO=$(cat /etc/os-release  | grep PRETTY | cut -c 13-50)
#NGINX_VERSION=$(curl -sI localhost |grep Server)
#IP=$(awk '/32 host/ { print f } {f=$2}' <<< "$(</proc/net/fib_trie)" |  grep -v 127)

# Add 'Node Name' to static HTML page if NODE_NAME has been set

#sed -i '/<br>/ i <h2>Nginx Version: '"$NGINX_VERSION"'<\/h2>' /usr/share/nginx/html/index.html
#sed -i '/Nginx/ i <h2>IP: '"$IP"'<\/h2>' /usr/share/nginx/html/index.html
sed -i '/<br>/ i <h2>Distribution: '"$DISTRO"'<\/h2>' /usr/share/nginx/html/index.html
sed -i '/Distribution/ i <h2>Node Name: '"$NODE_NAME"'<\/h2>' /usr/share/nginx/html/index.html

# Create a temporary file for holding the entire image tag, which may cotain a
# base64 encoded image embedded in the src attribute
tmpfile=$(mktemp -p /tmp)
echo '<h2>Container IP: ' > /tmp/IP
#ip a | grep inet |  grep -v 127 | cut -c 10-22 | tail -n 3 >> /tmp/IP
awk '/32 host/ { print f } {f=$2}' <<< "$(</proc/net/fib_trie)" |  grep -v 127 | tail -n 3 >> /tmp/IP
echo '</h2>' >> /tmp/IP

# Construct the src and alt attributes of the img tag, and write the tag to the
# temporary file
src="https://www.docker.com/sites/default/files/social/docker_facebook_share.png"
alt="$(echo $COLOR)  container"
echo "<img style=\""$style"\" src=\""$src"\" alt=\""$alt"\">" > $tmpfile

# Insert the image tag into the index.html file and remove the temporary file
sed -i '/Hello/ r '"$tmpfile"'' /usr/share/nginx/html/index.html
sed -i '/Distribution/ r '"/tmp/IP"'' /usr/share/nginx/html/index.html
#sed -i '/<br>/ r '"/tmp/nginxversion"'' /usr/share/nginx/html/index.html

rm -rf /tmp/"${tmpfile}"
rm -rf /tmp/IP
#rm -rf /tmp/nginxversion

echo DONE
# Exec what has been supplied as arguments for the container/pod
# (default: "/usr/local/nginx/sbin/nginx", "-g", "daemon off;")
exec "$@"
