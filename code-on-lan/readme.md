## My version of linuxserver VS Code Server for web
Docker will build by default image for AMD64  architecture
To run docker build on ARM v7 run 'docker build -t reponame/imagename --build-arg ARG=/scriptarm.sh .'
or change in dockerfile parameter to 'ARG ARCH=/scriptarm.sh'

Default password is orange!
To change it enter new in /home/admin/.config/code-server/config.yaml

Script will change default user from abc to admin and install powershell, docker client, terraform and Az Cli (currently only on AMD64 arch)

Default port is 8080

User admin is added to sudoers file and is able to run commands without password but
if you need to change shell password run 
docker exec -it col passwd admin

# Currently the AZ Cli installation is stopped for ARM
# Size of image will be 2.68GB
