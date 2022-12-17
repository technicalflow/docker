# My version of linuxserver VS Code Server for web
`` Now script.sh file recognizes x86_64 or armv7 processor and apply arguments appropriately. `` <br><br>


Script will change default user from abc to vsadmin and install powershell, docker client, terraform, Azure Cli (only on x86_64 architecture)<br>

Default user: vsadmin <br>
Default website password: <b>orange!</b><br>
To change it enter new in /home/vsadmin/.config/code-server/config.yaml

Default internal port is 80<br>
Default external port in docker compose is 8080

User vsadmin is added to sudoers file and is able to run commands without password but<br>
if you need to change shell password run: <b> docker exec -it col passwd vsadmin </b>

### Currently the AZ Cli installation is stopped for ARM environment.
### Size of build image is around 1.5GB for ARM and 2.7GB for x86 system.

Tested on 17.12.2022