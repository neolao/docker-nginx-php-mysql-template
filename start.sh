#!/bin/bash

currentDirectory="$( readlink -f "$( dirname "$0" )" )"

# Remove containers on exit
destruct () {
    echo -ne "\n\nStopping ..."
    docker rm -f d_mysql > /dev/null
    docker rm -f d_phpfpm > /dev/null
    docker rm -f d_nginx > /dev/null
    echo -n " OK"
    echo ""
    exit 255
}
trap destruct exit

# Start MySQL
echo -n "Start MySQL:   "
docker run \
    --name d_mysql \
    --env MYSQL_ROOT_PASSWORD="1234" \
    --detach=true \
    mysql:5.7

# Start PHP FPM
echo -n "Start PHP-FPM: "
docker run \
    --name d_phpfpm \
    --detach=true \
    --volume=$currentDirectory/php:/php:ro \
    --volume=$currentDirectory/www:/www \
    --volume=$currentDirectory/logs:/logs \
    --workdir=/www \
    php:5.6.3-fpm \
    sh /php/start.sh

# Start Nginx
echo -n "Start Nginx:   "
docker run \
    --name d_nginx \
    --publish=8090:80 \
    --detach=true \
    --volume=$currentDirectory/nginx:/nginx:ro \
    --volume=$currentDirectory/www:/www \
    --volume=$currentDirectory/logs:/logs \
    --link d_phpfpm:phpfpm \
    nginx:1.7.7 \
    sh /nginx/start.sh


# Ready message
echo ""
echo "Ready!"

# Never stop
while :
do
    sleep 60
done
