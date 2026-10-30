#!/bin/bash

# 定义Zabbix版本
ZABBIX_MAJOR_VER=7.0
ZABBIX_VER=${ZABBIX_MAJOR_VER}-1

# 定义镜像源URL
URL="mirror.tuna.tsinghua.edu.cn/zabbix"

# 定义MySQL相关配置
MYSQL_HOST=localhost
MYSQL_ZABBIX_USER="zabbix@localhost"
MYSQL_ZABBIX_PASS='password'
MYSQL_ROOT_PASS='password'

# 定义字体文件
FONT=simkai.ttf

# 获取本机IP地址
ZABBIX_IP=$(hostname -I | awk '{print $1}')

# 定义颜色输出函数
GREEN="echo -e \E[32;1m"
END="\E[0m"

# 加载系统发行版信息
. /etc/os-release 

# 颜色输出函数
color () {
    RES_COL=60
    MOVE_TO_COL="echo -en \\033[${RES_COL}G"
    SETCOLOR_SUCCESS="echo -en \\033[1;32m"
    SETCOLOR_FAILURE="echo -en \\033[1;31m"
    SETCOLOR_WARNING="echo -en \\033[1;33m"
    SETCOLOR_NORMAL="echo -en \E[0m"
    echo -n "$1" && $MOVE_TO_COL
    echo -n "["
    if [ "$2" = "success" -o "$2" = "0" ]; then
        ${SETCOLOR_SUCCESS}
        echo -n $"  OK  "    
    elif [ "$2" = "failure" -o "$2" = "1" ]; then 
        ${SETCOLOR_FAILURE}
        echo -n $"FAILED"
    else
        ${SETCOLOR_WARNING}
        echo -n $"WARNING"
    fi
    ${SETCOLOR_NORMAL}
    echo -n "]"
    echo 
}

# 检查命令是否成功执行
check_command_status() {
    if [ $? -ne 0 ]; then
        color "$1" 1
        exit 1
    fi
    color "$1" 0
}

# 检查权限
check_permissions() {
    if [ "$EUID" -ne 0 ]; then
        echo "请使用root权限运行此脚本。"
        exit 1
    fi
}


# 安装MySQL数据库
install_mysql () {
    [ "$MYSQL_HOST" != "localhost" ] && return 
    if [ "$ID" = "centos" -o "$ID" = "rocky" ]; then
        VERSION_ID=$(echo "$VERSION_ID" | cut -d . -f1)
        if [ "$VERSION_ID" = "8" ]; then
            yum -y install mysql-server
            check_command_status "安装mysql-server"
            systemctl enable --now mysqld
            check_command_status "启动并设置开机自启mysqld"
        elif [ "$VERSION_ID" = "7" ]; then
            yum -y install mariadb-server
            check_command_status "安装mariadb-server"
            systemctl enable --now mariadb
            check_command_status "启动并设置开机自启mariadb"
        else
            color "不支持的操作系统,退出" 1
            exit 1
        fi 
    else
        apt update
        check_command_status "更新APT源"
        rm -rf /var/lib/dpkg/lock*
        apt -y install mysql-server
        check_command_status "安装mysql-server"
        sed -i "/^bind-address.*/c bind-address  = 0.0.0.0" /etc/mysql/mysql.conf.d/mysqld.cnf
        check_command_status "修改MySQL绑定地址"
        systemctl restart mysql
        check_command_status "重启MySQL服务"
    fi
    mysqladmin -uroot password "$MYSQL_ROOT_PASS"
    check_command_status "设置MySQL root密码"
    mysql -uroot -p"$MYSQL_ROOT_PASS" <<EOF
set global log_bin_trust_function_creators = 0;
create database zabbix character set utf8mb4 collate utf8mb4_bin;
create user $MYSQL_ZABBIX_USER identified by "$MYSQL_ZABBIX_PASS";
GRANT SUPER ON *.* TO $MYSQL_ZABBIX_USER;
grant all privileges on zabbix.* to $MYSQL_ZABBIX_USER;
set global log_bin_trust_function_creators = 1;
quit
EOF
    check_command_status "配置MySQL数据库和用户"
}

