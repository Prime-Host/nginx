#!/bin/bash

# Create custom ssh_user with sudo privileges
useradd -m -d /home/$SSH_USER -G root -s /bin/bash $SSH_USER \
	&& usermod -a -G $SSH_USER $SSH_USER \
	&& usermod -a -G sudo $SSH_USER

# Set passwords for the ssh_user and root
echo "$SSH_USER:$SSH_PASSWORD" | chpasswd
echo "root:$SSH_PASSWORD" | chpasswd

/usr/local/bin/supervisord -n -c /etc/supervisord.conf
