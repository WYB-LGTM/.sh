#!/bin/bash
#
#********************************************************************
#Name:		    wangyoubin
#QQ: 		     2634485144
#********************************************************************


APP=spring-boot-helloworld
APP_PATH=/srv

#HOST_LIST="
#10.0.0.21
#10.0.0.22
#"

PORT=8888

#打印GIT的ID,形式比如:27a5117d10e00b826c7603a91082a82a4552995f,可以取出前7位做为容器镜像的TAG,比如:<环境>-<分支>-<7位commit>
echo $GIT_COMMIT
mvn clean package -Dmaven.test.skip=true

for host in $HOST_LIST;do
    #ssh root@$host "[ -e $APP_PATH ] || mkdir -p $APP_PATH"
    ssh root@$host killall -9 java &> /dev/null
    scp target/${APP}-*.jar  root@$host:${APP_PATH}/${APP}.jar
    #ssh root@$host "java -jar ${APP_PATH}/${APP}.jar --server.port=8888 &"
    ssh root@$host "nohup java -jar  ${APP_PATH}/${APP}.jar --server.port=$PORT  &>/dev/null & "&
done
