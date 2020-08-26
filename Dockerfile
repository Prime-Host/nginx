FROM nginx:latest
MAINTAINER Nordloh Webdesign <info@nordloh-webdesign.de>

RUN mkdir /var/run/sshd \
 && mkdir -p /var/www/html \
 && sed -i s:/usr/share/nginx/html:/var/www/html:g /etc/nginx/conf.d/default.conf \
 && apt-get update \
 && apt-get install -y cron python-setuptools supervisor wget curl git nano vim sudo unzip openssh-server openssl rsync zsh \
 && wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true \
 && cp /root/.oh-my-zsh/themes/bira.zsh-theme /root/.oh-my-zsh/themes/prime-host.zsh-theme \
 && sed -i 's/%m/%M/g' /root/.oh-my-zsh/themes/prime-host.zsh-theme \
 && sed -i s:/root/.oh-my-zsh:\$HOME/.oh-my-zsh:g /root/.zshrc \
 && sed -i 's/robbyrussell/prime-host/g' /root/.zshrc \
 && echo "DISABLE_UPDATE_PROMPT=true" >> /root/.zshrc \
 && echo "cd /var/www/html" >> /root/.zshrc \
 && echo "set encoding=utf-8" >> /root/.vimrc \
 && echo "set fileencoding=utf-8" >> /root/.vimrc \
 && cp -r /root/.oh-my-zsh /etc/skel/. \
 && cp /root/.zshrc /etc/skel/. \
 && cp /root/.vimrc /etc/skel/. 

# Add config files
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD ./start.sh /bin/prime-host/start.sh
ADD ./nginx.conf /etc/nginx/nginx.conf

# network ports
EXPOSE 22

WORKDIR /var/www/html

CMD ["/bin/bash", "/bin/prime-host/start.sh"]
