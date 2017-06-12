#!/bin/bash

# Create custom ssh_user with sudo privileges
useradd -m -d /home/$PRIMEHOST_USER -G root -s /bin/bash $PRIMEHOST_USER \
	&& usermod -a -G $PRIMEHOST_USER $PRIMEHOST_USER \
	&& usermod -a -G sudo $PRIMEHOST_USER

# Set passwords for the ssh_user and root
echo "$PRIMEHOST_USER:$PRIMEHOST_PASSWORD" | chpasswd
echo "root:$PRIMEHOST_PASSWORD" | chpasswd

sed -i -e "s/user\s*=\s*$PRIMEHOST_USER/user = $PRIMEHOST_USER/g" /etc/php/7.0/fpm/pool.d/www.conf

# Create www folder and index.php
mkdir /usr/share/nginx/www
mv /index.php /usr/share/nginx/www/index.php

# start all the services
/usr/local/bin/supervisord -n -c /etc/supervisord.conf
