#!/bin/bash
set -Eeuo pipefail

show_menus(){
    echo "=============================="
    echo "Zabbix安装脚本"
    echo "=============================="
    echo "请选择要执行的操作："
    echo "1. 安装Zabbix Server"
    echo "2. 安装Zabbix Agent"
    echo "3. 修改Zabbix图形字体"
    echo "0. 退出"
    echo "=============================="
}

# 检查操作系统类型
check_os() {
    source /etc/os-release
    export ID VERSION_ID
}

check_ip() {
    export ip_address
    ip_address=$(hostname -I | awk '{print $1}')
    if [ -z "$ip_address" ]; then
        echo "无法获取本机IP地址，请检查网络配置。"
        exit 1
    fi
    echo "本机IP地址: $ip_address"
}

check_chinese_locale() {
    if ! locale -a | grep zh; then
        echo "当前系统没有中文语言包，尝试安装中文语言包..."
        if [ "$ID" = "ubuntu" ];then
            apt update
            apt install -y language-pack-zh-hans
            locale-gen zh_CN.UTF-8
        else
            dnf install -y glibc-langpack-zh
            localectl set-locale LANG=zh_CN.UTF-8
        fi
        echo "中文语言包安装完成"
    fi
}

# zabbix Server安装
zabbix_server_install() {

    if [ "$ID" = "ubuntu" ]; then
        apt update
        apt install -y mysql-server
        apt install -y nginx php8.3-fpm php8.3-mysql php8.3-gd php8.3-bcmath php8.3-mbstring php8.3-xml php8.3-ldap

        wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu24.04_all.deb
        dpkg -i zabbix-release_latest_7.0+ubuntu24.04_all.deb
        apt update

        apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-nginx-conf zabbix-sql-scripts zabbix-agent
    else
        dnf install -y mysql-server
        rpm -Uvh https://repo.zabbix.com/zabbix/7.0/rocky/9/x86_64/zabbix-release-7.0-1.el9.noarch.rpm
        dnf clean all
        dnf makecache

        dnf install -y nginx php-fpm php-mysqlnd php-gd php-bcmath php-mbstring php-xml php-ldap
        dnf install -y zabbix-server-mysql zabbix-web-mysql zabbix-nginx-conf zabbix-sql-scripts zabbix-agent
    fi
    echo "Zabbix Server安装完成"
}

# zabbix Agent安装
zabbix_agent_install() {
    if [ "$ID" = "ubuntu" ]; then
        wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu24.04_all.deb
        dpkg -i zabbix-release_latest_7.0+ubuntu24.04_all.deb
        apt update
        apt install -y zabbix-agent
    else
        rpm -Uvh https://repo.zabbix.com/zabbix/7.0/rocky/9/x86_64/zabbix-release-7.0-1.el9.noarch.rpm
        dnf clean all
        dnf makecache
        dnf install -y zabbix-agent
    fi
    echo "Zabbix Agent安装完成"
}

# 配置zabbix Agent
zabbix_agent_present() {
    local server_ip=$1
    local agent_ip=$2
    if [ "$ID" = "ubuntu" ]; then
        sed -i "s/^Server=127.0.0.1$/Server=$server_ip/" /etc/zabbix/zabbix_agentd.conf
        sed -i 's/^ServerActive=127.0.0.1$/# ServerActive=127.0.0.1/' /etc/zabbix/zabbix_agentd.conf
        sed -i "s/^Hostname=Zabbix server$/Hostname=$agent_ip/" /etc/zabbix/zabbix_agentd.conf
    else
        sed -i "s/^Server=127.0.0.1$/Server=$server_ip/" /etc/zabbix_agentd.conf
        sed -i 's/^ServerActive=127.0.0.1$/# ServerActive=127.0.0.1/' /etc/zabbix_agentd.conf
        sed -i "s/^Hostname=Zabbix server$/Hostname=$agent_ip/" /etc/zabbix_agentd.conf
    fi

    systemctl restart zabbix-agent
    systemctl enable zabbix-agent
    echo "Zabbix Agent配置完成"
}

# 创建zabbix数据库
# log_bin_trust_function_creators = 1：允许创建存储过程和函数，仅导入数据时需要，完成后会关掉
mysql_present() {
    mysql -uroot << EOF
    create database zabbix character set utf8mb4 collate utf8mb4_bin;
    create user zabbix@localhost identified by 'password';
    grant all privileges on zabbix.* to zabbix@localhost; 
    set global log_bin_trust_function_creators = 1;
    \q
EOF
    echo "Zabbix数据库创建完成"

    # 导入初始架构和数据
    zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -ppassword zabbix
    echo "Zabbix数据库初始架构和数据导入完成"
    mysql -uroot -e "set global log_bin_trust_function_creators = 0;"

    if [ "$ID" = "ubuntu" ]; then
        # 配置Zabbix Server数据库连接 ububtu的Zabbix Server配置文件位于/etc/zabbix/zabbix_server.conf
        sed -i 's/# DBPassword=/DBPassword=password/' /etc/zabbix/zabbix_server.conf
    else
        # 配置Zabbix Server数据库连接 centos的Zabbix Server配置文件位于/etc/zabbix_server.conf
        sed -i 's/# DBPassword=/DBPassword=password/' /etc/zabbix_server.conf
    fi
    echo "Zabbix Server数据库连接配置完成"
}

# 配置nginx和php
web_present() {
    rm -f /etc/nginx/sites-enabled/default
    echo 'php_value[date.timezone] = Asia/Shanghai' >> /etc/zabbix/php-fpm.conf
    echo "Zabbix Web界面配置完成"

    if [ "$ID" = "ubuntu" ]; then
        systemctl restart zabbix-server zabbix-agent php8.3-fpm nginx
        systemctl enable zabbix-server zabbix-agent php8.3-fpm nginx
    else
        systemctl restart zabbix-server zabbix-agent php-fpm nginx
        systemctl enable zabbix-server zabbix-agent php-fpm nginx
    fi
    echo "Zabbix服务已启动并设置为开机自启"
}


# 解决Zabbix图形字体乱码问题
modify_zabbix_font() {
    local font_path=$1
    cd /usr/share/zabbix/assets/fonts/
    [ -f graphfont.ttf ] && mv graphfont.ttf graphfont.ttf-bak
    cp "$font_path" graphfont.ttf
    echo "Zabbix图形字体已修改为: $font_path"
}

main(){
    check_os
    check_ip

    while true;do
        clear
        show_menus
        read -p "请输入选项编号: " choice
        case $choice in
            1)
                check_chinese_locale
                zabbix_server_install
                mysql_present
                web_present
                echo "Zabbix Server安装和配置完成，请访问http://your_server_ip/zabbix进行访问"
                ;;
            2)
                read -p "请输入Zabbix Server IP地址: " server_ip
                zabbix_agent_install
                zabbix_agent_present "$server_ip" "$ip_address"
                echo "Zabbix Agent安装和配置完成"
                ;;
            3)
                read -p "请输入字体文件路径: " font_path
                modify_zabbix_font "$font_path"
                echo "Zabbix图形字体修改完成"
                ;;
            0)
                echo "退出脚本"
                exit 0
                ;;
            *)
                echo "无效的选项，请重新选择。"
                ;;
        esac
    done
}


main "$@"

