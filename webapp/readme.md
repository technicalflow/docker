## Sample website to show Docker Stack or Docker Compose load balancing capabilities in Docker Swarm mode
#

For a container image in user mode go with this image: 
https://github.com/technicalflow/docker/tree/master/httpd
<br>

To build an image and run a container
``docker build -t website . ``<br>
``docker run -d -p 80:80 website``<br>
or<br>
``docker stack deploy -c dockerstack.yml website ``<br><br>

New option to check only Hostname or IP with curl 

``$ curl -s localhost/ip/ ``

`` IP: 172.17.0.2 ``

``$ curl -s localhost/host/ ``

``Hostname: 64f30d9a9878 ``
<br>
<br>
<img src=./static/image.png>