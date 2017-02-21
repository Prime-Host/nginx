FROM legendary/ubuntu-core
MAINTAINER Prime-Host <info@nordloh-webdesign.de>

RUN apt-get update
RUN apt-get -y upgrade

CMD ["/bin/bash", "/start.sh"]
