# This container doesn't do anything except run the sshd daemon. It can be used
# as a contained environment accessed remotely to retrieve or drop files for archival.
FROM debian:stable-slim
LABEL org.opencontainers.image.authors="marek@techfellow.it"

# User we'll use to login with
ENV USER=sshadmin

# Update and install required packages
RUN apt-get update && apt-get install -y openssh-server rsync sudo dialog

# Create needed SSH keys
# RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
# ENTRYPOINT [ "cat /etc/ssh/ssh_host_rsa_key" ] 

# Setup for certificate login ONLY
RUN sed -i -e 's/#LogLevel INFO/LogLevel INFO/' \
    -e 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' \
    -e 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' \
    -e 's/#PasswordAuthentication yes/PasswordAuthentication no/' \
    -e 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' \
    -e 's/UsePAM yes/UsePAM no/' \
    /etc/ssh/sshd_config

# Setup user, sudo permissions, and required directories in one layer
RUN useradd -m $USER -s /bin/bash && passwd -d $USER && echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USER; mkdir -p /run/sshd

COPY --chown=$USER:$USER key.pub /home/$USER/.ssh/authorized_keys

RUN chmod -R 644 /etc/ssh/ssh_host_* && chown -R $USER:$USER /home/$USER/.ssh && chmod 600 /home/$USER/.ssh/authorized_keys 

HEALTHCHECK --interval=1m --timeout=5s CMD bash -c '</dev/tcp/127.0.0.1/22' || exit 1

EXPOSE 22

# User option
USER $USER

CMD ["/usr/sbin/sshd", "-D"]