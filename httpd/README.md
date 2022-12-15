## Sample website to show Docker Stack or Docker compose load balancing capabilities in Docker Swarm mode
#

Container is running in user mode <br>

``docker build -t website . ``<br>
``docker run -d -p 80:80 website``<br>
or <br>
``docker stack deploy -c dockerstack.yml website ``<br><br>

New option to check only Hostname or IP with curl 

``$ curl -s localhost/ip/ ``

`` IP: 172.17.0.2 ``

``$ curl -s localhost/host/ ``

``Hostname: 64f30d9a9878 ``
<br>
