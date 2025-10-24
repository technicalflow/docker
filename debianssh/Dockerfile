# This container doesn't do anything except run the sshd daemon. It can be used
# as a contained environment accessed remotely to retrieve or drop files for
# archival.
FROM debian:stable
LABEL MAINTAINER 'marek from mysmall.cloud'

# User we'll use to login with
ENV USER sshadmin

# Update and install required packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y openssh-server rsync sudo dialog
# RUN yum -y update && yum -y install openssh-server rsync && yum clean all

# Create needed SSH keys
# RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
# ENTRYPOINT [ "cat /etc/ssh/ssh_host_rsa_key" ] 

# Setup for certificate login ONLY
RUN sed -i -e 's/#LogLevel INFO/LogLevel INFO/' \
           -e 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' \
           -e 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' \
           -e 's/#PasswordAuthentication yes/PasswordAuthentication no/' \
           -e 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' \
           /etc/ssh/sshd_config

RUN useradd -m $USER -s /bin/bash; mkdir -p /run/sshd

# User option
COPY key.pub /home/sshadmin/.ssh/authorized_keys
RUN chmod -R 644 /etc/ssh/ssh_host_* && chown -R $USER:$USER /home/$USER/.ssh && echo $USER 'ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/$USER

EXPOSE 22
# User option
USER sshadmin

CMD ["/usr/sbin/sshd", "-D"]
