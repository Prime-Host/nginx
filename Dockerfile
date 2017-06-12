FROM primehost/ubuntu-core
MAINTAINER Prime-Host <info@nordloh-webdesign.de>

# php directory
RUN mkdir /run/php

# update before install
RUN apt-get update
RUN apt-get -y upgrade

# install nginx and php
RUN apt-get -y install mysql-client nginx php-fpm php-mysql
RUN apt-get -y install php-xml php-mbstring php-bcmath php-zip php-pdo-mysql php-curl php-gd php-intl php-pear
RUN apt-get -y install php-imagick php-imap php-mcrypt php-memcache php-apcu php-pspell php-recode php-tidy php-xmlrpc

# php-fpm config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 10G/g" /etc/php/7.0/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 10G/g" /etc/php/7.0/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf
RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/7.0/fpm/pool.d/www.conf

# nginx site conf
ADD ./nginx-main.conf /etc/nginx/nginx.conf
ADD ./nginx-default.conf /etc/nginx/sites-available/default

# Supervisor Config
RUN /usr/bin/easy_install supervisor
RUN /usr/bin/easy_install supervisor-stdout
ADD ./supervisord.conf /etc/supervisord.conf

# clean up unneeded packages
RUN apt-get --purge autoremove -y

# info php
ADD ./index.php /index.php

# Startup Script
ADD ./nginx-start.sh /nginx-start.sh
RUN chmod 755 /nginx-start.sh

#NETWORK PORTS
EXPOSE 80

CMD ["/bin/bash", "/nginx-start.sh"]
