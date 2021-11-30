## My version of linuxserver VS Code Server for web
Docker will build by default image for AMD64  architecture <br>
To run docker build on ARM v7 run 'docker build -t codeonlan --build-arg "ARCH=/scriptarm.sh" . ' <br>
or change in dockerfile parameter to 'ARG ARCH=/scriptarm.sh' <br>

Script will change default user from abc to vsadmin and install powershell, docker client, terraform ,(Azure Cli - currently only on AMD64 architecture)

Default user: vsadmin <br>
Default website password: <b>orange!</b><br>
To change it enter new in /home/vsadmin/.config/code-server/config.yaml

Default internal port is 80<br>
Default external port in docker compose is 8080

User admin is added to sudoers file and is able to run commands without password but<br>
if you need to change shell password run: <b> docker exec -it col passwd vsadmin </b>

### Currently the AZ Cli installation is stopped for ARM
### Size of build image is around 1.56GB
