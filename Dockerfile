FROM legendary/ubuntu-core
MAINTAINER Prime-Host <info@nordloh-webdesign.de>

RUN apt-get update
RUN apt-get -y upgrade

# clean up unneeded packages
RUN apt-get --purge autoremove -y

# Supervisor Config
RUN /usr/bin/easy_install supervisor
RUN /usr/bin/easy_install supervisor-stdout
ADD ./supervisord.conf /etc/supervisord.conf

# Initialization and Startup Script
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

CMD ["/bin/bash", "/start.sh"]
