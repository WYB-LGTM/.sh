#!/bin/bash
#
#********************************************************************
#Name:		    wangyoubin
#QQ: 		     2634485144
#********************************************************************


APP=spring-boot-helloworld

HOST_LIST="
10.0.0.21
10.0.0.22
"

PORT=8888

#打印GIT的ID,形式比如:27a5117d10e00b826c7603a91082a82a4552995f,可以取出前7位做为容器镜像的TAG,比如:<环境>-<分支>-<7位commit>
#echo $GIT_COMMIT
TAG=$BUILD_ID-$(echo $GIT_COMMIT | head -c 7)
#mvn clean package -Dmaven.test.skip=true
docker build -t harbor.magedu.com/example/$APP:$TAG -f Dockerfile-multistages .
docker login -u admin -p 123456 harbor.magedu.com
docker push  harbor.magedu.com/example/$APP:$TAG

for host in $HOST_LIST;do
    ssh root@$host "docker rm -f $APP"
    ssh root@$host "docker run -d --name $APP -p 80:8080 harbor.magedu.com/example/$APP:$TAG"
done
