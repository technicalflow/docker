# My docker test environment
Most of the working images can be found on https://hub.docker.com/u/techfellow
### centosssh
    This container doesn't do anything except run the sshd daemon.
    It can be used as an isolated environment accessed remotely to retrieve or drop files for archival.
    Volume-mounted storage can be provided as persistent storage.
### code-on-lan
    My version of VS Code server for web for AMD64 and ARM architectures
    Installs Docker Client, Terraform and Powershell with Az module
### dokuwiki
    Docker compose file for personal wiki - dokuwiki.org
### haproxy
    Docker compose file to show load balancing ability on single docker node.
    Require Docker-compose version 2.
### icanhaz
    My dockerfile version of popular icanhazip.com website to show source IP address.
### kuma
    Status page for local and remote infrastructure
### librespeed
    Simple tool to measure network speed.
### heimdall
    Docker compose file for heimdall link landing page
### nginx
    As simple as can be nginx docker compose file
### pihole
    Docker Compose file for popular DNS server PiHole
### portainer
    Docker compose and Docker stack file for Portainer.io to manage your environment
### pwsharm
    My version of quickly accessible Powershell 7 docker container with AZ module for ARM
### pwshpc
    My version of quickly accessible Powershell 7 docker container with AZ module for PC
### traefik
    Docker compose file with traefik reverse proxy created to show capabilities of load balancing in docker
### unifi
    Unifi controller docker compose file
### webapp
    Website to show Docker Stack load balancing capabilities in Docker Swarm mode. Two options - as a debian or alpine edition.
