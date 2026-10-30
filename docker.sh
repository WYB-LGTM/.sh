#!/bin/sh
#
#********************************************************************
#Name:		    wangyoubin
#QQ: 		     2634485144
#********************************************************************
mkdir /apps/nginx/conf/conf.d/ -p
cat > /apps/nginx/conf/conf.d/www.magedu.com.conf <<EOF
server {
    listen 80;
    server_name www.magedu.com;
    root /data/website;
}
EOF
mkdir /data/website -p
echo www.magedu.com website >> /data/website/index.html

#/apps/nginx/sbin/nginx -g 'daemon off;'

exec "$@"
