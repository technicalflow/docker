#!/bin/bash
PLATFORM=linux
ARCH=ARMv7

echo 'Install script for $PLATFORM $ARCH environment'

set -e
export DEBIAN_FRONTEND=noninteractive
export HOME="/home/vsadmin"

echo "Europe/Warsaw" > /etc/timezone

echo "**** update ****" 
# update and tools installation
apt update
apt upgrade -y
apt install mc tmux htop mtr-tiny nano wget iputil* net-tools nmap dialog -y
apt-get install ca-certificates curl apt-transport-https lsb-release gnupg libssl-dev libffi-dev python3-dev build-essential git libunwind8 libicu60 less tzdata ansible -y

echo "**** powershell ****" 
# powershell
PS_VERSION=7.2.0
PS_ARCH=arm32
PS_PACKAGE=powershell-$PS_VERSION-linux-$PS_ARCH.tar.gz
curl -fsSL https://github.com/PowerShell/PowerShell/releases/download/v$PS_VERSION/$PS_PACKAGE -o /config/$PS_PACKAGE
# wget https://github.com/PowerShell/PowerShell/releases/download/v7.1.3/powershell-7.1.3-linux-arm32.tar.gz -o /config/powershell-7.1.3-linux-arm32.tar.gz
mkdir -p /usr/local/share/pwsh/
tar -xzf /config/$PS_PACKAGE -C /usr/local/share/pwsh/
ln -s /usr/local/share/pwsh/pwsh /usr/bin/pwsh
rm -rf /config/$PS_PACKAGE

echo "**** powershell module az ****" 
# pwsh install az module
pwsh -command set-psrepository -name PSGallery -installationpolicy trusted
pwsh -command update-module
pwsh -command install-module az -force

echo "**** docker ****" 
# docker
DOCKER_VERSION=20.10.8
DOCKER_ARCH=armhf
DOCKER_PACKAGE=docker-$DOCKER_VERSION.tgz
curl -fsSL https://download.docker.com/linux/static/stable/$DOCKER_ARCH/$DOCKER_PACKAGE -o /config/$DOCKER_PACKAGE
tar -xzf /config/$DOCKER_PACKAGE -C /usr/local/share/
ln -s /usr/local/share/docker/docker /usr/bin/docker
rm -rf /config/$DOCKER_PACKAGE

# echo "**** AZ CLI ****"
# # Azure CLI installation
# curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

echo "**** Terraform ****" 
# terraform
TF_VERSION=1.0.11
TF_PACKAGE=terraform_1.0.11_linux_arm.zip
curl -fsSL https://releases.hashicorp.com/terraform/$TF_VERSION/$TF_PACKAGE -o /config/$TF_PACKAGE
sudo unzip /config/$TF_PACKAGE -d /usr/bin/
rm -rf /config/$TF_PACKAGE

echo "**** Cleanup ****" 
#Cleanup
apt-get autoremove -y
apt-get purge -y
apt-get clean
userdel abc
rm -rf /app
rm -rf /defaults

echo "**** Creating User ****"
useradd -d /home/vsadmin -s /bin/bash vsadmin && \
usermod -aG users,sudo vsadmin

echo "**** Files ****" 
#Files
touch /home/vsadmin/.bashrc
echo "
HISTSIZE=2000
HISTFILESIZE=2000

export EDITOR='nano'
export PATH="$PATH:/usr/local/bin/"
export PATH="/usr/local/git/bin:/sw/bin/:/usr/local/bin:/usr/local/:/usr/local/sbin:/usr/local/mysql/bin:$PATH"

export PATH=$PATH:/usr/local/share/az
alias ttn='tmux attach -t new' " >> /home/vsadmin/.bashrc

touch /home/vsadmin/.selected_editor
cat << EOFnano > /home/vsadmin/.selected_editor
# Generated by /usr/bin/select-editor
SELECTED_EDITOR="/bin/nano"
EOFnano

mkdir -p /home/vsadmin/.config/code-server/
touch /home/vsadmin/.config/code-server/config.yaml
cat << EOFconfiguration > /home/vsadmin/.config/code-server/config.yaml
bind-addr: 127.0.0.1:8080
auth: password
password: orange!
cert: false
EOFconfiguration

cat << EOFtmux > /home/vsadmin/.tmux.conf
unbind %
bind | split-window -h
bind - split-window -v

set -g prefix C-l
unbind C-b
bind C-l send-prefix

# new-session -n $HOST
# set -g mouse on
# set -s escape-time 0

set -g status-interval 60
set -g default-terminal "screen-256color"

setw -g clock-mode-colour white

# Set status bar
set -g status-bg colour8
set -g status-fg white
set -g status-justify left
set -g status-right-length 80
set -g status-left-length 60
set -g status-right "#[fg=yellow]%H:%M | %d/%m"
set -g status-left  "#[fg=green]#H "
set -g terminal-overrides xterm*:smcup@:rmcup@

# setw -g window-status-bell-style 'fg=colour255 bg=colour1 bold'
EOFtmux

echo DONE
rm -rf /scriptpc.sh
rm -rf /scriptarm.sh