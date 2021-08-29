## My version of linuxserver VS Code Server for web
Docker will build by default image for AMD64  architecture <br>
To run docker build on ARM v7 run 'docker build -t reponame/imagename --build-arg ARG=/scriptarm.sh .' <br>
or change in dockerfile parameter to 'ARG ARCH=/scriptarm.sh' <br>

Default password is orange!<br>
To change it enter new in /home/admin/.config/code-server/config.yaml

Script will change default user from abc to admin and install powershell, docker client, terraform and Az Cli (currently only on AMD64 arch)

Default internal port is 80<br>
Default external port in docker compose is 8080

User admin is added to sudoers file and is able to run commands without password but<br>
if you need to change shell password run <br>
docker exec -it col passwd admin

### Currently the AZ Cli installation is stopped for ARM
### Size of image will be 2.68GB
