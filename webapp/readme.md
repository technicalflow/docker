# Sample website to show Docker Stack load balancing capabilities in Docker Swarm mode
Container is running in user mode
docker build -t website .
docker stack deploy -c dockerstack.yml website

<img src=./static/image.png>