# 安装Zabbix
install_zabbix () {
    if [ "$ID" = "centos" -o "$ID" = "rocky" ]; then 
        rpm -Uvh https://${URL}/zabbix/${ZABBIX_MAJOR_VER}/rhel/${VERSION_ID}/x86_64/zabbix-release-${ZABBIX_VER}.el${VERSION_ID}.noarch.rpm
        check_command_status "安装Zabbix YUM仓库"
        sed -i "s#repo.zabbix.com#${URL}#" /etc/yum.repos.d/zabbix.repo
        check_command_status "修改Zabbix YUM仓库源"
        VERSION_ID=$(echo "$VERSION_ID" | cut -d . -f1)
        if [ "$VERSION_ID" = "8" ]; then 
            yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent zabbix-get langpacks-zh_CN
            check_command_status "安装Zabbix相关软件包（CentOS 8）"
        else 
            yum -y install zabbix-server-mysql zabbix-agent  zabbix-get
            check_command_status "安装Zabbix基础软件包（CentOS 7）"
            yum -y install centos-release-scl
            check_command_status "安装CentOS SCL仓库"
            rpm -q yum-utils || yum -y install yum-utils
            check_command_status "安装yum-utils"
            yum-config-manager --enable zabbix-frontend
            check_command_status "启用Zabbix前端仓库"
            yum -y install zabbix-web-mysql-scl zabbix-apache-conf-scl
            check_command_status "安装Zabbix前端软件包（CentOS 7）"
        fi
    else 
        wget https://${URL}/zabbix/${ZABBIX_MAJOR_VER}/ubuntu/pool/main/z/zabbix-release/zabbix-release_${ZABBIX_VER}+ubuntu${VERSION_ID}_all.deb
        check_command_status "下载Zabbix APT仓库包"
        dpkg -i zabbix-release_${ZABBIX_VER}+ubuntu${VERSION_ID}_all.deb
        check_command_status "安装Zabbix APT仓库包"
        sed -i.bak "s#repo.zabbix.com#${URL}#" /etc/apt/sources.list.d/zabbix.list
        check_command_status "修改Zabbix APT仓库源"
        apt update
        check_command_status "更新Zabbix APT源"
        apt -y install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent zabbix-get language-pack-zh-hans 
        check_command_status "安装Zabbix相关软件包（Ubuntu）"
    fi
}

# 配置MySQL和Zabbix
config_mysql_zabbix () {
    if [ -f "$FONT" ]; then 
        mv /usr/share/zabbix/assets/fonts/graphfont.ttf{,.bak}
        check_command_status "备份原字体文件"
        cp  "$FONT" /usr/share/zabbix/assets/fonts/graphfont.ttf
        check_command_status "复制新字体文件"
    else
        color "缺少字体文件!" 1
        exit 1
    fi
    if [ "$MYSQL_HOST" = "localhost" ]; then
        zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p"$MYSQL_ZABBIX_PASS" -h"$MYSQL_HOST" zabbix
        check_command_status "导入Zabbix数据库脚本"
        mysql -uroot -p"$MYSQL_ROOT_PASS" -e "set global log_bin_trust_function_creators = 0"
        check_command_status "设置MySQL全局变量"
    fi
    sed -i -e "/.*DBPassword=.*/c DBPassword=$MYSQL_ZABBIX_PASS" -e "/.*DBHost=.*/c DBHost=$MYSQL_HOST" /etc/zabbix/zabbix_server.conf
    check_command_status "修改Zabbix服务器配置文件"
    if [ "$ID" = "centos" -o "$ID" = "rocky" ]; then
        VERSION_ID=$(echo "$VERSION_ID" | cut -d . -f1)
        if [ "$VERSION_ID" = "8" ]; then 
            sed -i -e "/.*date.timezone.*/c php_value[date.timezone] = Asia/Shanghai" -e "/.*upload_max_filesize.*/c php_value[upload_max_filesize] = 20M" /etc/php-fpm.d/zabbix.conf
            check_command_status "修改PHP配置文件（CentOS 8）"
            systemctl enable --now zabbix-server zabbix-agent httpd php-fpm
            check_command_status "启动并设置开机自启Zabbix和相关服务（CentOS 8）"
        else
            sed -i "/.*date.timezone.*/c php_value[date.timezone] = Asia/Shanghai" /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf
            check_command_status "修改PHP配置文件（CentOS 7）"
            systemctl restart zabbix-server zabbix-agent httpd rh-php72-php-fpm
            check_command_status "重启Zabbix和相关服务（CentOS 7）"
            systemctl enable zabbix-server zabbix-agent httpd rh-php72-php-fpm
            check_command_status "设置开机自启Zabbix和相关服务（CentOS 7）"
        fi
    else
        sed -i "/date.timezone/c php_value date.timezone Asia/Shanghai" /etc/apache2/conf-available/zabbix.conf
        check_command_status "修改Apache配置文件（Ubuntu）"
        chown -R www-data.www-data /usr/share/zabbix/
        check_command_status "修改Zabbix目录权限（Ubuntu）"
        systemctl enable  zabbix-server zabbix-agent apache2
        check_command_status "设置开机自启Zabbix和相关服务（Ubuntu）"
        systemctl restart  zabbix-server zabbix-agent apache2
        check_command_status "重启Zabbix和相关服务（Ubuntu）"
    fi
    echo 
    color "ZABBIX-${ZABBIX_VER}安装完成!" 0
    echo "-------------------------------------------------------------------"
    ${GREEN}"请访问: http://$ZABBIX_IP/zabbix"${END}
}

# 主程序
main(){
  check_permissions
  install_mysql
  install_zabbix
  config_mysql_zabbix
}

# 执行主程序
main