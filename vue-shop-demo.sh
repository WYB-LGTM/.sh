#!/bin/bash
#
#********************************************************************
#Name:		    wangyoubin
#QQ: 		     2634485144
#********************************************************************


APP=vue-shop-demo
APP_PATH=/var/www/html

HOST_LIST="
10.0.0.21
10.0.0.22
"

#打印GIT的ID,形式比如:27a5117d10e00b826c7603a91082a82a4552995f,可以取出前7位做为容器镜像的TAG,比如:<环境>-<分支>-<7位commit>
echo $GIT_COMMIT

npm install   --registry=https://registry.npmmirror.com

npm run build

for host in $HOST_LIST;do
    scp -r dist/*  root@$host:${APP_PATH}/
done
