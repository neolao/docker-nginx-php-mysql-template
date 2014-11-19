#!/bin/bash

sed "s/%phpfpm-ip%/$PHPFPM_PORT_9000_TCP_ADDR/" /nginx/vhost.conf > /etc/nginx/conf.d/vhost.conf

ln -sf /logs/nginx-access.log /var/log/nginx/access.log
ln -sf /logs/nginx-error.log /var/log/nginx/error.log

nginx -g "daemon off;"

#nginx
#tail -f /var/log/nginx/error.log
