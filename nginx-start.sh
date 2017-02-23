#!/bin/bash

# start all the services
/usr/local/bin/supervisord -n -c /etc/supervisord.conf
