#!/bin/bash

# Create custom ssh_user with sudo privileges
useradd -m -d /home/$PRIMEHOST_USER -G root -s /bin/bash $PRIMEHOST_USER \
	&& usermod -a -G $PRIMEHOST_USER $PRIMEHOST_USER \
	&& usermod -a -G sudo $PRIMEHOST_USER

# Set passwords for the ssh_user and root
echo "$PRIMEHOST_USER:$PRIMEHOST_PASSWORD" | chpasswd
echo "root:$PRIMEHOST_PASSWORD" | chpasswd

# Custom user for nginx and php
sed -i s/www-data/$PRIMEHOST_USER/g /etc/nginx/nginx.conf
sed -i s/www-data/$PRIMEHOST_USER/g /etc/php/7.0/fpm/pool.d/www.conf

# Create www folder and index.php
mkdir /usr/share/nginx/www
mv /index.php /usr/share/nginx/www/index.php
chown -R $PRIMEHOST_USER:$PRIMEHOST_USER /usr/share/nginx/www

# start all the services
/usr/local/bin/supervisord -n -c /etc/supervisord.conf
