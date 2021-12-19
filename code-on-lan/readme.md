## My version of linuxserver VS Code Server for web
Docker will build by default image for AMD64  architecture <br>
Now script.sh file recognize x86_64 or armv7 processor and apply arguments appropriately. <br>

<strike>To run docker build on ARM v7 run 'docker build -t codeonlan --build-arg "ARCH=/scriptarm.sh" . ' <br>
or change in dockerfile parameter to 'ARG ARCH=/scriptarm.sh' <br></strike>

Script will change default user from abc to vsadmin and install powershell, docker client, terraform, Azure Cli (AZ Cli currently works only on x86_64 architecture)<br>

Default user: vsadmin <br>
Default website password: <b>orange!</b><br>
To change it enter new in /home/vsadmin/.config/code-server/config.yaml

Default internal port is 80<br>
Default external port in docker compose is 8080

User vsadmin is added to sudoers file and is able to run commands without password but<br>
if you need to change shell password run: <b> docker exec -it col passwd vsadmin </b>

### Currently the AZ Cli installation is stopped for ARM environment.
### Size of build image is around 1.5GB for ARM and 2.7GB for x86 system.
