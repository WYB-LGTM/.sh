#!/bin/bash
#
#********************************************************************
#Name:		    wangyoubin
#QQ: 		     2634485144
#********************************************************************


APP=spring-boot-helloworld

#打印GIT的ID,形式比如:27a5117d10e00b826c7603a91082a82a4552995f,可以取出前7位做为容器镜像的TAG,比如:<环境>-<分支>-<7位commit>
#echo $GIT_COMMIT
TAG=$BUILD_ID-$(echo $GIT_COMMIT | head -c 7)
docker build -t harbor.magedu.com/example/$APP:$TAG -f Dockerfile-multistages .
docker login -u admin -p $PASS harbor.magedu.com
docker push  harbor.magedu.com/example/$APP:$TAG

sed -i "s#__TAG__#$TAG#" deploy/03-deployment.yaml
#cat deploy/*.yaml | ssh root@10.0.0.10 "kubectl apply -f -"

#export KUBECONFIG=deploy/config

kubectl apply -f deploy
