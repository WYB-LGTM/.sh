#
#********************************************************************
#Name:		    wangyoubin
#QQ: 		     2634485144
#********************************************************************


version() {
sed -rn 's#^.* ([0-9]+)\..*#\1#p' /etc/redhat-release
}

setalias(){
cat >>~/.bashrc <<EOF
alias cdnet="cd /etc/sysconfig/network-scripts"
alias vimeth1="vim /etc/sysconfig/network-scripts/ifcfg-eth0"
alias scandisk="echo '- - -' > /sys/class/scsi_host/host0/scan;echo '- - -' > /sys/class/scsi_host/host1/scan;echo '- - -' > /sys/class/scsi_host/host2/scan"
alias yy='yum -y install'
alias ys='yum search'
alias yc='yum clean all'
alias yu='yum -y update'
alias yd='yum -y remove'
alias fd='systemctl stop firewalld.service'
alias fdd='systemctl disable --now firewalld.service'
alias fw='firewall-cmd --state'
alias fo='systemctl start firewalld.service'
alias fr='systemctl restart firewalld.service'
alias net='service network restart'
alias sr='systemctl restart'
alias ss='systemctl start '
alias st='systemctl stop'
alias sd='systemctl daemon-reload'
alias sa='systemctl status'
alias sn='systemctl enable --now'
alias yp='yum provides'
alias ss='netstat'
alias dp='docker pull'
alias dr='docker rmi'
alias ds='docker search'
alias dr='docker restart'
alias de='docker exec -it'
alias da='docker ps -a'
EOF
echo -e "\033[36mcentos`version` 别名设置完成！ \033[0m"
}

mail(){
read -p "$(echo -e '\033[1;32m请输入QQ号:\033[0m')" USE
read -p "$(echo -e '\033[1;32m请输入smtp验证码:\033[0m')" smt
cat >~/.mailrc <<EOF
set from=$USE@qq.com
set smtp=smtp.qq.com
set smtp-auth-user=$USE@qq.com
set smtp-auth-password=$smt
set smtp-auth=login
set ssl-verify=ignore
EOF
echo -e "\033[36mcentos`version` 邮箱服务设置完成！ \033[0m"
}

selinux(){
sed -ri.bak 's/^(SELINUX=).*/\1disabled/' /etc/selinux/config
echo -e "\033[36mcentos`version` selinux关闭！ \033[0m"
}

firewall(){
version | while read ov ;do
        if [ $ov -eq 6 ];then
                chkconfig iptables off
                echo -e "\033[36mcentos`version` 防火墙已经关闭！ \033[0m"
        else
                systemctl disable --now firewalld &> /dev/null
                echo -e "\033[36mcentos`version` 防火墙已经关闭！ \033[0m"
        fi
done
}

set_yum_centos8(){
mkdir /etc/yum.repos.d/backup
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup
cat > /etc/yum.repos.d/base.repo <<EOF
[BaseOS]
name=BaseOS
baseurl=https://mirrors.aliyun.com/centos/\$releasever/BaseOS/\$basearch/os/
        https://mirrors.huaweicloud.com/centos/\$releasever/BaseOS/\$basearch/os/
        https://mirrors.cloud.tencent.com/centos/\$releasever/BaseOS/\$basearch/os/
        https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/BaseOS/\$basearch/os/
        http://mirrors.163.com//centos/\$releasever/BaseOS/\$basearch/os/
        http://mirrors.sohu.com/centos/\$releasever/BaseOS/\$basearch/os/ 
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

[AppStream]
name=AppStream
baseurl=https://mirrors.aliyun.com/centos/\$releasever/AppStream/\$basearch/os/
        https://mirrors.huaweicloud.com/centos/\$releasever/AppStream/\$basearch/os/
        https://mirrors.cloud.tencent.com/centos/\$releasever/AppStream/\$basearch/os/
        https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/AppStream/\$basearch/os/
        http://mirrors.163.com/centos/\$releasever/AppStream/\$basearch/os/
        http://mirrors.sohu.com/centos/\$releasever/AppStream/\$basearch/os/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

[EPEL]
name=EPEL
baseurl=https://mirrors.aliyun.com/epel/\$releasever/Everything/\$basearch/
        https://mirrors.huaweicloud.com/epel/\$releasever/Everything/\$basearch/
        https://mirrors.cloud.tencent.com/epel/\$releasever/Everything/\$basearch/
        https://mirrors.tuna.tsinghua.edu.cn/epel/\$releasever/Everything/\$basearch/
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/epel/RPM-GPG-KEY-EPEL-\$releasever

[extras]
name=extras
baseurl=https://mirrors.aliyun.com/centos/\$releasever/extras/\$basearch/os/
        https://mirrors.huaweicloud.com/centos/\$releasever/extras/\$basearch/os/
        https://mirrors.cloud.tencent.com/centos/\$releasever/extras/\$basearch/os/
        https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/extras/\$basearch/os/
        http://mirrors.163.com/centos/\$releasever/extras/\$basearch/os/
        http://mirrors.sohu.com/centos/\$releasever/extras/\$basearch/os/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
enabled=1

[centosplus]
name=centosplus
baseurl=https://mirrors.aliyun.com/centos/\$releasever/centosplus/\$basearch/os/
        https://mirrors.huaweicloud.com/centos/\$releasever/centosplus/\$basearch/os/
        https://mirrors.cloud.tencent.com/centos/\$releasever/centosplus/\$basearch/os/
        https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/centosplus/\$basearch/os/
        http://mirrors.163.com/centos/\$releasever/centosplus/\$basearch/os/
        http://mirrors.sohu.com/centos/\$releasever/centosplus/\$basearch/os/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
EOF
dnf clean all
dnf repolist
echo -e "\033[36mcentos`version` 设置完成！ \033[0m"
}

set_yum_centos7(){
mkdir /etc/yum.repos.d/backup
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup
cat > /etc/yum.repos.d/base.repo <<EOF
[base]
name=base
baseurl=https://mirrors.aliyun.com/centos/\$releasever/os/\$basearch/ 
        https://mirrors.huaweicloud.com/centos/\$releasever/os/\$basearch/ 
        https://mirrors.cloud.tencent.com/centos/\$releasever/os/\$basearch/
        https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/os/\$basearch/
        http://mirrors.163.com/centos/\$releasever/os/\$basearch/
        http://mirrors.sohu.com/centos/\$releasever/os/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever

[epel]
name=epel
baseurl=https://mirrors.aliyun.com/epel/\$releasever/\$basearch/
        https://mirrors.huaweicloud.com/epel/\$releasever/\$basearch/
        https://mirrors.cloud.tencent.com/epel/\$releasever/\$basearch/
        https://mirrors.tuna.tsinghua.edu.cn/epel/\$releasever/\$basearch/
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/epel/RPM-GPG-KEY-EPEL-\$releasever

[extras]
name=extras
baseurl=https://mirrors.aliyun.com/centos/\$releasever/extras/\$basearch/
        https://mirrors.huaweicloud.com/centos/\$releasever/extras/\$basearch/
        https://mirrors.cloud.tencent.com/centos/\$releasever/extras/\$basearch/
        https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/extras/\$basearch/
        http://mirrors.163.com/centos/\$releasever/extras/\$basearch/
        http://mirrors.sohu.com/centos/\$releasever/extras/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever

[updates]
name=updates
baseurl=https://mirrors.aliyun.com/centos/\$releasever/updates/\$basearch/
        https://mirrors.huaweicloud.com/centos/\$releasever/updates/\$basearch/
        https://mirrors.cloud.tencent.com/centos/\$releasever/updates/\$basearch/
        https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/updates/\$basearch/
        http://mirrors.163.com/centos/\$releasever/updates/\$basearch/
        http://mirrors.sohu.com/centos/\$releasever/updates/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever

[centosplus]
name=centosplus
baseurl=https://mirrors.aliyun.com/centos/\$releasever/centosplus/\$basearch/
        https://mirrors.huaweicloud.com/centos/\$releasever/centosplus/\$basearch/
        https://mirrors.cloud.tencent.com/centos/\$releasever/centosplus/\$basearch/
        https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/centosplus/\$basearch/
        http://mirrors.163.com/centos/\$releasever/centosplus/\$basearch/
        http://mirrors.sohu.com/centos/\$releasever/centosplus/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever
EOF
yum clean all
yum repolist
echo -e "\033[36mcentos`version` 设置完成！ \033[0m"
}


set_yum_centos6(){
mkdir /etc/yum.repos.d/backup
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup
cat > /etc/yum.repos.d/base.repo <<EOF
[base]
name=base
baseurl=https://mirrors.cloud.tencent.com/centos/\$releasever/os/\$basearch/
        http://mirrors.sohu.com/centos/\$releasever/os/\$basearch/
        https://mirrors.aliyun.com/centos-vault/\$releasever.10/os/\$basearch/ 
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever

[epel]
name=epel
baseurl=https://mirrors.cloud.tencent.com/epel/\$releasever/\$basearch/
gpgcheck=1
gpgkey=https://mirrors.cloud.tencent.com/epel/RPM-GPG-KEY-EPEL-\$releasever

[extras]
name=extras
baseurl=https://mirrors.cloud.tencent.com/centos/\$releasever/os/\$basearch/
        http://mirrors.sohu.com/centos/\$releasever/extras/\$basearch/
        https://mirrors.aliyun.com/centos-vault/\$releasever.10/extras/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever

[updates]
name=updates
baseurl=https://mirrors.cloud.tencent.com/centos/\$releasever/os/\$basearch/
        http://mirrors.sohu.com/centos/\$releasever/updates/\$basearch/
        https://mirrors.aliyun.com/centos-vault/\$releasever.10/updates/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever

[centosplus]
name=centosplus
baseurl=https://mirrors.cloud.tencent.com/centos/\$releasever/os/\$basearch/
        http://mirrors.sohu.com/centos/\$releasever/centosplus/\$basearch/
        https://mirrors.aliyun.com/centos-vault/\$releasever.10/centosplus/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-\$releasever
EOF
yum clean all
yum repolist                                                                                                
echo -e "\033[36mcentos`version` 设置完成！ \033[0m"
}


yum1(){
version | while read ov2 ;do
	if [ $ov2 -eq 8 ];then
		set_yum_centos8
	elif [ $ov2 -eq 7 ];then    
		set_yum_centos7
	else
		set_yum_centos6    
	fi
done
}

install(){
yum -y install gcc make autoconf gcc-c++ glibc glibc-devel pcre pcre-devel openssl openssl-devel systemd-devel zlib-devel vim lrzsz tree tmux lsof tcpdump wget net-tools iotop bc bzip2 zip unzip nfs-utils man-pages
echo -e "\033[36mcentos`version` 基础软件安装完成！ \033[0m"
} 

seteth(){
ETHNAME=`ip addr | sed -nr '/^2/s#^.* ([a-z]+[0-9]+).*#\1#p'`
#修改网卡名称配置文件
sed -ri.bak '/^GRUB_CMDLINE_LINUX=/s@"$@ net.ifnames=0"@' /etc/default/grub 
grub2-mkconfig -o /boot/grub2/grub.cfg >& /dev/null
                                     
#修改网卡文件名
mv /etc/sysconfig/network-scripts/ifcfg-${ETHNAME} /etc/sysconfig/network-scripts/ifcfg-eth0

echo -e "\033[36mcentos`version` 设置完成！ \033[0m"
}

check_ip(){
local IP=$1
VALID_CHECK=$(echo $IP|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')
if echo $IP|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$" >/dev/null; then
	if [ $VALID_CHECK == "yes" ]; then
		echo "IP $IP  available!"
		return 0
	else
		echo "IP $IP not available!"
		return 1
	fi
else
	echo "IP format error!"
	return 1
fi
}

setip(){
while true; do
	read -p "input ip:"  IP
	check_ip $IP
	[ $? -eq 0 ] && break
done
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
DEVICE=eth0
NAME=eth0
BOOTPROTO=none
ONBOOT=yes
IPADDR=$IP
PREFIX=24
GATEWAY=10.0.0.2
DNS1=223.5.5.5
DNS2=223.6.6.6
EOF
echo -e "\033[36mcentos`version` ip设置完成！ \033[0m"
}

net(){                                                       if [ $(version) -eq 6 ];then 
	setip
else
	seteth
	setip
fi
}


host_name78(){
read -p "请输入主机名:"  HOST
hostnamectl set-hostname $HOST
echo -e "\033[36mcentos`version` hostname设置完成！ \033[0m"
}

host_name6(){
read -p "请输入主机名:"  HOST
sed -i.bak -r '/^HOSTNAME/s#^(HOSTNAME=).*#\1'$HOST'#' /etc/sysconfig/network
echo -e "\033[36mcentos`version` hostname设置完成！ \033[0m"
}

host_name(){
if [ $(version) -eq 6 ];then 
	host_name6
else
	host_name78
fi
}

ps1(){
color1="echo -e \033[31m"
color2="echo -e \033[32m"
color3="echo -e \033[33m"
color4="echo -e \033[36m"
color5="echo -e \033[35m"
colorEnd="\033[0m"

    ${color1}31 红色${colorEnd}
	 ${color2}32 绿色${colorEnd}
	 ${color3}33 黄色${colorEnd}
	 ${color4}36 蓝色${colorEnd}
    ${color5}35 紫色${colorEnd}
    read -p "$(echo -e '\033[1;32m请输入需要的颜色，例如32绿色:\033[0m')" bashColor

echo "export PS1='\[\e[1;${bashColor}m\][\u@\h \W]\$\[\e[0m\]'">> ~/.bashrc

echo -e "\033[36mcentos`version` ps1设置完成！ \033[0m"
#echo "centos`version` ps1 complete!"
}

set_vim(){
cat >~/.vimrc <<EOF  
set ts=4
set expandtab
set ignorecase
set cursorline
set autoindent
set number
autocmd BufNewFile *.sh exec ":call SetTitle()"
func SetTitle()
	if expand("%:e") == 'sh'
	call setline(1,"#!/bin/bash") 
	call setline(2,"#") 
	call setline(3,"#********************************************************************") 
	call setline(4,"#Author:		    1amyoo") 
	call setline(5,"#QQ: 			    192614911") 
	call setline(6,"#Date: 			    ".strftime("%Y-%m-%d"))
	call setline(7,"#FileName：		    ".expand("%"))
	call setline(8,"#URL: 			    www.1amyoo.top")
	call setline(9,"#Description：		The test script") 
	call setline(10,"#Copyright (C): 	".strftime("%Y")." All rights reserved")
	call setline(11,"#********************************************************************") 
	call setline(12,"") 
	endif
endfunc
autocmd BufNewFile * normal G
EOF
echo -e "\033[36m centos`version`vimrc设置完成！ \033[0m"
#echo "centos`version`vimrc complete!"
}

set_ssh(){
getenforce|grep -i enforce && setenforce 0
		read -p "$(echo -e '\033[1;32m请谨慎使用该功能！！，请输入端口:\033[0m')" sshPort
        sed -i "/\bPort\b/cPort ${sshPort:-1926}" /etc/ssh/sshd_config  
		systemctl restart sshd.service
		systemctl status sshd.service
}

set_key(){

read -p "$(echo -e '\033[1;32m请输入主机:\033[0m')" IPLIST
read -p "$(echo -e '\033[1;32m请输入密码:\033[0m')" sshpass
rpm -q sshpass &> /dev/null || yum -y install sshpass  
[ -f /root/.ssh/id_rsa ] || ssh-keygen -f /root/.ssh/id_rsa  -P ''
export SSHPASS=$sshpass
for IP in $IPLIST;do
    sshpass -e ssh-copy-id -o StrictHostKeyChecking=no $IP &> /dev/null 
    done 
    echo -e "\033[36m成功！\033[0m"
}



set_ubuntu(){
   ubuntu_version(){
sed -rn '2s/^.*="([0-9]+)\..*/\1/p' /etc/os-release
}

set_alias(){
cat >>~/.bashrc <<EOF
alias cdnet="cd /etc/sysconfig/network-scripts"
alias scandisk="echo '- - -' > /sys/class/scsi_host/host0/scan;echo '- - -' > /sys/class/scsi_host/host1/scan;echo '- - -' > /sys/class/scsi_host/host2/scan"
alias ay="apt install -y"
alias au="apt update"
alias as="apt search"
alias sp="systemctl stop"
alias sr="systemctl restart"
alias sd="systemctl daemon-reload"
alias st="systemctl start"
alias sn="systemctl enable"
EOF
echo -e "\e[1;31mUbuntu`ubuntu_version`系统别名已设置成功,请重新登陆后生效!\e[0m"
}

set_vimrc(){
cat >~/.vimrc <<EOF  
set ts=4
set expandtab
set ignorecase
set cursorline
set autoindent
autocmd BufNewFile *.sh exec ":call SetTitle()"
func SetTitle()
	if expand("%:e") == 'sh'
	call setline(1,"#!/bin/bash") 
	call setline(2,"#") 
	call setline(3,"#********************************************************************") 
	call setline(4,"#Author:		    1amyoo") 
	call setline(5,"#QQ: 			    192614911") 
	call setline(6,"#Date: 			    ".strftime("%Y-%m-%d"))
	call setline(7,"#FileName：		    ".expand("%"))
	call setline(8,"#URL: 			    www.1amyoo.top")
	call setline(9,"#Description：		The test script") 
	call setline(10,"#Copyright (C): 	".strftime("%Y")." All rights reserved")
	call setline(11,"#********************************************************************") 
	call setline(12,"") 
	endif
endfunc
autocmd BufNewFile * normal G
EOF
echo -e "\e[1;31mUbuntu`ubuntu_version`vimrc设置完成，请重新启动才能生效!\e[0m"
}

set_apt_18(){
mv /etc/apt/sources.list /etc/apt/sources.list.bak
cat > /etc/apt/sources.list <<EOF
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
EOF
apt update
echo -e "\e[1;31mUbuntu`ubuntu_version`阿里源设置完成!\e[0m"
}

set_apt_20(){
mv /etc/apt/sources.list /etc/apt/sources.list.bak
cat > /etc/apt/sources.list <<EOF
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
EOF
apt update
echo -e "\e[1;31mUbuntu`ubuntu_version`阿里源设置完成!\e[0m"
}

set_apt(){
ubuntu_version | while read ov ;do
        if [ $ov -eq 18 ];then
                set_apt_18
        else
                set_apt_20
        fi
done
}

ubuntu_remove(){
apt purge ufw lxd lxd-client lxcfs liblxc-common
echo -e "\e[1;31mUbuntu`ubuntu_version`无用软件包卸载完成!\e[0m"
}

ubuntu_minimal_install(){
apt -y install iproute2 ntpdate tcpdump telnet traceroute nfs-kernel-server nfs-common lrzsz tree openssl libssl-dev libpcre3 libpcre3-dev zlib1g-dev gcc openssh-server iotop unzip zip
echo -e "\e[1;31mUbuntu`ubuntu_version`最小化安装建议安装软件已安装完成!\e[0m"
}

set_eth(){
#修改网卡名称配置文件
sed -ri.bak '/^GRUB_CMDLINE_LINUX=/s@"$@ net.ifnames=0"@' /etc/default/grub 
grub-mkconfig -o /boot/grub/grub.cfg >& /dev/null
}

check_ip(){
local IP=$1
VALID_CHECK=$(echo $IP|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')
if echo $IP|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$" >/dev/null; then
	if [ $VALID_CHECK == "yes" ]; then
		echo "IP $IP  available!"
		return 0
	else
		echo "IP $IP not available!"
		return 1
	fi
else
	echo "IP format error!"
	return 1
fi
}

set_ip(){
while true; do
	read -p "请输入IP地址:"  IP
	check_ip $IP
	[ $? -eq 0 ] && break
done
cat > /etc/netplan/01-netcfg.yaml <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      addresses: [$IP/24] 
      gateway4: 10.0.0.2
      nameservers:
        search: [neteagles.cn， neteagles.com]
        addresses: [114.114.114.114, 180.76.76.76] 
EOF
echo -e "\e[1;31mUbuntu`ubuntu_version`网卡名和IP地址已修改成功，请重新启动系统后才能生效!\e[0m"
}

set_hostname(){
read -p "请输入主机名:"  HOST
hostnamectl set-hostname $HOST
echo -e "\e[1;31mUbuntu`ubuntu_version`主机名设置成功，请重新登录生效!\e[0m"
}

unsetps1(){
currentps1set=`grep "^PS1.*" ~/.bashrc |cut -d "=" -f 1`
if [ "$currentps1set" = "PS1" ] ;then
	sed -i "/^PS1.*/d" ~/.bashrc
	echo -e "\e[1;31m已清空PS1设置，请重新设置\e[0m"
else
	echo -e "\e[1;31m没有设置PS1，请直接设置\e[0m"
fi
}

set_ubuntups1(){
TIPS="echo -e \e[1;31mUbuntu`ubuntu_version`PS1已设置完成,请重新登录生效!\e[0m"
while true;do
echo -e "\E[$[RANDOM%7+31];1m"
cat <<EOF
1)31 红色
2)32 绿色
3)33 黄色
4)34 蓝色
5)35 紫色
6)36 青色
7)随机颜色
8)清空PS1设置
9)退出
EOF
echo -e '\E[0m'

read -p "请输入颜色编号(1-9)" NUM
case $NUM in
1)
	echo 'PS1="\[\e[1;31m\]${debian_chroot:+($debian_chroot)}\u@\h:\w\\$ \[\e[0m\]"' >> ~/.bashrc
	$TIPS
	;;
2)
	echo 'PS1="\[\e[1;32m\]${debian_chroot:+($debian_chroot)}\u@\h:\w\\$ \[\e[0m\]"' >> ~/.bashrc
	$TIPS
	;;
3)
	echo 'PS1="\[\e[1;33m\]${debian_chroot:+($debian_chroot)}\u@\h:\w\\$ \[\e[0m\]"' >> ~/.bashrc	
	$TIPS  
	;;
4)
	echo 'PS1="\[\e[1;34m\]${debian_chroot:+($debian_chroot)}\u@\h:\w\\$ \[\e[0m\]"' >> ~/.bashrc
	$TIPS
	;;
5)
	echo 'PS1="\[\e[1;35m\]${debian_chroot:+($debian_chroot)}\u@\h:\w\\$ \[\e[0m\]"' >> ~/.bashrc
	$TIPS
	;;
6)
	echo 'PS1="\[\e[1;36m\]${debian_chroot:+($debian_chroot)}\u@\h:\w\\$ \[\e[0m\]"' >> ~/.bashrc
	$TIPS
	;;
7)
	echo 'PS1="\[\e[1;'$[RANDOM%7+31]'m\]${debian_chroot:+($debian_chroot)}\u@\h:\w\\$ \[\e[0m\]"' >> ~/.bashrc
	$TIPS
	;;
8)
	unsetps1 
	;;
9)
	break
	;;
*)
	echo -e "\e[1;31m输入错误,请输入正确的数字(1-9)!\e[0m"
	;;
esac	
done
}

PS3="请选择相应的编号(1-11):"
MENU=" 
Ubuntu设置系统别名
Ubuntu设置vimrc配置文件
Ubuntu设置阿里APT源
Ubuntu卸载无用软件包
Ubuntu_Minimal安装建议安装软件
Ubuntu1-5全执行
Ubuntu修改网卡名和IP地址
Ubuntu设置主机名
Ubuntu设置PS1(请进入选择颜色)
重启系统
退出
"

select menu in $MENU;do
case $REPLY in
1)
	set_alias
	;;
2)
	set_vimrc
	;;
3)
	set_apt
	;;
4)
	ubuntu_remove
	;;
5)
	ubuntu_minimal_install
	;;

6)
	set_alias
	set_vimrc
	set_apt
	ubuntu_remove
	ubuntu_minimal_install
	;;
7)
	set_eth
	set_ip
	;;
8)
	set_hostname
	;;
9)
	set_ubuntups1
	;;
10)
	reboot
	;;
11)
	break
	;;
*)
	echo -e "\e[1;31m输入错误,请输入正确的数字(1-11)!\e[0m"
	;;
esac
done
}


































































































reboot_all(){
COLOR='echo -e \E[01;31m'
End='\033[0m'
while :;do
echo -e "\033[1;36m  1.设置别名      \033[0m"
echo -e "\033[1;36m  2.设置邮箱      \033[0m"
echo -e "\033[1;36m  3.关闭防火墙    \033[0m"
echo -e "\033[1;36m  4.关闭selinux   \033[0m"
echo -e "\033[1;36m  5.设置yum源     \033[0m"
echo -e "\033[1;36m  6.安装常用软件  \033[0m"
echo -e "\033[1;36m  7.修改ip地址    \033[0m"
echo -e "\033[1;36m  8.设置主机名    \033[0m"
echo -e "\033[1;36m  9.设置ps1       \033[0m"
echo -e "\033[1;36m  10.设置vim格式   \033[0m"
echo -e "\033[1;36m  11.设置shh端口号 \033[0m"
echo -e "\033[1;36m  12.设置key验证 \033[0m"
echo -e "\033[1;36m  13.安装1-6所有选项\033[0m"
echo -e "\033[1;36m  14.设置ubuntu系统 \033[0m"
echo -e "\033[1;36m  15.重启   \033[0m"
echo -e "\033[1;36m  16.退出         \033[0m"

read -p "$(echo -e '\033[1;32m请输入你的选项:\033[0m')" option
  case $option in
1)
    setalias
     ;;
2)
    mail
     ;;
3)
    firewall
     ;;
4)
    selinux
     ;;
5)   
    yum1
     ;;
6)
    install
    ;;
7)
    net
    ;;
8)
    host_name
    ;;
9)
    ps1
    ;;
10)
    set_vim
    ;;
11)
    set_ssh
    ;;
12)
    set_key
    ;;
13)
    setalias
    mail
    firewall
    selinux
    yum
    install
    ;;
14)
    set_ubuntu
    ;;
15)
    reboot
    ;;
16)
    break
    ;;
*)
   echo "Please try again if you have input error"
   ;;
esac
done

}












install_httpd(){
PACK='httpd-2.4.46.tar.gz'
PACK1='apr-1.7.0.tar.bz2'
PACK2='apr-util-1.6.1.tar.bz2'
COLOR='echo -e \E[01;31m'
END='\E[0m'
DIR='/usr/local/src/'

if [ -f $DIR$PACK ];then
    ins_httpd
else
    $COLOR"源码包不存在！开始下载！"$END
    yum -y install wget make gcc &> /dev/null
    wget -P $DIR https://mirrors.tuna.tsinghua.edu.cn/apache//httpd/$PACK
if [ $? -eq 0 ];then
$COLOR"下载成功！！"$END
else
$COLOR"下载失败，请检查网络配置！！"$END
exit
fi
     wget -P $DIR https://mirrors.bfsu.edu.cn/apache//apr/$PACK1
if [ $? -eq 0 ];then
$COLOR"下载成功！！"$END
else
$COLOR"下载失败，请检查网络配置！！"$END
exit
fi
    wget -P $DIR https://mirrors.bfsu.edu.cn/apache//apr/$PACK2
if [ $? -eq 0 ];then
$COLOR"下载成功！！"$END
   ins_httpd    
else
$COLOR"下载失败，请检查网络配置！！"$END
exit
fi
fi
}



ins_httpd(){
#num=$(rpm -qa|grep -c httpd)
#if [ $num -gt 0 ];then
#   echo "httpd已经安装！"
#else




#wget https://mirrors.tuna.tsinghua.edu.cn/apache//httpd/httpd-2.4.46.tar.gz

H='httpd-2.4.46'
H_FILES='httpd-2.4.46.tar.gz'
H_PREFIX='/apps/httpd'
a='apr-1.7.0.tar.bz2'
b='apr-util-1.6.1.tar.bz2'
c='apr-1.7.0'
d='apr-util-1.6.1'
COLOR='echo -e \E[01;31m'
END='\E[0m'
YUM_PACK='gcc gcc-c++ expat-devel perl net-tools'
DIR='/usr/local/src/'


#systemctl stop firewalld &> /dev/null

#setenforce 0 &> /dev/null

$COLOR "开始下载依赖"$END

yum -y install $YUM_PACK &> /dev/null
 
#wget https://mirrors.tuna.tsinghua.edu.cn/apache//httpd/httpd-2.4.46.tar.gz &> /dev/null

#wget https://mirrors.bfsu.edu.cn/apache//apr/apr-1.7.0.tar.bz2 &> /dev/null

#wget https://mirrors.bfsu.edu.cn/apache//apr/apr-util-1.6.1.tar.bz2 &> /dev/null

$COLOR "开始解压文件"$END

cd $DIR

mkdir /apps &> /dev/null

sleep 2

if [[ ! -f $DIR$a ]];then
         $COLOR "$a 不存在！请检查文件!"$END
elif [[ ! -f $DIR$b ]];then
         $COLOR "$b 不存在！ 请检查文件!"$END
elif [[ ! -f $DIR$H_FILES ]];then
         $COLOR "$H_FILES 不存在！ 请检查文件"$END
else

cd $DIR
      tar xf $a
      tar xf $b
      tar xf $H_FILES
fi

cd $DIR

mv $c $H/srclib/apr
mv $d $H/srclib/apr-util
cd $H

$COLOR "开始编译安装"$END

sleep 2

./configure --prefix=/apps/httpd  --enable-so --enable-ssl --enable-cgi --enable-rewrite --with-zlib --with-pcre --with-included-apr --enable-modules=most --enable-mpms-shared=all --with-mpm=event &> /dev/null

   
make -s &> /dev/null
make install -s &> /dev/null

$COLOR "开始准备配置文件"$END

sleep 2

echo 'PATH=/apps/httpd/bin:$PATH' > /etc/profile.d/lamp.sh
source /etc/profile.d/lamp.sh

useradd -s /sbin/nologin -r -u 88 apache &> /dev/null

sed -i 's/#ServerName www.example.com:80/ServerName www.example.com/g' /apps/httpd/conf/httpd.conf 

sed -ir "/^Group.*/c Group apache" /apps/httpd/conf/httpd.conf

sed -ir "/^User.*/c User apache" /apps/httpd/conf/httpd.conf

cat > /usr/lib/systemd/system/httpd.service << EOF
[Unit]
Description=The Apache HTTP Server
After=network.target remote-fs.target nss-lookup.target
Documentation=man:httpd(8)
Documentation=man:apachectl(8)
[Service]
Type=forking
#EnvironmentFile=/etc/sysconfig/httpd
ExecStart=/apps/httpd/bin/apachectl start
#ExecStart=/apps/httpd/bin/httpd $OPTIONS -k start
ExecReload=/apps/httpd/bin/apachectl graceful
#ExecReload=/apps/httpd/bin/httpd $OPTIONS -k graceful
ExecStop=/apps/httpd/bin/apachectl stop
KillSignal=SIGCONT
PrivateTmp=true
[Install]
WantedBy=multi-user.target
EOF

sleep 2

apachectl start

ss -ntlp|grep -wq 80
if [ $? -eq 0 ];then
   $COLOR "http 安装成功!"$END
   exit
else
   $COLOR "http安装失败!"$END
   exit
fi
sleep 2

#fi

}


install_mysql(){
PACK='mysql-5.7.33-linux-glibc2.12-x86_64.tar.gz'
COLOR='echo -e \E[01;31m'
END='\E[0m'
DIR='/usr/local/src/'

if [ -f $DIR$PACK ];then
    ins_mysql
else
    $COLOR"源码包不存在！开始下载！"$END
    yum -y install wget &> /dev/null
    wget -P $DIR https://mirrors.tuna.tsinghua.edu.cn/mysql/downloads/MySQL-5.7/$PACK
if [ $? -eq 0 ];then
$COLOR"下载成功！！"$END
    ins_mysql
else
$COLOR"下载失败，请检查网络配置！！"$END
exit
fi
fi
}

#mysql安装
ins_mysql() {
DIR='/usr/local/src/'


cd $DIR

. /etc/init.d/functions 
SRC_DIR=`pwd`
#MYSQL='mariadb-10.2.38-linux-systemd-x86_64.tar.gz'
#MYSQL='mysql-8.0.23-linux-glibc2.12-x86_64.tar.xz'
MYSQL='mysql-5.7.33-linux-glibc2.12-x86_64.tar.gz '
COLOR='echo -e \E[01;31m'
END='\E[0m'
MYSQL_ROOT_PASSWORD=123

#wget https://mirrors.tuna.tsinghua.edu.cn/mysql/downloads/MySQL-8.0/$MYSQL

#wget https://mirrors.tuna.tsinghua.edu.cn/mysql/downloads/MySQL-5.7/$MYSQL

mkdir /data &> /dev/null

check (){

if [ $UID -ne 0 ]; then
  action "当前用户不是root,安装失败" false
  exit 1
fi

cd  $SRC_DIR
if [ !  -e $MYSQL ];then
        $COLOR"缺少${MYSQL}文件"$END
		$COLOR"请将相关软件放在${SRC_DIR}目录下"$END
        exit
elif [ -e /usr/local/mysql ];then
        action "数据库已存在，安装失败" false
        exit
else
	return
fi
} 

    $COLOR"开始安装MySQL数据库..."$END
	yum  -y -q install libaio numactl-libs   libaio &> /dev/null
    cd $SRC_DIR
    tar xf $MYSQL -C /usr/local/
    MYSQL_DIR=`echo $MYSQL| sed -nr 's/^(.*[0-9]).*/\1/p'`
    ln -s  /usr/local/$MYSQL_DIR /usr/local/mysql
    chown -R  root.root /usr/local/mysql/
    id mysql &> /dev/null || { useradd -s /sbin/nologin -r  mysql ; action "创建mysql用户"; }
        
    echo 'PATH=/usr/local/mysql/bin/:$PATH' > /etc/profile.d/mysql.sh
    .  /etc/profile.d/mysql.sh
	ln -s /usr/local/mysql/bin/* /usr/bin/ &> /dev/null
    cat > /etc/my.cnf << EOF
[mysqld]
server-id=1
log-bin
datadir=/data/mysql
socket=/data/mysql/mysql.sock                                                                                                   
log-error=/data/mysql/mysql.log
pid-file=/data/mysql/mysql.pid
[client]
socket=/data/mysql/mysql.sock
EOF
    mysqld --initialize --user=mysql --datadir=/data/mysql 
    cp /usr/local/mysql/support-files/mysql.server  /etc/init.d/mysqld
    chkconfig --add mysqld
    chkconfig mysqld on
    service mysqld start
    [ $? -ne 0 ] && { $COLOR"数据库启动失败，退出!"$END;exit; }
    MYSQL_OLDPASSWORD=`awk '/A temporary password/{print $NF}' /data/mysql/mysql.log`
    mysqladmin  -uroot -p$MYSQL_OLDPASSWORD password $MYSQL_ROOT_PASSWORD &>/dev/null
    action "数据库安装完成" 

VERSION=`cat /etc/os-release | awk -F"[ \"]"   NR==5'{print $2}'`

if [ VERSION = 8 ];then

   ln -s /usr/lib64/libtinfo.so.6.1 /usr/lib64/libtinfo.so.5 &> /dev/null
    exit
else
    exit
fi
check


install_mysql

#fi

}

install_php(){
PACK='php-7.3.7.tar.gz'
COLOR='echo -e \E[01;31m'
END='\E[0m'
DIR='/usr/local/src/'
VERSION=`cat /etc/os-release | awk -F"[ \"]"   NR==5'{print $2}'`

if [ $VERSION = 8 ];then
YUM_PACK8='wget autoconf automake libtool libxml2-devel sqlite-devel oniguruma'
    $COLOR"检测到系统为centos8，开始安装依赖！！"$END
yum install -y $YUM_PACK8 &> /dev/null
    $COLOR"开始下载依赖包"$END
wget https://codeload.github.com/kkos/oniguruma/tar.gz/v6.9.4 -O oniguruma-6.9.4.tar.gz 
    $COLOR"开始安装依赖"$END    
tar -zxf oniguruma-6.9.4.tar.gz 
cd oniguruma-6.9.4/
./autogen.sh && ./configure --prefix=/usr &> /dev/null
make -s && make install -s &> /dev/null
    $COLOR"安装完成！"$END
else
    $COLOR"开始安装！"$END

fi
if [ -f $DIR$PACK ];then
    ins_php
else
    $COLOR"源码包不存在！开始下载！"$END
    yum -y install wget &> /dev/null
    wget --no-check-certificate -P $DIR http://www.php.net/distributions/$PACK
if [ $? -eq 0 ];then
$COLOR"下载成功！！"$END
    ins_php
else
$COLOR"下载失败，请检查网络配置！！"$END
exit
fi
fi
}


ins_php() {
YUM_PACK='libxml2-devel libxml2 sqlite sqlite-devel libcurl-devel sqlite-devel oniguruma oniguruma-devel libicu-devel bzip2-devel ntp make openssl openssl-devel pcre pcre-devel libpng libpng-devel libjpeg-6b libjpeg-devel-6b freetype freetype-devel gd gd-devel zlib zlib-devel gcc gcc-c++ libXpm libXpm-devel ncurses ncurses-devel libmcrypt libmcrypt-devel libxml2 libxml2-devel imake autoconf automake screen sysstat compat-libstdc++-33 curl curl-deve postgresql-devel libtidy  libtidy-devel'
PACK='php-7.3.7.tar.gz'
DIR='php-7.3.7'
#CPU=`lscpu | awk '/^CPU\(s)/{print $2}'`
COLOR='echo -e \E[01;31m'
END='\E[0m'
USER='php'
SRC_DIR='/usr/local/src/'



num=$(rpm -qa|grep -c php)
if [ $num -gt 0 ];then
   $COLOR "$USER组件已经全部安装！"$END
   exit
else
   $COLOR "$USER开始安装！"$END
   #wget http://cn2.php.net/distributions/$PACK

if [ -f $SRC_DIR$PACK ];then
   $COLOR "$USER源码包存在，开始解压.."$END
   cd $SRC_DIR && tar xf $PACK
   mkdir /apps &> /dev/null
   $COLOR "开始安装依赖"$END
   yum -y install $YUM_PACK &> /dev/null
   $COLOR "开始编译安装$USER"$END
   cd $DIR
   ./configure --prefix=/apps/php --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-openssl --with-zlib --with-config-file-path=/etc --with-config-file-scan-dir=/etc/php.d --enable-mbstring --enable-xml --enable-sockets --enable-fpm --enable-maintainer-zts --disable-fileinfo &> /dev/null
   
   make -s &> /dev/null
   make install -s &> /dev/null
   $COLOR "开始创建软连接"$END
   ln -s /apps/php/sbin/php-fpm /usr/sbin/ &> /dev/null
    
   $COLOR "准备配置文件中..." $END
   cp php.ini-production /etc/php.ini &> /dev/null

   cp sapi/fpm/php-fpm.service /usr/lib/systemd/system/ &> /dev/null

   cd /apps/php/etc

   cp php-fpm.conf.default php-fpm.conf &> /dev/null

   cd /apps/php/etc/php-fpm.d/

   cp www.conf.default www.conf &> /dev/null

   

   read -p "$(echo -e '\033[1;32m请输入结合php的web用户:\033[0m')" PHPUSER

   sed -ri.bak "/^user.*/c user = $PHPUSER" /apps/php/etc/php-fpm.d/www.conf

   sed -ri.bak "/^group.*/c group = $PHPUSER" /apps/php/etc/php-fpm.d/www.conf

   mkdir /etc/php.d/ &> /dev/null

cat > /etc/php.d/opcache.ini << EOF
[opcache]
zend_extension=opcache.so
opcache.enable=1
EOF
systemctl daemon-reload &> /dev/null

systemctl enable --now php-fpm.service &> /dev/null


sleep 5

ss -ntlp|grep -wq 9000
if [ $? -eq 0 ];then
    $COLOR "$USER服务启动成功"$END
    exit
 else
    $COLOR "$USER服务启动失败!!!"$END
    exit
fi

else 

    $COLOR "$USER源码包不存在！正在退出"$END
    exit

fi
fi
}

install_nginx(){
PACK='nginx-1.18.0.tar.gz'
COLOR='echo -e \E[01;31m'
END='\E[0m'
DIR='/usr/local/src/'


if [ -f $DIR$PACK ];then
    ins_nginx
else
    $COLOR"源码包不存在！开始下载！"$END
    wget -P $DIR https://nginx.org/download/$PACK
if [ $? -eq 0 ];then
    $COLOR"下载成功！！"$END    
    ins_nginx
else
    $COLOR"源码下载失败!!!"$END
    exit
fi
fi
}

ins_nginx() {
DIR='/usr/local/src/'
PACK='nginx-1.18.0.tar.gz'
DIR='nginx-1.18.0'
USER='nginx'
COLOR='echo -e \E[01;31m'
END='\E[0m'
YUM_PACK='gcc pcre-devel openssl-devel make'
SRC_DIR='/usr/local/src/'

if [ -f $SRC_DIR$PACK ];then
        $COLOR "$USER源码包存在,开始解压..."$END
        cd $SRC_DIR && tar xf $PACK
        mkdir /apps &> /dev/null
        $COLOR "开始安装$USER编译所需环境"$END
        yum -y install $YUM_PACK > /dev/null
        $COLOR "开始创建$USER用户"$END
        grep -q $USER /etc/passwd
        if [ $? -eq 0 ];then
        $COLOR " $USER用户已经存在！退出中！"$END
        exit
        else
        useradd $USER -s /sbin/nologin -u 2000 &> /dev/null
        fi
        $COLOR "开始安装$USER"$END
        cd $DIR 
        ./configure --prefix=/apps/nginx --user=nginx --group=nginx --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_stub_status_module --with-http_gzip_static_module --with-pcre --with-stream --with-stream_ssl_module --with-stream_realip_module &> /dev/null
        make -s &> /dev/null 
        make install -s &> /dev/null
        $COLOR "开始修改$USER配置文件"$END
        read -p "$(echo -e '\033[1;32m是否开启php设置？1:开启 2:不开启 :\033[0m')" ngoption
        if [ $ngoption = 1 ];then
        sed -i '45 s/index.html/index.php/' /apps/nginx/conf/nginx.conf
        sed -i '65,71 s/#//' /apps/nginx/conf/nginx.conf
        sed -i '69 s/\/scripts/$document_root/' /apps/nginx/conf/nginx.conf
        $COLOR "创建测试页面"$END
        echo "<?php phpinfo(); ?>" > /apps/nginx/html/index.php
        $COLOR "开启$USER索引"$END
        sed -ri "/octet-stream;/a \         autoindex on;" /apps/nginx/conf/nginx.conf
        elif [ $ngoption = 2 ];then
          $COLOR"开始创建服务文件"$END   
        else
          $COLOR"输入错误！"$END
        fi



cat > /usr/lib/systemd/system/nginx.service << EOF
[Unit]
Description=nginx - high performance web server
Documentation=http://nginx.org/en/docs/
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target
[Service]
Type=forking
PIDFile=/apps/nginx/run/nginx.pid
ExecStart=/apps/nginx/sbin/nginx -c /apps/nginx/conf/nginx.conf
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s TERM $MAINPID
LimitNOFILE=100000
[Install]
WantedBy=multi-user.target
EOF

mkdir /apps/nginx/run/ &> /dev/null

sed -i '/^#pid/c pid   /apps/nginx/run/nginx.pid;' /apps/nginx/conf/nginx.conf


systemctl daemon-reload
systemctl start nginx



    ss -ntlp|grep -wq 80
    if [ $? -eq 0 ];then
        $COLOR "$USER服务启动成功"$END
        ln -s /apps/$USER/sbin/$USER /usr/sbin/ &> /dev/null
        exit
    else
        $COLOR "$USER服务启动失败!!!"$END
        exit
    fi

else
   $COLOR "$USER源码包不存在,请检查!!"$END
   sleep 3
   fi


#fi

}


install_memcached(){
PACK='memcached-1.6.6.tar.gz'
COLOR='echo -e \E[01;31m'
END='\E[0m'
DIR='/usr/local/src/'

if [ -f $DIR$PACK ];then
    ins_memcached
else
    $COLOR"源码包不存在！开始下载！"$END
    yum -y install wget &> /dev/null
    wget -P $DIR http://memcached.org/files/$PACK
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
   ins_memcached
else
   $COLOR"下载失败，请检查网络配置！！"$END
   exit
fi
fi
}


ins_memcached(){
TOM='memcached-1.6.6.tar.gz'
DIR='memcached-1.6.6'
COLOR='echo -e \E[01;31m'
END='\E[0m'
MUSER='memcached'
YUM_PACK='gcc libevent-devel make'
SRC_DIR='/usr/local/src/'


if [ -f $SRC_DIR$TOM ];then

   
$COLOR "$MUSER 源码包存在!开始安装"
    mkdir /apps &> /dev/null

$COLOR "开始安装依赖"$END
yum -y install $YUM_PACK  > /dev/null

$COLOR "开始解压"$END
cd $SRC_DIR && tar xf $TOM

cd $DIR/

$COLOR "编译安装开始"$END

sleep 2

./configure --prefix=/apps/memcached --enable-threads &> /dev/null

make -s &> /dev/null
make install -s &> /dev/null

grep -q $MUSER /etc/passwd

if [ $? -eq 0 ];then
   $COLOR " $MUSER 用户已经存在！退出中！"$END
   exit
else
   useradd -r -s /sbin/nologin $MUSER &> /dev/null
fi




$COLOR "准备配置文件"$END

cat > /etc/sysconfig/memcached <<EOF
PORT="11211"
USER="memcached"
MAXCONN="1024"
CACHESIZE="64"
OPTIONS=""
#OPTIONS="-l 127.0.0.1,::1"
EOF



$COLOR "开始创建配置文件"$END

#memcached -u memcached -m 2048 -c 65536 -d


cat > /lib/systemd/system/memcached.service << EOF
"[Unit]
Description=memcached daemon
Before=httpd.service
After=network.target

[Service]
EnvironmentFile=/etc/sysconfig/memcached
ExecStart=/apps/memcached/bin/memcached -p \${PORT} -u \${USER} -m \${CACHESIZE} -c \${MAXCONN} \$OPTIONS
PrivateTmp=true

[Install]
WantedBy=multi-user.target"
EOF

$COLOR "开始启动服务"$END
sleep 3

systemctl daemon-reload > /dev/null


$COLOR "开始创建软连接"$END
ln -s /apps/$MUSER/bin/$MUSER /usr/sbin/ &> /dev/null

$COLOR "启动$MUSER 中！"$END
#/apps/$USER/bin/$USER -d -u root -m 512 127.0.0.1 -p 11211 &> /dev/null
systemctl start $MUSER


sleep 5

ss -ntl|grep -wq 11211
if [ $? -eq 0 ];then   
   $COLOR "$MUSER 服务启动成功"$END
   exit
else
   $COLOR "$MUSER 服务启动失败"$END
   exit      
fi

else
   $COLOR "$MUSER 源码包不存在！正在退出！"$END
   exit
  

fi

#fi


}


install_jdk(){
JAVA_JDK='OpenJDK8U-jdk_x64_linux_openj9_linuxXL_8u282b08_openj9-0.24.0.tar.gz'
COLOR='echo -e \E[01;31m'
END='\E[0m'
DIR='/usr/local/src/'

if [ -f $DIR$JAVA_JDK ];then
    ins_jdk
else
    $COLOR "jdk不存在!开始下载！"$END
    yum -y install wget &> /dev/null
    wget -P $DIR https://mirrors.tuna.tsinghua.edu.cn/AdoptOpenJDK/8/jdk/x64/linux/$JAVA_JDK
if [ $? -eq 0 ];then
    $COLOR"下载成功！！"$END
    ins_jdk
    else
    $COLOR"下载失败，请检查网络配置！！"$END
exit
fi
   
fi

}




ins_jdk() {
#JAVA_JDK=OpenJDK8U-jdk_x64_linux_hotspot_8u292b10.tar.gz
JAVA_JDK='OpenJDK8U-jdk_x64_linux_openj9_linuxXL_8u282b08_openj9-0.24.0.tar.gz'
JAVADIR='jdk8u282-b08'
#JAVA_JDK='jdk-8u241-linux-x64.tar.gz'
#JAVADIR='jdk1.8.0_241'
COLOR='echo -e \E[01;31m'
END='\E[0m'
USER='java'
JAVA_DIR='/usr/local/jdk'
DIR='/usr/local/src/'

#wget https://mirrors.tuna.tsinghua.edu.cn/AdoptOpenJDK/8/jdk/x64/linux/$JAVA_JDK

#https://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-10/v10.0.7/bin/apache-tomcat-10.0.7.tar.gz

#wget https://mirrors.bfsu.edu.cn/apache/tomcat/tomcat-8/v8.5.66/bin/$TOM_PACK

if [ -f $DIR$JAVA_JDK ];then
   $COLOR "jdk存在，开始解压!"$END
   cd $DIR && tar xf $JAVA_JDK
   $COLOR "开始部署jdk"$END
   mv $JAVADIR/ /usr/local/ &> /dev/null
   $COLOR "开始创建软连接"$END
   ln -s /usr/local/$JAVADIR/ /usr/local/jdk &> /dev/null
   $COLOR "配置jdk变量"$EHD
cat > /etc/profile.d/jdk.sh <<EOF
export JAVA_HOME=$JAVA_DIR
export JRE_HOME=\$JAVA_HOME/jre
export CLASSPATH=\$JAVA_HOME/lib/:\$JRE_HOME/lib/
export PATH=\$PATH:\$JAVA_HOME/bin
EOF
source /etc/profile.d/jdk.sh

   #sed -ri.bak '/pathmunge/a \export JAVA_HOME=/usr/local/jdk8u292-b10\nexport PATH=$JAVA_HOME/bin:$PATH' /etc/profile
   #source /etc/profile
   $COLOR "启动java中!"$END
   java -version && $COLOR "JDK 安装完成,建议退出让变量生效！" $END || { $COLOR "JDK 安装失败" $END false ; exit; }
   exit
else
   $COLOR "jdk不存在!请检查源码包是否存在！"$END
   exit
fi


}

install_tomcat(){
#TOM_PACK='apache-tomcat-10.0.7.tar.gz'
TOM_PACK='apache-tomcat-8.5.70.tar.gz'
COLOR='echo -e \E[01;31m'
END='\E[0m'
DIR='/usr/local/src/'

java -version &> /dev/null
if [ $? -eq 0 ];then
   $COLOR"检测到java存在！开始安装！"$END
else
   $COLOR"java不存在!!请先部署jdk！"$END
   exit
fi


if [ -f $DIR$TOM_PACK ];then
    ins_tomcat
else
    $COLOR"源码包不存在！开始下载！"$END
    yum -y install wget &> /dev/null
    wget -P $DIR https://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-8/v8.5.70/bin/$TOM_PACK
    #wget https://mirrors.bfsu.edu.cn/apache/tomcat/tomcat-10/v10.0.7/bin/$TOM_PACK
    #wget https://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-10/v10.0.7/bin/$TOM_PACK
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
   ins_tomcat
else
   $COLOR"下载失败，请检查网络配置！！"$END
   exit
fi


fi

}

ins_tomcat(){
DIR='/apps'
TOM_PACK='apache-tomcat-8.5.70.tar.gz'
TOMDIR='apache-tomcat-8.5.70'
#TOM_PACK='apache-tomcat-10.0.7.tar.gz'
#TOMDIR='apache-tomcat-10.0.7'
TOMUSER='tomcat'
COLOR='echo -e \E[01;31m'
END='\E[0m'
SRC_DIR='/usr/local/src/'




if [ -f $SRC_DIR$TOM_PACK ];then
   $COLOR "TOMCAT源码包存在，开始解压!"$END
         mkdir /apps &> /dev/null
         cd $SRC_DIR && tar xf $TOM_PACK &> /dev/null
   $COLOR "开始部署tomcat"$END
         useradd -r -s /sbin/nologin $TOMUSER
         mkdir $DIR &> /dev/null
         mv $TOMDIR $DIR/ &> /dev/null
         ln -s $DIR/$TOMDIR/ /$DIR/$TOMUSER
   
   $COLOR "创建TOMCAT环境"$END
         source /etc/profile
         #useradd -r -s /sbin/nologin $TOMUSER
         chown -R tomcat.tomcat $DIR/$TOMUSER/
         

cat > $DIR/$TOMUSER/conf/$TOMUSER.conf <<EOF
JAVA_HOME=/usr/local/jdk
EOF


cat > /lib/systemd/system/tomcat.service <<EOF
[Unit]
Description=Tomcat
#After=syslog.target network.target remote-fs.target nss-lookup.target
After=syslog.target network.target

[Service]
Type=forking
EnvironmentFile=/apps/tomcat/conf/tomcat.conf
ExecStart=/apps/tomcat/bin/startup.sh
ExecStop=/apps/tomcat/bin/shutdown.sh
PrivateTmp=true
User=tomcat
Group=tomcat

[Install]
WantedBy=multi-user.target
EOF







   $COLOR "启动$TOMUSER"$END
    #/apps/tomcat/bin/startup.sh > /dev/null
    systemctl daemon-reload
    systemctl start $TOMUSER
    



sleep 5
ss -ntlp|grep -wq 8080
if [ $? -eq 0 ];then
   $COLOR "tomcat启动成功!"$END
   exit
else
   $COLOR "tomcat启动失败!"$END
   exit
fi

else

  $COLOR "TOMCAT源码包不存在!请检查源码包是否存在!"$END
exit
fi

}


IN_docker(){
read -p "$(echo -e '\033[1;32m请选择安装方式 1.二进制 2.yum：\033[0m')" option

if [ $option = 1 ];then
   ins_docker
elif [ $option = 2 ];then
   yum_docker
else
   echo "输入错误！"
fi
}














ins_docker(){
PACK='docker-19.03.15.tgz'
DIR='/usr/local/src/'
COLOR='echo -e \E[01;31m'
END='\E[0m'
YUM_PACK='wget lvm2'


if [ -f $DIR$PACK ];then
    $COLOR"检测到源码包存在！开始安装"$END
    install_docker
else
    $COLOR"源码包不存在！开始下载"$END
    yum -y install $YUN_PACK &> /dev/null
    wget -P $DIR https://download.docker.com/linux/static/stable/x86_64/$PACK
if [ $? -eq 0 ];then
    $COLOR"下载成功！！"$END
    install_docker
else
    $COLOR"下载失败，请检查网络配置！！"$END
   exit
fi

fi
}








install_docker(){
PACK='docker-19.03.15.tgz'
DIR='/usr/local/src/'
COLOR='echo -e \E[01;31m'
END='\E[0m'
YUM_PACK='wget lvm2'
USER='docker'
DODIR='/usr/bin/'


    $COLOR"开始安装docker！"$END
    cd $DIR
    tar xzf $PACK
    cp $USER/* $DODIR
    $COLOR"开始准备配置文件"$END
cat > /lib/systemd/system/docker.service <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/bin/dockerd
ExecReload=/bin/kill -s HUP \$MAINPID
LimitNOFILE=infinity
LimitNPROC=infinity
TimeoutStartSec=0
Delegate=yes
KillMode=process
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
EOF



mkdir /etc/docker/ -p &> /dev/null

cat > /etc/docker/daemon.json <<EOF
{
"registry-mirrors" : [    
    "https://registry.docker-cn.com",
    "https://docker.mirrors.ustc.edu.cn",                                                                              
    "http://hub-mirror.c.163.com"
     ]   
}
EOF
   groupadd docker &> /dev/null
   $COLOR"启动docker中"$END
   systemctl daemon-reload
   systemctl enable --now $USER && $COLOR "$USER安装完成" $END || { $COLOR "$USER安装失败" $END false ; exit; }
   exit
}






yum_docker(){
num=$(rpm -qa|grep -c docker)
if [ $num -gt 0 ];then
   $COLOR "docker已经安装！"$END
   exit
else

$COLOR "开始安装依赖"$END

yum install -y yum-utils device-mapper-persistent-data lvm2 &> /dev/null

$COLOR "开始设置仓库"$END

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo &> /dev/null

wget -O /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/centos/docker-ce.repo

#sed -i 's+download.docker.com+mirrors.tuna.tsinghua.edu.cn/docker-ce+' /etc/yum.repos.d/docker-ce.repo

$COLOR "安装docker中.."$END

yum install -y docker-ce docker-ce-cli containerd.io &> /dev/null


mkdir /etc/docker/ -p &> /dev/null

#cat > /etc/docker/daemon.json <<EOF
#i{
#"registry-mirrors" : [    
#    "https://registry.docker-cn.com",
##    "https://docker.mirrors.ustc.edu.cn",                                                                              
#    "http://hub-mirror.c.163.com",
#    "https://cr.console.aliyun.com/"
#     ]   
#}
#EOF

$COLOR "启动docker中"$END

systemctl enable --now docker

docker -v && $COLOR "docker 安装完成" $END || { $COLOR "docker 安装失败" $END false ; exit; }
exit

fi
}



















install_tengine(){
PACK='tengine-2.3.2.tar.gz'
COLOR='echo -e \E[01;31m'
END='\E[0m'
DIR='/usr/local/src/'

$COLOR "注意！！该软件在centos8上存在问题！请谨慎安装！"$END

sleep 10


if [ -f $DIR$PACK ];then
    ins_tengine
else
    $COLOR "源码包不存在！开始下载tengine源码包"$END 
    yum -y install wget &> /dev/null
    wget -P $DIR http://tengine.taobao.org/download/$PACK
if [ $? -eq 0 ];then
    $COLOR"下载成功！！"$END
    ins_tengine
else
    $COLOR"下载失败，请检查网络配置！！"$END
    exit
fi 


fi
}


ins_tengine(){
VERSION='tengine-2.3.2'
PACK='tengine-2.3.2.tar.gz'
DIR='/usr/local/src'
USER='nginx'
COLOR='echo -e \E[01;31m'
END='\E[0m'
YUM_PACK='gcc pcre-devel openssl-devel make'
SRC_DIR='/usr/local/src/'


#$COLOR "开始下载tengine源码包"$END

#wget http://tengine.taobao.org/download/$PACK


if [ -f $SRC_DIR$PACK ];then
   
   mkdir /apps &> /dev/null
   sleep 20
   $COLOR "tengine源码包存在,开始解压.."$END
   $COLOR "开始创建nginx用户"$END
   grep -q $USER /etc/passwd
if [ $? -eq 0 ];then
   $COLOR " $USER 用户已经存在！退出中！"$END
   exit
else
   useradd $USER -s /sbin/nologin -u 2000 &> /dev/null
fi
   cd $SRC_DIR && tar xf $PACK
   $COLOR "开始安装依赖"$END
   yum -y install $YUM_PACK &> /dev/null
   $COLOR "开始编译安装$PACK"$END
   cd $VERSION 
   ./configure --prefix=/apps/tengine-2.3.2 --user=nginx --group=nginx --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_stub_status_module --with-http_gzip_static_module --with-pcre --with-stream --with-stream_ssl_module --with-stream_realip_module &> /dev/null
   make -s &> /dev/null
   make install -s &> /dev/null
   $COLOR "开始创建软连接"$END
   ln -s /apps/$VERSION/sbin/* /usr/sbin/ &> /dev/null
   $COLOR "正在启动tengine!"$END
   `nginx`
   
sleep 3

ss -ntlp|grep -wq 80
if [ $? -eq 0 ];then
   $COLOR "tengine服务启动成功"$END
   exit
else
   $COLOR "tengine服务启动失败"$END
   exit
fi
else
   $COLOR "$VERSION 源码包不存在！正在退出！"$END
   exit

fi

}

install_openresty() {
PACK='openresty-1.17.8.2.tar.gz'
COLOR='echo -e \E[01;31m'
END='\E[0m'
DIR='/usr/local/src/'

if [ -f $DIR$PACK ];then
    ins_openresty
else
    $COLOR "源码包不存在！开始下载源码包!"$END
    yum -y install wget &> /dev/null
    wget -P $DIR https://openresty.org/download/$PACK
if [ $? -eq 0 ];then
    $COLOR"下载成功！！"$END
    ins_openresty
else
    $COLOR"下载失败，请检查网络配置！！"$END
  exit
fi
fi
}

ins_openresty(){
VERSION='openresty-1.17.8.2'
PACK='openresty-1.17.8.2.tar.gz'
DIR='/usr/local/src/'
USER='nginx'
COLOR='echo -e \E[01;31m'
END='\E[0m'
YUM_PACK='gcc pcre-devel openssl-devel make'

#$COLOR "开始下载源码包"$END

#if [ ! -d /root/$PACK/ ];then

#wget https://openresty.org/download/$PACK

#else

if [ -f $DIR$PACK ];then
   $COLOR "源码包存在,开始解压.."$END
   mkdir /apps &> /dev/null
   $COLOR "开始创建nginx用户"$END
   grep -q $USER /etc/passwd
if [ $? -eq 0 ];then
   $COLOR " $USER 用户已经存在！退出中！"$END
   exit
else
   useradd $USER -s /sbin/nologin -u 2000 &> /dev/null
fi

   cd $DIR && tar xf $PACK
   $COLOR "开始安装依赖"$END
   yum -y install $YUM_PACK &> /dev/null
   $COLOR "开始编译安装$PACK"$END
   cd $VERSION
   ./configure  --prefix=/apps/openresty --user=nginx --group=nginx --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_stub_status_module --with-http_gzip_static_module --with-pcre --with-stream --with-stream_ssl_module --with-stream_realip_module &> /dev/null
   make -s &> /dev/null
   make install -s &> /dev/null
   $COLOR "开始创建软连接"$END
   ln -s /apps/openresty/nginx/sbin/nginx /usr/bin/ &> /dev/null
   sleep 2
   $COLOR "正在启动openresty!"$END
   nginx
   sleep 3

ss -ntlp|grep -wq 80
if [ $? -eq 0 ];then
   $COLOR "openresty服务启动成功"$END
   exit
else
   $COLOR "openresty服务启动失败"$END
   exit      
fi

else
   $COLOR "$VERSION 源码包不存在！正在退出！"$END
   exit
fi
#fi

}

install_keepalived(){
PACK='keepalived-2.0.20.tar.gz'
COLOR='echo -e \E[01;31m'
END='\E[0m'
DIR='/usr/local/src/'

if [ -f $DIR$PACK ];then
    ins_keepalived
else
    $COLOR "源码包不存在,开始下载！"$END
    yum -y install wget &> /dev/null
    wget -P $DIR https://keepalived.org/software/$PACK
if [ $? -eq 0 ];then
    $COLOR"下载成功！！"$END
    ins_keepalived
else
    $COLOR"下载失败，请检查网络配置！！"$END
    exit
fi  

fi
}

ins_keepalived() {
VERSION='keepalived-2.0.20'
PACK='keepalived-2.0.20.tar.gz'
#DIR='/usr/local/src'
COLOR='echo -e \E[01;31m'
END='\E[0m'
YUM_PACK='gcc curl openssl-devel libnl3-devel net-snmp-devel make'
VER=`cat /etc/os-release | awk -F"[ \"]"   NR==5'{print $2}'`
USER='keepalived'
DIR='/usr/local/src/'

#$COLOR "开始下载源码包"$END

#wget https://keepalived.org/software/$PACK

if [ -f $DIR$PACK ];then
   $COLOR "$USER 源码包存在,开始解压.."$END
   mkdir /apps &> /dev/null
   cd $DIR && tar xf $PACK
   cd $VERSION
   $COLOR "开始安装依赖"
   yum install -y $YUM_PACK &> /dev/null
   $COLOR "开始编译安装 $USER "$END
   ./configure --prefix=/apps/keepalived --disable-fwmark &> /dev/null
   make -s &> /dev/null
   make install -s &> /dev/null
   $COLOR "开始准备配置文件 ！"$END
   mkdir /etc/$USER/conf.d/ -p &> /dev/null
   mv /etc/$USER/$USER.conf /etc/$USER/$USER.conf.bak &> /dev/null
   read -p "$(echo -e '\033[1;32m请输入vip: \033[0m')" VIP
   read -p "$(echo -e '\033[1;32m请输入优先级: \033[0m')" VRD
cat > /etc/$USER/notify.sh << EOF
contact='192614911@qq.com'
notify() {
    mailsubject="$(hostname) to be $1, vip floating"
    mailbody="$(date +'%F %T'): vrrp transition, $(hostname) changed to be $1"
    echo "$mailbody" | mail -s "$mailsubject" $contact
}
case $1 in
master)
    notify master
    ;;  
backup)
    notify backup 
    ;;  
fault)
    notify fault
    ;;  
*)
    echo "Usage: $(basename $0) {master|backup|fault}"
    exit 1
    ;;                                                                                                                
esac
EOF
chmod a+x /etc/$USER/notify.sh


cat > /etc/$USER/$USER.conf << EOF
! Configuration File for keepalived
global_defs {
 notification_email {
 root@localhost
 }
 notification_email_from kaadmin@localhost
 smtp_server 127.0.0.1
 smtp_connect_timeout 30
 router_id ka1.1amyo.org
 vrrp_mcast_group4 224.0.100.100
}
}
vrrp_instance httpd {
 state BACKUP
 interface eth0
 virtual_router_id 66
 priority $VRD
 advert_int 1
 nopreempt
 #unicast_src_ip <IPADDR>
 #unicast_peer {
 #   <IPADDR>
 #}
 authentication {
 auth_type PASS
 auth_pass 123456
 }
 virtual_ipaddress {
 $VIP/24 dev eth0 label eth0:1
 }
#track_interface {
# eth0
# }
  notify_master "/etc/keepalived/notify.sh master"
  notify_backup "/etc/keepalived/notify.sh backup"
  notify_fault "/etc/keepalived/notify.sh fault"
# track_script {
# check_haproxy
# }
}
include /etc/keepalived/conf.d/*.conf 
EOF
   $COLOR "开始启动 $USER ！"$END
   systemctl start keepalived  && $COLOR "$USER启动成功" $END || { $COLOR "$USER启动失败" $END false ; exit; }
   exit

else
   $COLOR "源码包不存在！退出！"$END
   exit
fi

}


install_lua(){
PACK='lua-5.3.5.tar.gz'
COLOR='echo -e \E[01;31m'
END='\E[0m'
DIR='/usr/local/src/'

if [ -f $DIR$PACK ];then
    ins_lua
else
    $COLOR"源码包不存在！开始下载！"$END
    yum -y install wget &> /dev/null
    wget -P $DIR http://www.lua.org/ftp/$PACK
if [ $? -eq 0 ];then
    $COLOR"下载成功！！"$END
    ins_lua
else
    $COLOR"下载失败，请检查网络配置！！"$END
    exit
fi
    
fi
}

ins_lua(){
YUM_PACK='libtermcap-devel ncurses-devel libevent-devel readline-devel'
PACK='lua-5.3.5.tar.gz'
DIR='lua-5.3.5'
#CPU=`lscpu | awk '/^CPU\(s)/{print $2}'`
COLOR='echo -e \E[01;31m'
END='\E[0m'
USER='lua'
SRC_DIR='/usr/local/src/'

if [ -f $SRC_DIR$PACK ];then
    $COLOR "$USER 源码包存在，开始解压.."$END
    cd $SRC_DIR && tar xf $PACK
    $COLOR "开始安装依赖"$END
    yum -y install $YUM_PACK &> /dev/null
    $COLOR "开始安装$USER"$END
    cd $DIR
    make linux test &> /dev/null
    cd $SRC_DIR$DIR
    src/lua -v &&  $COLOR "LUA安装完成" $END || { $COLOR "LUA安装失败" $END false ; exit; } 
    exit
else
   $COLOR "$USER 源码包不存在！正在退出"$END
   exit
   exit
fi
}


install_HAProxy(){
PACK='haproxy-1.9.16.tar.gz'
COLOR='echo -e \E[01;31m'
END='\E[0m'
DIR='/usr/local/src/'


if [ -f $DIR$PACK ];then
    ins_HAProxy
else
    $COLOR"源码包不存在！开始下载！"
    yum -y install wget &> /dev/null
    wget -P $DIR https://www.haproxy.org/download/1.9/src/$PACK
if [ $? -eq 0 ];then
    $COLOR"下载成功！！"$END
   ins_HAProxy
else
    $COLOR"下载失败，请检查网络配置！！"$END
   exit
fi
  
fi
}


ins_HAProxy(){
PACK='haproxy-1.9.16.tar.gz'
COLOR='echo -e \E[01;31m'
END='\E[0m'
DIR='haproxy-1.9.16'
USER='haproxy'
YUM_PACK='gcc gcc-c++ glibc glibc-devel pcre pcre-devel openssl openssl-devel systemd-devel make'
LUA_DIR='lua-5.3.5'
SRC_DIR='/usr/local/src/'

if [ -f $SRC_DIR$PACK ];then
   $COLOR"$USER 源码包存在,开始解压.."$END
   cd $SRC_DIR && tar xf $PACK
   mkdir /apps &> /dev/null
   $COLOR"开始安装依赖"$END
   yum -y install $YUM_PACK &> /dev/null
#   $COLOR"正在配置lua环境"$END
   useradd -s /sbin/nologin $USER &> /dev/null
#if [ -f $SRC_DIR$LUA_DIR ];then
#       $COLOR"检测到$LUA_DIR，开始安装"$END
       cp -a $DIR/src/ /usr/local/lua/ &> /dev/null
  
  $COLOR"开始编译安装 $USER "$END
   cd $DIR
   make ARCH=x86_64 TARGET=linux2628 USE_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1 USE_SYSTEMD=1 USE_CPU_AFFINITY=1 PREFIX=/apps/haproxy -s &> /dev/null
   make install PREFIX=/apps/haproxy -s &> /dev/null
   $COLOR"开始创建$USER 软连接"$END
   ln -s /apps/$USER/sbin/$USER /usr/sbin/ &> /dev/null
   $COLOR"开始创建$USER 配置文件"$END
   mkdir /etc/$USER/conf.d/ -p &> /dev/null
   sysctl -w net.ipv4.ip_nonlocal_bind=1 &> /dev/null
   echo "sysctl -w net.ipv4.ip_nonlocal_bind=1" > /etc/rc.d/rc.local
   chmod +x /etc/rc.d/rc.local
cat > /usr/lib/systemd/system/haproxy.service << EOF
[Unit]
Description=HAProxy Load Balancer
After=syslog.target network.target

[Service]
ExecStartPre=/usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg -f /etc/haproxy/conf.d/ -c -q
ExecStart=/usr/sbin/haproxy -Ws -f /etc/haproxy/haproxy.cfg -f /etc/haproxy/conf.d/ -p /var/lib/haproxy/haproxy.pid
ExecReload=/bin/kill -USR2 \$MAINPID
LimitNOFILE=100000

[Install]
WantedBy=multi-user.target

EOF

mkdir /etc/$USER &> /dev/null

cat > /etc/$USER/$USER.cfg << EOF
global
maxconn 100000
chroot /apps/haproxy
stats socket /var/lib/haproxy/haproxy.sock mode 600 level admin
#uid 99
#gid 99
user haproxy
group haproxy
daemon

#nbproc 4
#cpu-map 1 0
#cpu-map 2 1
#cpu-map 3 2
#cpu-map 4 3
pidfile /var/lib/haproxy/haproxy.pid
log 127.0.0.1 local2 info

defaults
option http-keep-alive
option forwardfor
maxconn 100000
mode http
timeout connect 300000ms
timeout client 300000ms
timeout server 300000ms


listen stats
mode http
bind 0.0.0.0:9999
stats enable
log global
#stats refresh 10
stats realm HAProxy\ 
stats uri /status
stats auth admin:888888



#listen web_port
#bind 10.0.0.10:80
#mode tcp
#log global
#server web1 127.0.0.1:8080 check inter 3000 fall 2 rise5
#server web1 127.0.0.1:8080 check inter 3000 fall 2 rise5
EOF

read -p "$(echo -e '\033[1;32m请输入需要绑定的VIP和端口号例如 10.0.0.10:80 : \033[0m')" VIP
read -p "$(echo -e '\033[1;32m请输入后台服务器ip和端口例如 10.0.0.7:80 : \033[0m')" SERVER
read -p "$(echo -e '\033[1;32m请输入后台服务器ip和端口例如 10.0.0.17:80 : \033[0m')" SERVERI

cat > /etc/$USER/conf.d/test.cfg <<EOF
listen test_web
bind $VIP
mode tcp
server web1 $SERVER check
server web2 $SERVERI check
EOF






mkdir /var/lib/$USER &> /dev/null

chown $USER.$USER /var/lib/$USER/ -R &> /dev/null

systemctl start $USER &> /dev/null

sleep 5

   $COLOR"启动$USER 中！"$END

ss -ntlp|grep -wq 9999
if [ $? -eq 0 ];then
   $COLOR"$USER 服务启动成功"$END
    exit
else
   $COLOR"$USER 服务启动失败"$END
    exit      
fi

#else
#   $COLOR"$LUA_DIR 不存在！最少需要5.3.5版本！正在退出！"$END
#   exit
#fi


else
   $COLOR"$USER 源码包不存在！正在退出！"$END
exit
          

fi

}

install_wordpress(){
PACK='latest-zh_CN.tar.gz'
COLOR='echo -e \E[01;31m'
END='\E[0m'

$COLOR"该版本仅针对nginx使用！！如果是其他服务请自行修改配置！"$END

sleep 5

if [ -f /root/$PACK ];then
     ins_wordpress
else
     $COLOR "源码包不存在！，开始下载"$END
     yum -y install wget &> /dev/null
     wget https://cn.wordpress.org/$PACK
if [ $? -eq 0 ];then
     $COLOR"下载成功！！"$END
     ins_wordpress
else
     $COLOR"下载失败，请检查网络配置！！"$END
     exit
fi
     
fi
}

ins_wordpress(){
PACK='latest-zh_CN.tar.gz'
COLOR='echo -e \E[01;31m'
END='\E[0m'
USER='wordpress'
DIR='/apps/nginx/html/'





ss -ntlp|grep -wq 9000
if [ $? -eq 0 ];then
     $COLOR "正在检测php服务！请等待"$END
else
     $COLOR "未检测到php服务！退出！"$END
     exit
fi

ss -ntlp|grep -wq 80
if [ $? -eq 0 ];then
     $COLOR "正在检测web服务！请等待"$END
else
     $COLOR "未检测到web服务！退出！"$END
      exit
fi

if [ -f /root/$PACK ];then
     $COLOR "$USER 源码包存在，开始解压.."$END
     cd /root/ && tar xf $PACK
     $COLOR "正在解压到目录！"$END
     rm -rf /apps/nginx/html/*
     mv $USER/* $DIR
     cd $DIR && cp -a wp-config-sample.php wp-config.php
     chmod -R a+w wp-content
#read -p "$(echo -e '\033[1;32m请输入数据库密码:\033[0m')" MYSQL_PASS
#read -p "$(echo -e '\033[1;32m请输入数据库ip:\033[0m')" MYSQL_IP
     #mysql -uroot -p"$MYSQL_PASS" -e "create database wordpress;grant all on wordpress.* to wordpress@'''$MYSQL_IP''' identified by '$MYSQL_PASS'" &>/dev/null
     #sed -i.bak -e 's/database_name_here/wordpress/' -e 's/username_here/wordpress/' -e 's/password_here/'''$MYSQL_PASS'''/' -e 's/localhost/'''$MYSQL_IP'''/'  wp-config.php
     $COLOR"完成！！请进入网页目录下修改wp-config.php数据库信息！"$END
     exit
else
     $COLOR"$USER源码包不存在,请检查!!"$END
     exit
fi
}








#测试中
#install_lnmp(){
#COLOR='echo -e \E[01;31m'
#END='\E[0m'


#ss -ntlp|grep -wq 80
#if [ $? -eq 0 ];then
#    $COLOR "检测到web服务已存在！退出！"$END
#    exit
#else
#    $COLOR "开始安装nginx！"$END
#    install_nginx    
#fi

#ss -ntlp|grep -wq 9000
#if [ $? -eq 0 ];then
#    $COLOR "php已存在！退出！"$END
#    exit    
#else
#    $COLOR "开始安装php！"$END
#    install_php
#fi
#
#ss -ntlp|grep -wq 3306
#if [ $? -eq 0 ];then
#    $COLOR "mysql已经存在！退出！"$END
#    exit
#else
#    $COLOR "开始安装mysql！"$END
#    install_mysql
#fi
#}




install_halo(){
HALO_PACK='halo-1.4.8.jar -O halo.jar'
PACK='halo.jar'
COLOR='echo -e \E[01;31m'
END='\E[0m'

if [ -f /root/$PACK ];then
    ins_halo
else
    $COLOR"源码包不存在！开始下载！"$END
    yum -y install wget &> /dev/null
    wget https://dl.halo.run/release/$HALO_PACK

if [ $? -eq 0 ];then
    $COLOR"下载成功！！"$END
    ins_halo
else
    $COLOR"下载失败，请检查网络配置！！"$END
    exit
fi

    ins_halo
fi
}

ins_halo(){
HALO_PACK='halo.jar'
COLOR='echo -e \E[01;31m'
END='\E[0m'
JDK='java-11-openjdk'
JAR='halo-1.4.8.jar'
USER='halo'


if [ -f /root/$HALO_PACK ];then
   $COLOR"开始下载jdk依赖" 
   yum -y install $JDK &> /dev/null
   cd /root/
   $COLOR"开始配置halo环境"$END
   mkdir /root/.halo && cd /root/.halo
   mv /root/$HALO_PACK /root/.halo
   wget https://dl.halo.run/config/application-template.yaml -O /root/.halo/application.yaml &> /dev/null
   #这是官方配置文件,如果需要请去掉注释并注释掉下面的catEOF
   #wget https://dl.halo.run/config/halo.service -O /etc/systemd/system/halo.service &> /dev/null
   $COLOR"开始配置halo配置文件"$END
cat > /etc/systemd/system/halo.service << EOF
[Unit]
Description=Halo Service
Documentation=https://halo.run
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/java -server -Xms256m -Xmx256m -jar /root/.halo/halo.jar
ExecStop=/bin/kill -s QUIT $MAINPID
Restart=always
StandOutput=syslog

StandError=inherit

[Install]
WantedBy=multi-user.target
EOF
   $COLOR"开始启动halo服务！"$END
   systemctl daemon-reload &> /dev/null
   systemctl start $USER &> /dev/null

sleep 60

#这是halo的日志
#journalctl -n 20 -u halo

ss -ntlp | grep -wq 8090
if [ $? -eq 0 ];then
   $COLOR"$USER启动成功！"$END
   exit
else
   $COLOR"$USER启动失败!"$END
   exit
fi

else
   $COLOR"源码包不存在！退出！"$END
   exit
fi
}


install_redis(){
PACK='redis-5.0.8.tar.gz'
COLOR='echo -e \E[01;31m'
END='\E[0m'
DIR='/usr/local/src/'

if [ -f $DIR$PACK ];then
    ins_redis
else
   $COLOR"源码包不存在！开始下载！"$END
   yum -y install wget &> /dev/null
   wget -P $DIR http://download.redis.io/releases/redis-5.0.8.tar.gz

if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
   ins_redis
else
   $COLOR"下载失败，请检查网络配置！！"$END
   exit
fi

fi
}

ins_redis(){
PACK='redis-5.0.8.tar.gz'
USER='redis'
DIR='/apps/'
REDIS_DIR='redis-5.0.8'
YUM_PACK='gcc gcc-c++ make'
COLOR='echo -e \E[01;31m'
END='\E[0m'
SRC_DIR='/usr/local/src/'

if [ -f $SRC_DIR$PACK ];then
   $COLOR"源码包存在，开始下载依赖！"$END
   mkdir /apps &> /dev/null
   yum install -y $YUM_PACK &> /dev/null
   $COLOR"开始解压！"$END
   cd $SRC_DIR && tar xf $PACK &> /dev/null
   $COLOR"开始编译安装！"$END
   cd $REDIS_DIR &> /dev/null
   mkdir /apps/$USER/{etc,logs,data,run} -p &> /dev/null
   make install -s PREFIX=$DIR$USER &> /dev/null
   $COLOR"准备$USER 配置文件"$END
   cp -a $SRC_DIR$REDIS_DIR/$USER.conf $DIR$USER/etc/ &> /dev/null

cat > /usr/lib/systemd/system/$USER.service << EOF
[Unit]                                                                                                                 
Description=Redis persistent key-value database
After=network.target

[Service]
ExecStart=/apps/redis/bin/redis-server /apps/redis/etc/redis.conf --supervised systemd
ExecStop=/bin/kill -s QUIT \$MAINPID
#Type=notify
User=redis
Group=redis
RuntimeDirectory=redis
RuntimeDirectoryMode=0755

[Install]
WantedBy=multi-user.target
EOF


   $COLOR"创建$USER 用户"$END
   useradd -r -s /sbin/nologin redis
   chown $USER.$USER /apps/$USER/ -R &> /dev/null
   $COLOR"开始创建软连接"$END
   ln -s /apps/$USER/bin/$USER-* /usr/bin/ &> /dev/null
   sed -i '/^bind/c bind 0.0.0.0' /apps/redis/etc/redis.conf &> /dev/null
   sed -i '/^dir/c dir /apps/redis/data/' /apps/redis/etc/redis.conf &> /dev/null
   sed -i '/^logfile/c logfile "/apps/redis/logs/redis.log"' /apps/redis/etc/redis.conf &> /dev/null
   $COLOR"开始启动$USER"$END
   systemctl daemon-reload &> /dev/null
   systemctl start $USER

ss -ntlp|grep -wq 6379
if [ $? -eq 0 ];then
   $COLOR"$USER安装成功!"$END
   exit
else
   $COLOR"$USER安装失败!"$END
   exit
fi

else
   $COLOR "源码包不存在！退出！"$END
   exit
fi
}


install_zabbix(){
PACK='zabbix-5.0.10.tar.gz'
COLOR='echo -e \E[01;31m'
END='\E[0m'

$COLOR "请先准备好nginx和mysql zabbix存放路径为/apps/nginx/html"$END

sleep 5

if [ -f /root/$PACK ];then
    ins_zabbix
else
    $COLOR "源码包不存在！开始下载！"$END
    yum -y install wget &> /dev/null
    wget https://cdn.zabbix.com/zabbix/sources/stable/5.0/$PACK
    ins_zabbix
fi
}


ins_zabbix(){
USER='zabbix'
PACK='zabbix-5.0.10.tar.gz'
DIR='zabbix-5.0.10'
SRC_DIR='/apps'
YUM_PACK='libevent-devel wget tar gcc gcc-c++ make net-snmp-devel libxml2-devel libcurl-devel make'
COLOR='echo -e \E[01;31m'
END='\E[0m'
MYSQL_PACK='/usr/local/mysql/lib/libmysqlclient.so.20'

$COLOR "警告！！！确保主机有足够的内存最少4G内存！zabbix存放目录为/apps/nginx/html下！"$END
sleep 3


ss -ntlp|grep -wq 9000 
if [ $? -eq 0 ];then
   $COLOR "检测到已存在php！！继续执行"$END
else
   $COLOR "警告！！！未检测到php！！开始安装php！！"$END
   yum install -y epel-release yum-utils &> /dev/nul
   yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm &> /dev/null
   yum install -y php73-php-fpm php73-php-cli php73-php-bcmath php73-php-gd php73-php-json php73-php-mbstring php73-php-mcrypt php73-php-mysqlnd php73-php-opcache php73-php-pdo php73-php-pecl-crypto php73-php-pecl-mcrypt php73-php-pecl-geoip php73-php-pecl-swoole php73-php-recode php73-php-snmp php73-php-soap php73-php-xml &> /dev/null
   yum install -y php73-php-xml libxml2 openldap-devel libpng libpng-devel libjpeg libjpeg-devel freetype freetype-devel libXpm libXpm-devel libvpx libvpx-devel zlib zlib-devel t1lib t1lib-devel iconv iconv-devel libxml2 libxml2-devel bcmath  libmcrypt libmcrypt-devel gcc libcurl-devel gd gd-devel openssl openssl-devel &> /dev/null 
    yum install -y libevent-devel wget tar gcc gcc-c++ make net-snmp-devel libxml2-devel libcurl-devel &> /dev/null
   systemctl restart php73-php-fpm
fi 

ss -ntlp|grep -wq 80
if [ $? -eq 0 ];then
   $COLOR "检测到web应用存在！继续执行。。"$END
else
   $COLOR "警告！！！未检测到web应用！请检查！！"$END
   sleep 5
   exit 
fi



ss -ntlp | grep -wq 3306
if [ $? -eq 0 ];then



if [ -f /root/$PACK ];then
   $COLOR "源码包存在，开始解压"$END
   cd /root/ && tar xf $PACK
   $COLOR "开始下载$USER所需依赖"$END
   mkdir /apps &> /dev/null
  useradd -s /sbin/nologin $USER &> /dev/null
   $COLOR "开始编译安装$USER"$END
   cd /root/$DIR
   ./configure --prefix=$SRC_DIR/$USER --enable-server --enable-agent --with-mysql=/usr/local/mysql/bin/mysql_config --with-net-snmp --with-libcurl --with-libxml2 &> /dev/null 
   make -s &> /dev/null
   make install -s &> /dev/null
   $COLOR "开始准备$USER环境"$END
   ln -s $SRC_DIR/$USER/sbin/* /usr/sbin/ &> /dev/null
MYSQL_PACK='/usr/local/mysql/lib/libmysqlclient.so.20'
if [ -f $MYSQL_PACK ];then
   ln -s /usr/local/mysql/lib/libmysqlclient.so.20  /usr/lib64/ &> /dev/null
else
   $COLOR "警告！！！mysql连接文件不存在！！$USER可能无法启动！"$END
   sleep 10
fi
   $COLOR "开始准备$USER数据库"$END
read -p "$(echo -e '\033[1;32m请输入mysql密码:\033[0m')" PASS
   mysql -uroot -p$PASS -e "create database zabbix character set utf8 collate utf8_bin;" &> /dev/null
   mysql -uroot -p$PASS -e "grant all privileges on zabbix.* to zabbix@'127.0.0.1' identified by 'zabbixpwd';" &> /dev/null
   mysql -uroot -p$PASS -e "flush privileges;" &> /dev/null
   mysql -uroot -p$PASS -e "set names utf8;" &> /dev/null
   mysql -uroot -p$PASS zabbix -e "source /root/$DIR/database/mysql/schema.sql;" 
   mysql -uroot -p$PASS zabbix -e "source /root/$DIR/database/mysql/images.sql;"
   mysql -uroot -p$PASS zabbix -e "source /root/$DIR/database/mysql/data.sql;"
   $COLOR "开始准备$USER配置文件"$END
   mv $SRC_DIR/$USER/etc/zabbix_server.conf $SRC_DIR/$USER/etc/zabbix_server.conf.bak
   $COLOR "开始启动$USER"$END
   mkdir $SRC_DIR/nginx/html/$USER
   chown $USER:$USER -R $SRC_DIR/$USER
   cp -a /root/$DIR/ui/* $SRC_DIR/nginx/html/$USER/
   touch  /apps/zabbix/etc/zabbix_server.conf 
cat > /apps/zabbix/etc/zabbix_server.conf <<EOF
LogFile=/tmp/zabbix_server.log
DBHost=127.0.0.1
DBName=zabbix
DBUser=$USER
DBPassword=zabbixpwd
EOF

touch  /apps/nginx/html/zabbix/conf/zabbix.conf.php
cat > /apps/nginx/html/zabbix/conf/zabbix.conf.php <<EOF
<?php
// Zabbix GUI configuration file.
global \$DB;

\$DB['TYPE']     = 'MYSQL';
\$DB['SERVER']   = '127.0.0.1';
\$DB['PORT']     = '3306';
\$DB['DATABASE'] = 'zabbix';
\$DB['USER']     = 'zabbix';
\$DB['PASSWORD'] = 'zabbixpwd';

// Schema name. Used for IBM DB2 and PostgreSQL.
\$DB['SCHEMA'] = '';

\$ZBX_SERVER      = 'localhost';
\$ZBX_SERVER_PORT = '10051';
\$ZBX_SERVER_NAME = '';

\$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
EOF
sed -i.bak '/post_max_size = 8M/c post_max_size = 32M' /etc/opt/remi/php73/php.ini 
sed -i.bak '/max_execution_time = 30/c max_execution_time = 300' /etc/opt/remi/php73/php.ini 
sed -i.bak '/max_input_time = 60/c max_input_time = 300' /etc/opt/remi/php73/php.ini 
sed -i.bak '/;date.timezone =/cdate.timezone = Asia/Shanghai' /etc/opt/remi/php73/php.ini 
systemctl restart php73-php-fpm
touch /usr/lib/systemd/system/zabbix_server.service
cat > /usr/lib/systemd/system/zabbix_server.service<<EOF
[Unit]
Description=Zabbix Server
After=syslog.target
After=network.target

[Service]
Environment="CONFFILE=/apps/zabbix/etc/zabbix_server.conf"
EnvironmentFile="-/root/zabbix-5.0.10/misc/init.d/gentoo/zabbix-server"
TYPE=forking
Restart=on-failure
PIDFile=/tmp/zabbix_server.pid
KillMode=control-group
ExecStart=/apps/zabbix/sbin/zabbix_server -c \$CONFFILE
ExecStop=/bin/kill -SIGTERM \$MAINPID
RestartSec=10s
TimeoutSec=infinity
[Install]
wantedBy=multi-user.target
EOF
touch /usr/lib/systemd/system/zabbix_agentd.service
cat > /usr/lib/systemd/system/zabbix_agentd.service<<EOF
[Unit]
Description=Zabbix agent 
After=syslog.target
After=network.target

[Service]
Environment="CONFFILE=/apps/zabbix/etc/zabbix_agentd.conf"
EnvironmentFile="-/root/zabbix-5.0.10/misc/init.d/debian/zabbix-agent"
TYPE=forking
Restart=on-failure
PIDFile=/tmp/zabbix_agentd.pid
KillMode=control-group
ExecStart=/apps/zabbix/sbin/zabbix_agentd -c \$CONFFILE
ExecStop=/bin/kill -SIGTERM \$MAINPID
RestartSec=10s
User=zabbix
Group=zabbix
[Install]
wantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl restart zabbix_server && systemctl enable --now zabbix_server
systemctl restart zabbix_agentd && systemctl enable --now zabbix_agentd


ss -ntlp|grep -wq 10051
if [ $? -eq 0 ];then
   $COLOR"$USER 服务启动成功,账号为Admin密码为zabbix"$END
    exit
else
   $COLOR"$USER 服务启动失败"$END
    exit      
fi





else
    $COLOR"未检测到mysql！请先安装mysql！"$END
    exit
fi


else
   $COLOR "源码包不存在！退出！"$END
    exit

fi
}



install_k8s(){
   #!/bin/bash
# k8s installation
# wrfly@1524493922

now=`date +%s`
function log() {
  echo "[$((`date +%s` - now ))] ## $@ ##"
}

log "Installation start at `date`"

# check
[[ `whoami` != "root" ]] && echo "Root Privilege needed, use sudo please." && exit 1
OS=`awk -F= '/^NAME/{print $2}' /etc/os-release | sed "s/\"//g"`
if [[ "$OS" == "Ubuntu" ]];then
  :
elif [[ "$OS" == "CentOS Linux" ]];then
  OS="CentOS"
else
  echo "Unknown OS: \"$OS\", exit"
  exit 2
fi

# prepare
MASTER="Y"
SINGLE_MASTER="N"
INSTALL_DOCKER="Y"
read -p "Install as a master node?: " -ei $MASTER MASTER
if [[ "$MASTER" == "Y" ]];then
  PRIMARY_IP=$(ip route get 8.8.8.8 | head -1 | awk '{print $7}')
  echo "All your IP addresses: `hostname --all-ip-addresses || hostname -I`"
  read -p "The API server's address will be: " -ei $PRIMARY_IP PRIMARY_IP
  read -p "Run this cluster as a single node?: " -ei $SINGLE_MASTER SINGLE_MASTER
fi

# install docker
read -p "Install Docker?: " -ei $INSTALL_DOCKER INSTALL_DOCKER
if [[ "$INSTALL_DOCKER" == "Y" ]];then
  log "install and upgrade docker"
  if [[ "$OS" == "Ubuntu" ]];then
    apt-get update
    apt-get -y install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add -
    add-apt-repository -u "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
    apt-get -y install docker-ce
  fi
 
  if [[ "$OS" == "CentOS" ]];then
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    yum makecache fast
    yum -y install docker-ce
    systemctl enable docker && systemctl start docker  
  fi
fi

# congifure mirror and insecure registries
log "congifure mirror and insecure registries"
cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://m.mirror.aliyuncs.com"],
  "insecure-registries" : ["quay-io.mirror.kfd.me", "k8s-gcr.mirror.kfd.me"]
}
EOF
systemctl daemon-reload && systemctl restart docker

# install k8s
log "install k8s"
if [[ "$OS" == "Ubuntu" ]];then
  apt-get install -y apt-transport-https curl wget
  ## I built a reverse proxy here, but you can use aliyun for a better donwload speed
  # curl -fsSL http://packagescloudgooglecom.kfd.me/apt/doc/apt-key.gpg | apt-key add -
  # cat >/etc/apt/sources.list.d/kubernetes.list <<EOF
  # deb [arch=amd64] http://packagescloudgooglecom.kfd.me/apt/ kubernetes-xenial main
  # EOF
  curl -fsSL https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
  add-apt-repository -u "deb [arch=amd64] https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main"  
  apt-get install -y kubelet=1.10.0-00 kubeadm=1.10.0-00 kubectl=1.10.0-00
fi

if [[ "$OS" == "CentOS" ]];then
  cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
  setenforce 0
  yum install -y kubelet-1.10.0-0 kubeadm-1.10.0-0 kubectl-1.10.0-0 wget
  systemctl enable kubelet && systemctl start kubelet
fi

kubeadm completion bash > /etc/bash_completion.d/k8s

# turn off swap for k8s doesn't support it
log "turn off swap for k8s doesn't support it"
[[ "$OS" == "Ubuntu" ]] && \
  swapoff -a && sed -i "s/exit/\# for k8s\nswapoff -a\nexit/g" /etc/rc.local
[[ "$OS" == "CentOS" ]] && \
  swapoff -a && echo -e "# for k8s\nswapoff -a" >> /etc/rc.local && \
  chmod +x /etc/rc.d/rc.local && \
  systemctl enable rc-local
chmod +x /etc/rc.local

# configure kubelet for downloading pause image
log "configure kubelet for downloading pause image"
[[ "$OS" == "Ubuntu" ]] && \
  sed -i "s/ExecStart=$/Environment=\"KUBELET_EXTRA_ARGS=--pod-infra-container-image=k8s-gcr.mirror.kfd.me\/pause-amd64:3.0\"\nExecStart=/g" \
    /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
[[ "$OS" == "CentOS" ]] && \
  sed -i "s/ExecStart=$/Environment=\"KUBELET_EXTRA_ARGS=--pod-infra-container-image=k8s-gcr.mirror.kfd.me\/pause-amd64:3.0\"\nExecStart=/g; \
    s/cgroup-driver=systemd/cgroup-driver=cgroupfs/g" \
    /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

log "and restart kubelet"
systemctl daemon-reload && systemctl restart kubelet

if [[ "$MASTER" != "Y" ]];then
  log "install this node as a normal node, not master. exit."
  exit 0
fi

# set k8s configuration
cat > kube-admin.conf <<EOF
apiVersion: kubeadm.k8s.io/v1alpha1
kind: MasterConfiguration
api:
  advertiseAddress: "$PRIMARY_IP"
etcd:
  image: "k8s-gcr.mirror.kfd.me/etcd-amd64:3.0.4"
imageRepository: k8s-gcr.mirror.kfd.me
networking:
  podSubnet: "192.168.0.0/16"
kubernetesVersion: 1.10.5
EOF

# start to install
log "we are ready to go; kubeadm init..."
# open ports for centos
[[ "$OS" == "CentOS" ]] && firewall-cmd --add-port=6443/tcp --add-port=10250/tcp
kubeadm init --config=kube-admin.conf

log "copy config files"
mkdir $HOME/.kube/
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

log "init calico network"
CALICO_YAML="https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml"
wget "$CALICO_YAML" -qO- | sed "s/quay.io/quay-io.mirror.kfd.me/g" > calico.yaml
kubectl apply -f calico.yaml

[[ "$SINGLE_MASTER" == "Y" ]] && \
  kubectl taint nodes --all node-role.kubernetes.io/master-
}

install_kubeadma(){
ins_docker(){
PACK='docker-19.03.15.tgz'
DIR='/usr/local/src/'
COLOR='echo -e \E[01;31m'
END='\E[0m'
YUM_PACK='wget lvm2'


if [ -f $DIR$PACK ];then
    $COLOR"检测到源码包存在！开始安装"$END
    install_docker
else
    $COLOR"源码包不存在！开始下载"$END
    yum -y install $YUN_PACK &> /dev/null
    wget -P $DIR https://download.docker.com/linux/static/stable/x86_64/$PACK
if [ $? -eq 0 ];then
    $COLOR"下载成功！！"$END
    install_docker
else
    $COLOR"下载失败，请检查网络配置！！"$END
   exit
fi

fi
}








install_docker(){
PACK='docker-19.03.15.tgz'
DIR='/usr/local/src/'
COLOR='echo -e \E[01;31m'
END='\E[0m'
YUM_PACK='wget lvm2'
USER='docker'
DODIR='/usr/bin/'


    $COLOR"开始安装docker！"$END
    cd $DIR
    tar xzf $PACK
    cp $USER/* $DODIR
    $COLOR"开始准备配置文件"$END
cat > /lib/systemd/system/docker.service <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/bin/dockerd
ExecReload=/bin/kill -s HUP \$MAINPID
LimitNOFILE=infinity
LimitNPROC=infinity
TimeoutStartSec=0
Delegate=yes
KillMode=process
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
EOF



mkdir /etc/docker/ -p &> /dev/null

cat > /etc/docker/daemon.json <<EOF
{
"registry-mirrors" : [    
    "https://registry.docker-cn.com",
    "https://docker.mirrors.ustc.edu.cn",                                                                              
    "http://hub-mirror.c.163.com"
     ]   
}
EOF
   groupadd docker &> /dev/null
   $COLOR"启动docker中"$END
   systemctl daemon-reload
   systemctl enable --now $USER && $COLOR "$USER安装完成" $END || { $COLOR "$USER安装失败" $END false ; exit; }
   exit
}


install_kubeadm(){
USR='docker'
COLOR='echo -e \E[01;31m'
END='\E[0m'
#VERSION='1.20.5-00'
#VER='v1.20.5'
flnnever='v0.14.0'
dashver='v2.3.1'
metver='v1.0.6'
OS=`awk -F= '/^NAME/{print $2}' /etc/os-release | sed "s/\"//g"`

if [[ "$OS" == "Ubuntu" ]];then
  :
elif [[ "$OS" == "CentOS Linux" ]];then
  OS="CentOS"
else
  echo "Unknown OS: \"$OS\", exit"
  exit 2
fi




   $COLOR"开始准备环境"$END
mkdir /etc/docker/certs.d/harbor.deng.net -p & > /dev/null
swapoff -a &> /dev/null
sed -i '/swap/d' /etc/fstab  &> /dev/null
cat >  /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system
cat > /etc/resolv.conf<<EOF
nameserver 223.5.5.5
EOF


if [[ "$OS" == "CentOS" ]];then
  cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
setenforce 0 && sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config  &> /dev/null
systemctl stop firewalld
systemctl disable firewalld.service
fi

if [[ "$OS" == "Ubuntu" ]];then
apt-get install -y selinux-utils ufw  &> /dev/null
setenforce 0 && sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config  &> /dev/null
ufw disable  &> /dev/null
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败，请检查网络配置！！"$END
   exit
fi
echo "deb https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt kubernetes-xenial main" >> /etc/apt/sources.list
apt update &> /dev/null
apt-cache madison kubeadm &> /dev/null
fi

read -p "$(echo -e '\033[1;32m选择节点状态 1.master 2.node：\033[0m')" option
read -p "$(echo -e '\033[1;32m请输入版本默认 1.20.5:\033[0m')" VER

if [ $option = 1 ];then

   $COLOR"开始下载kubeadm"$END


if [[ "$OS" == "CentOS" ]];then
  
 yum install -y kubeadm-$VER-0 kubelet-$VER-0 kubectl-$VER-0 git
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败，请检查网络配置！！"$END
    exit                                                                                                                               
fi

fi


if [[ "$OS" == "Ubuntu" ]];then
apt-get install -y \kubeadm=$VER-00 \kubelet=$VER-00 \kubectl=$VER-00 git
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败，请检查网络配置！！"$END
    exit                                                                                                                               
 fi
fi
   $COLOR"开始下载镜像"$END

docker -v && $COLOR "检测到docker存在！" $END || { $COLOR "docker不存在！！" $END false ; exit; }
   $COLOR"正在检测所需要的镜像"$END
kubeadm config images list --kubernetes-version v$VER
sleep 3
kubeadm config images list --kubernetes-version v$VER | awk -F "[ /]" '{print $2}' | while read a ; do
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/$a
done
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败，请检查网络配置！！"$END
   exit
fi

docker pull quay.io/coreos/flannel:$flnnever
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败，请检查网络配置！！"$END
   exit
fi

docker pull kubernetesui/metrics-scraper:$metver
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败，请检查网络配置！！"$END
   exit
fi
docker pull kubernetesui/dashboard:$dashver
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败，请检查网络配置！！"$END
   exit
fi



elif [ $option = 2 ];then

   $COLOR"开始下载kubeadm"$END

if [[ "$OS" == "CentOS" ]];then
  
 yum install -y kubeadm-$VER-0 kubelet-$VER-0 git
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败，请检查网络配置！！"$END
    exit                                                                                                                               
 fi
fi


if [[ "$OS" == "Ubuntu" ]];then
apt-get install -y \kubeadm=$VER-00 \kubelet=$VER-00 git
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败，请检查网络配置！！"$END
   exit                                                                                                                               
 fi
fi

   $COLOR"安装完成"$END
else
   $COLOR"输入错误"$END
fi



}


init_kubeadm(){
HOSTIP=`ip route get 8.8.8.8 | head -1 | awk '{print $7}'`
APTPACK='git net-tools'
FLANNEL='https://gitee.com/amyoo/flannel.git'
COLOR='echo -e \E[01;31m'
END='\E[0m'
dashver='v2.3.1'
flennver='v0.14.0'
metver='v1.0.6'
cidrip='10.100.0.0/16'
serviceip='10.200.0.0/16'
dashfile='https://gitee.com/amyoo/dashboard1.git'


read -p "$(echo -e '\033[1;32m请输入vip:\033[0m')" VIP
read -p "$(echo -e '\033[1;32m请输入版本默认 v1.20.5:\033[0m')" VESR
read -p "$(echo -e '\033[1;32m请输入仓库地加项目名称例如“harbor.deng.net/k8s” 或使用 registry.cn-hangzhou.aliyuncs.com/google_containers :\033[0m')" IMAGEBASE

   $COLOR"开始安装依赖"$END

   $COLOR"开始下载flannel文件"$END
git clone $FLANNEL                                                                                                                    
if [ $? -eq 0 ];then
   $COLOR"下载成功！！请修改配置文件！！"$END
else
   $COLOR"下载失败，建议手动前往$FLANNEL下载"$END
    sleep 3s
fi

  

   $COLOR"开始执行初始化！！"$END
sleep 3s
kubeadm  init  --apiserver-advertise-address=$HOSTIP  --control-plane-endpoint=$VIP --apiserver-bind-port=6443  --kubernetes-version=$VESR  --pod-network-cidr=$cidrip --service-cidr=$serviceip --service-dns-domain=deng.local --image-repository=$IMAGEBASE

sleep 3s
   $COLOR"开始生成密钥"$END
kubeadm init phase upload-certs --upload-certs
echo "--certificate-key"
mkdir -p /root/.kube
  cp -i /etc/kubernetes/admin.conf /root/.kube/config
  chown root:root /root/.kube/config
#kubectl apply -f /root/flannel/kube-flannel.yml
systemctl enable kubelet

   $COLOR"请保存好你的初始化信息以及生成的密钥！！下载好的文件请手动修改为你的配置！！
         如果需要加入master到集群请在生成的初始化信息后面加上 --certificate-key 和你的密钥
         flannel文件需要修改128行的ip改为你自己环境的ip
         如果初始化使用了harbor需要修改dashbord的镜像名称改为你自己的harbor镜像
         请使用kubectl apply -f 生效你的flannel文件以便配置你的集群状态为read！
         如果初始化失败，请确认你的ip是否输入正确，初始化命令的IP是否跟你的环境一致，镜像是否匹配并且能够下载！"$END


}


push_harbor(){
ETCDVER='3.4.13-0'
DNSVER='1.7.0'
PAUSEVER='3.2'
COLOR='echo -e \E[01;31m'
END='\E[0m'
flnnever='v0.14.0'
dashver='v2.3.1'
metver='v1.0.6'



  $COLOR"请确认你的docker是否可以登陆harbor！"$END
   sleep 3
read -p "$(echo -e '\033[1;32m1:推送镜像 2:拉取镜像 :\033[0m')" option

if [ $option = 1 ];then



read -p "$(echo -e '\033[1;32m请输入harbor地址:\033[0m')" HARBASE
read -p "$(echo -e '\033[1;32m请输入harbor项目名称:\033[0m')" HARBASEVER
read -p "$(echo -e '\033[1;32m请输入镜像版本 默认v1.20.5:\033[0m')" VERS

docker login $HARBASE
if [ $? -eq 0 ];then
    $COLOR"登陆成功！！"$END
else
    $COLOR"登陆失败！！"$END
    exit
fi

  $COLOR"开始改变tag"$END
  sleep 2s
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:$VERS $HARBASE/$HARBASEVER/kube-proxy:$VERS
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:$VERS $HARBASE/$HARBASEVER/kube-apiserver:$VERS
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:$VERS $HARBASE/$HARBASEVER/kube-scheduler:$VERS
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:$VERS $HARBASE/$HARBASEVER/kube-controller-manager:$VERS
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:$ETCDVER $HARBASE/$HARBASEVER/etcd:$ETCDVER
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:$DNSVER $HARBASE/$HARBASEVER/coredns:$DNSVER
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:$PAUSEVER $HARBASE/$HARBASEVER/pause:$PAUSEVER
docker tag quay.io/coreos/flannel:$flnnever $HARBASE/$HARBASEVER/flannel:$flnnever
docker tag kubernetesui/metrics-scraper:$metver $HARBASE/$HARBASEVER/metrics-scraper:$metver
docker tag kubernetesui/dashboard:$dashver $HARBASE/$HARBASEVER/dashboard:$dashver
  $COLOR"开始推送！"$END

docker push $HARBASE/$HARBASEVER/dashboard:$dashver
if [ $? -eq 0 ];then
   $COLOR"推送成功！！"$END
else
   $COLOR"推送失败！！"$END
   exit
fi
docker push $HARBASE/$HARBASEVER/metrics-scraper:$metver
if [ $? -eq 0 ];then
   $COLOR"推送成功！！"$END
else
   $COLOR"推送失败！！"$END
   exit
fi
docker push $HARBASE/$HARBASEVER/kube-apiserver:$VERS
if [ $? -eq 0 ];then
   $COLOR"推送成功！！"$END
else
   $COLOR"推送失败！！"$END
   exit
fi
docker push $HARBASE/$HARBASEVER/kube-scheduler:$VERS
if [ $? -eq 0 ];then
   $COLOR"推送成功！！"$END
else
   $COLOR"推送失败！！"$END
   exit
fi
docker push $HARBASE/$HARBASEVER/kube-controller-manager:$VERS
if [ $? -eq 0 ];then
   $COLOR"推送成功！！"$END
else
   $COLOR"推送失败！！"$END
   exit
fi
docker push $HARBASE/$HARBASEVER/etcd:$ETCDVER
if [ $? -eq 0 ];then
   $COLOR"推送成功！！"$END
else
   $COLOR"推送失败！！"$END
   exit
fi
docker push $HARBASE/$HARBASEVER/coredns:$DNSVER
if [ $? -eq 0 ];then
   $COLOR"推送成功！！"$END
else
   $COLOR"推送失败！！"$END
   exit
fi
docker push $HARBASE/$HARBASEVER/pause:$PAUSEVER
if [ $? -eq 0 ];then
   $COLOR"推送成功！！"$END
else
   $COLOR"推送失败！！"$END
   exit
fi
docker push $HARBASE/$HARBASEVER/kube-proxy:$VERS
if [ $? -eq 0 ];then
   $COLOR"推送成功！！"$END
else
   $COLOR"推送失败！！"$END
   exit
fi
docker push $HARBASE/$HARBASEVER/flannel:$flnnever
if [ $? -eq 0 ];then
   $COLOR"推送成功！！"$END
else
   $COLOR"推送失败！！"$END
   exit
fi

elif [ $option = 2 ];then
read -p "$(echo -e '\033[1;32m请输入harbor地址:\033[0m')" HARBASE
read -p "$(echo -e '\033[1;32m请输入harbor项目名称:\033[0m')" HARBASEVER
read -p "$(echo -e '\033[1;32m请输入镜像版本 默认v1.20.0:\033[0m')" VERS

docker login $HARBASE
 
   $COLOR"开始下载！"$END


docker pull $HARBASE/$HARBASEVER/flannel:$flnnever
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败！！"$END
   exit
fi
docker pull $HARBASE/$HARBASEVER/metrics-scraper:$metver
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败！！"$END
   exit
fi
docker pull $HARBASE/$HARBASEVER/dashboard:$dashver
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败！！"$END
   exit
fi
docker pull $HARBASE/$HARBASEVER/kube-apiserver:$VERS
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败！！"$END
   exit
fi
docker pull $HARBASE/$HARBASEVER/kube-scheduler:$VERS
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败！！"$END
   exit
fi
docker pull $HARBASE/$HARBASEVER/kube-controller-manager:$VERS
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败！！"$END
   exit
fi
docker pull $HARBASE/$HARBASEVER/etcd:$ETCDVER
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败！！"$END
   exit
fi
docker pull $HARBASE/$HARBASEVER/coredns:$DNSVER
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败！！"$END
   exit
fi
docker pull $HARBASE/$HARBASEVER/pause:$PAUSEVER
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败！！"$END
   exit
fi
docker pull $HARBASE/$HARBASEVER/kube-proxy:$VERS
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败！！"$END
   exit
fi

else
  $COLOR"输入错误！！"$END
fi
 

}





while :;do
echo -e "\033[1;36m 
  请确保机器配置不少于2核2G，并且主机名不能重复，如果使用harbor请配置好docker和harbor的连接
  下载好的flannel文件请修改网段，请确保你的apiserver网络正常通信\033[0m"
echo -e "\033[1;36m  1.安装kubeadm  \033[0m"
echo -e "\033[1;36m  2.初始化节点          \033[0m"
echo -e "\033[1;36m  3.harbor设置          \033[0m"
echo -e "\033[1;36m  4.安装docker          \033[0m"
echo -e "\033[1;36m  5.退出          \033[0m"
read -p "$(echo -e '\033[1;32m请输入你的选项:\033[0m')" option
case $option in 
1)
  install_kubeadm
  ;;
2)
  init_kubeadm
  ;;
3)
  push_harbor
  ;;
4)
  ins_docker
  ;;
5)
  break
  ;;
*)
  echo -e "\033[1;36m输入错误！\033[0m"
esac
done
 


}






























































































set_haporxy(){

yum -y install socat &> /dev/null
up_rs() {
SOCK=/var/lib/haproxy/haproxy.sock
read -p "$(echo -e '\033[1;32mWhich server group?:\033[0m')" SERVER
read -p "$(echo -e '\033[1;32mWhich server needs to be turned on?:\033[0m')" RS

echo "set weight $SERVER/$RS 1" | socat stdio $SOCK > haproxy.log
LINE=`egrep '[[:alnum:]]+' haproxy.log`
if [[ $LINE =~ [[:alnum:]]+  ]];then
   echo -e "\033[31mFail!check your profile！！\033[0m"
else
   echo -e "\033[35mOK!!!\033[0m"
fi
}

shutdown_rs(){
SOCK=/var/lib/haproxy/haproxy.sock
read -p "$(echo -e '\033[1;32mWhich server group?:\033[0m')" SERVER

read -p "$(echo -e '\033[1;32mWhich server needs to be shutdown?:\033[0m')" RS
echo "set weight $SERVER/$RS 0" | socat stdio $SOCK > haproxy.log
LINE=`egrep '[[:alnum:]]+' haproxy.log`
if [[ $LINE =~ [[:alnum:]]+  ]];then
   echo -e "\033[31mFail!check your profile！！\033[0m"
else
   echo -e "\033[35mOK!!!\033[0m"
fi
}

set_rs(){
SOCK=/var/lib/haproxy/haproxy.sock
read -p "$(echo -e '\033[1;32mWhich server group?:\033[0m')" SERVER
read -p "$(echo -e '\033[1;32mWhich server needs to be set up?:\033[0m')" RS
read -p "$(echo -e '\033[1;32mPlease enter weight:\033[0m')" WG

echo "set weight $SERVER/$RS  $WG" | socat stdio $SOCK > haproxy.log
LINE=`egrep '[[:alnum:]]+' haproxy.log`
if [[ $LINE =~ [[:alnum:]]+  ]];then
   echo -e "\033[31mFail!check your profile！！\033[0m"
else
   echo -e "\033[35mOK!!!\033[0m"
fi
}


while :;do
echo -e "\033[1;36m  1.turned on realserver      \033[0m"
echo -e "\033[1;36m  2.shutdown realserver      \033[0m"
echo -e "\033[1;36m  3.set weight        \033[0m"
echo -e "\033[1;36m  4.restart haproxy        \033[0m"
echo -e "\033[1;36m  5.exit        \033[0m"
read -p "$(echo -e '\033[1;32mInput options:\033[0m')" options
case $options in

1)
   up_rs
   ;;
2)
   
   shutdown_rs
   ;;
3)
   set_rs
   ;;
4)
   systemctl restart haproxy
   echo -e "\033[35mOK!!!\033[0m"
   ;;
5)
   break
   ;;
*)
   echo -e "\033[31mInput error！！！\033[0m"
   ;;
esac
done

}






















set_lvs_rs(){
#vip=10.0.0.100
mask='255.255.255.255'
dev=lo:1
rpm -q httpd &> /dev/null || yum -y install httpd &>/dev/null
#service httpd start &> /dev/null && echo "The httpd Server is Ready!"

#echo "`hostname -I`" > /var/www/html/index.html

read -p "$(echo -e '\033[1;32mstart还是stop rs？:\033[0m')" option

read -p "$(echo -e '\033[1;32m输入需要指定的vip:\033[0m')" vip



case $option in
start)
    
    echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
    echo 1 > /proc/sys/net/ipv4/conf/lo/arp_ignore
    echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce
    echo 2 > /proc/sys/net/ipv4/conf/lo/arp_announce
    ifconfig $dev $vip netmask $mask #broadcast $vip up
    #route add -host $vip dev $dev
    echo "The RS Server is Ready!"
    ;;
stop)
    ifconfig $dev down
    echo 0 > /proc/sys/net/ipv4/conf/all/arp_ignore
    echo 0 > /proc/sys/net/ipv4/conf/lo/arp_ignore
    echo 0 > /proc/sys/net/ipv4/conf/all/arp_announce
    echo 0 > /proc/sys/net/ipv4/conf/lo/arp_announce
    echo "The RS Server is Canceled!"
    ;;
*) 
    echo "Usage: $(basename $0) start|stop"
    exit 1
    ;;
esac


}


set_lvs_vs(){
#vip='10.0.0.100'
iface='lo:1'
mask='255.255.255.255'
port='80'
#rs1='192.168.8.101'
#rs2='192.168.8.102'
scheduler='wrr'
type='-g'
rpm -q ipvsadm &> /dev/null || yum -y install ipvsadm &> /dev/null

read -p "$(echo -e '\033[1;32mstart还是stop lvs？:\033[0m')" option

case $option in
start)
    read -p "$(echo -e '\033[1;32m输入需要指定的vip:\033[0m')" vip
    read -p "$(echo -e '\033[1;32m请输入后端rs:\033[0m')" rs1
    read -p "$(echo -e '\033[1;32m请输入后端rs:\033[0m')" rs2

    ifconfig $iface $vip netmask $mask #broadcast $vip up
    iptables -F
     
    ipvsadm -A -t ${vip}:${port} -s $scheduler
    ipvsadm -a -t ${vip}:${port} -r ${rs1} $type -w 1
    ipvsadm -a -t ${vip}:${port} -r ${rs2} $type -w 1
    echo "The VS Server is Ready!"
    ;;
stop)
    read -p "$(echo -e '\033[1;32m输入需要指定的vip:\033[0m')" vip
    ipvsadm -C
    ifconfig $iface down
    echo "The VS Server is Canceled!"
    ;;
*)
 i   echo "Usage: $(basename $0) start|stop"
    exit 1
    ;;
esac

}



install_pxe(){
PXEinstall (){
realeaseNo=`cat /etc/redhat-release |sed -rn 's/.*([[:digit:]]+)\..*\..*/\1/p'`
setenforce 0
systemctl stop firewalld
rpm -q net-tools ||yum -y install net-tools
ifconfig |grep eth0
if [ "$?" -ne "0" ];then
	echo "请将网卡更名为eth0;才能继续运行本脚本；更改过程中会强制重启；您是否还要继续执行？"
	read -p " 请按y继续YUN行: " ipsure
	[ "${ipsure}" ] == "y" && sed -ir '/GRUB_CMDLINE_LINUX/s/"$/ net.ifnames=0"/p' /etc/default/grub && grub2-mkconfig -o /etc/grub2.cfg &>/dev/null
	read -p "请输入eth0的IP: " ip
	read -p "请输入要设置的子网掩码（prefix）如 24: " prefix
	read -p "请输入要设置的网关： " gateway
	cat >/etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
DEVICE="eth0"
BOOTPROTO="static"
ONBOOT="yes"
TYPE="Ethernet"
IPADDR=$ip
PREFIX=$prefix
GATEWAY=$gateway
DNS1=114.114.114.114
EOF
	echo "请重启系统；然后重新执行本脚本"
	echo "重启后如果无法联网 请执行service network restart 或者 nmcli con reload; nmcli con up eth0"
	reboot
fi
ipeth0=`ifconfig eth0|sed -rn '/inet\>/s/[^0-9]+([0-9.]+).*/\1/p'`
neteth0=`ifconfig eth0|sed -rn '/inet\>/s/[^0-9]+([0-9.]+).*/\1/p'|cut -d. -f1-3`
route=`ip route|grep default|grep eth0|sed -rn 's/[^0-9]+([0-9.]+).*/\1/p'`
route6=`ip route|grep default|sed -rn 's/[^0-9]+([0-9.]+).*/\1/p'`
srinfo6=`lsblk|awk '/sr/{print $1}'`
srinfo=`lsblk|egrep -o 'sr[^ ]*'`
for scan in /sys/class/scsi_host/host*/scan;do echo "- - -" >$scan;done
if [ "$realeaseNo" -eq "8" ];then            
	dnf -y install dhcp-server tftp-server httpd syslinux-nonlinux 
	systemctl enable --now httpd tftp dhcpd
fi 
if [ "$realeaseNo" -eq "7" ];then            
	yum -y install httpd tftp-server dhcp syslinux 
	systemctl enable --now httpd tftp dhcpd
fi 
if [ "$realeaseNo" -eq "6" ];then            
	yum -y install httpd tftp-server dhcp syslinux 
	service httpd start;service dhcpd restart
	sed -i '/disable/s/yes/no/' /etc/xinetd.d/tftp
	service xinetd restart
fi 
	
	mkdir /var/www/html/centos/{6,7,8}/isos/x86_64/ -pv &>/dev/null

if [ "$realeaseNo" -eq "7" -o "$realeaseNo" -eq "8" ];then
	srinfo6=${srinfo}
fi
	for sr in ${srinfo6};do
		mkdir /mnt/${sr} -p &>/dev/null
		mount /dev/${sr} /mnt/${sr}	
		if [ -d /mnt/${sr}/AppStream ];then
			mount /dev/${sr} /var/www/html/centos/8/isos/x86_64/ &>/dev/null
			mkdir  /var/www/html/ksdir -p &>/dev/null
			mkdir /var/lib/tftpboot/8 &> /dev/null
			\cp -a /mnt/${sr}/isolinux/{vmlinuz,initrd.img} /var/lib/tftpboot/8/

cat >/var/www/html/ksdir/ks8.cfg <<EOF
#version=RHEL8
ignoredisk --only-use=sda
zerombr
text
reboot
# Partition clearing information
clearpart --all --initlabel
selinux --disabled
firewall --disabled

# Use graphical install
#repo --name="Appstream"  --baseurl=http://${ipeth0}/centos/8/isos/x86_64/AppStream
url --url=http://${ipeth0}/centos/8/isos/x86_64/
#repo --name="AppStream" --baseurl=file:///run/install/repo/AppStream
# Use CDROM installation media
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=ens160 --ipv6=auto --activate
network  --hostname=centos8.magedu.com
# Root password
# Run the Setup Agent on first boot
rootpw --iscrypted \$1\$jb2QI2x8\$wWAOeOxXerdfYXyVwV0890
firstboot --enable
# Do not configure the X Window System
skipx
# System services
services --disabled="chronyd"
# System timezone
timezone Asia/Shanghai --isUtc --nontp
user --name=wang --password=\$6$oU$fb/02CWfLb5l8f\$sgEZeR7c7DpqfpmFDH6huSmDbW1XQNR4qKl2EPns.gOXqlnAIgv9pTogtFVaDtEpMOC.SWXKYqxfVtd9MCwxb1 --iscrypted --gecos="wang"
# Disk partitioning information
part / --fstype="xfs" --ondisk=sda --size=10000
part /data --fstype="xfs" --ondisk=sda --size=3200
part swap --fstype="swap" --ondisk=sda --size=2048
part /boot --fstype="ext4" --ondisk=sda --size=700

%packages
@^minimal-environment
kexec-tools

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
EOF
		fi
		if [ -e /mnt/${sr}/RPM-GPG-KEY-CentOS-6 ];then
			mount /dev/${sr} /var/www/html/centos/6/isos/x86_64/ &>/dev/null
			mkdir  /var/www/html/ksdir -p &>/dev/null
			mkdir /var/lib/tftpboot/6
			\cp -a /mnt/${sr}/isolinux/{vmlinuz,initrd.img} /var/lib/tftpboot/6/ &>/dev/null
cat >/var/www/html/ksdir/ks6.cfg <<EOF

#ckstart file automatically generated by anaconda.

#version=DEVEL
install
url --url=http://${ipeth0}/centos/6/isos/x86_64/
lang en_US.UTF-8
keyboard us
network --onboot yes --device eth0 --bootproto dhcp --noipv6
rootpw  --iscrypted \$1\$jb2QI2x8\$wWAOeOxXerdfYXyVwV0890
firewall --disabled
authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone Asia/Shanghai
bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"
# The following is the partition information you requested
# Note that any partitions you deleted are not expressed
# here so unless you clea:r all partitions first, this is
# not guaranteed to work
clearpart --all
zerombr
reboot
text
part /boot --fstype=ext4 --size=400
part / --fstype=ext4 --size=10000
part /data --fstype=ext4 --size=3000

part swap --size=2048

%packages
@core
autofs
%end

%post
useradd wang
echo magedu | passwd --stdin wang 
%end
EOF
		fi
		if [ -e /mnt/${sr}/RPM-GPG-KEY-CentOS-7 ];then
        	mount /dev/${sr} /var/www/html/centos/7/isos/x86_64/ &>/dev/null
			mkdir  /var/www/html/ksdir -p &>/dev/null
			mkdir /var/lib/tftpboot/7 &>/dev/null
			\cp -a /mnt/${sr}/isolinux/{vmlinuz,initrd.img} /var/lib/tftpboot/7/
cat >/var/www/html/ksdir/ks7.cfg <<EOF
#platform=x86, AMD64, or Intel EM64T
#version=DEVEL
# Install OS instead of upgrade
install
# X Window System configuration information
xconfig  --startxonboot
# Keyboard layouts
# old format: keyboard us
# new format:
keyboard --vckeymap=us --xlayouts='us'
# Root password
rootpw --iscrypted \$1\$jb2QI2x8\$wWAOeOxXerdfYXyVwV0890
# Use network installation
url --url="http://${ipeth0}/centos/7/isos/x86_64"
# System language
lang en_US
# System authorization information
auth  --useshadow  --passalgo=sha512
# Use text mode install
text
# Run the Setup Agent on first boot
firstboot --enable
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx

# System services
services --disabled="chronyd"
ignoredisk --only-use=sda
# Firewall configuration
firewall --disabled
# Network information
network  --bootproto=dhcp --device=ens33
# Reboot after installation
reboot
# System timezone
timezone Asia/Shanghai --nontp
# System bootloader configuration
bootloader --append="crashkernel=auto" --location=mbr --boot-drive=sda
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part swap --fstype="swap" --ondisk=sda --size=3072
part / --fstype="xfs" --ondisk=sda --size=11200
part /boot --fstype="xfs" --ondisk=sda --size=724
part /data --fstype="xfs" --ondisk=sda --size=3720

%post
useradd wang
%end

%packages
@core
%end

EOF
        fi
	done
if [ "$realeaseNo" -eq "7" -o "$realeaseNo" -eq "8" ];then
cat >/etc/dhcp/dhcpd.conf <<EOF
option domain-name "example.org";
option domain-name-servers 180.76.76.76,114.114.114.114;
default-lease-time 600;
max-lease-time 7200;
log-facility local7;
subnet ${neteth0}.0 netmask 255.255.255.0 {
  range ${neteth0}.100 ${neteth0}.200;
  option routers ${route};
  next-server ${ipeth0};
  filename "pxelinux.0";
}
EOF
fi
if [ "$realeaseNo" -eq "6" ];then
cat >/etc/dhcp/dhcpd.conf <<EOF
option domain-name "example.org";
option domain-name-servers 180.76.76.76,114.114.114.114;
default-lease-time 600;
max-lease-time 7200;
log-facility local7;
subnet ${neteth0}.0 netmask 255.255.255.0 {
  range ${neteth0}.100 ${neteth0}.200;
  option routers ${route6};
  next-server ${ipeth0};
  filename "pxelinux.0";
}
EOF
fi
if [ "$realeaseNo" -eq "7" -o "$realeaseNo" -eq "8" ];then            
	systemctl start dhcpd 
fi 
if [ "$realeaseNo" -eq "6" ];then            
	service dhcpd start 
fi 


\cp /usr/share/syslinux/{pxelinux.0,menu.c32} /var/lib/tftpboot/
\cp /mnt/sr0/isolinux/{ldlinux.c32,libcom32.c32,libutil.c32,vmlinuz,initrd.img} /var/lib/tftpboot/
mkdir /var/lib/tftpboot/pxelinux.cfg/ -p
cat >/var/lib/tftpboot/pxelinux.cfg/default <<EOF
default menu.c32
timeout 600

menu title CentOS Linux 

label linux8
  menu label Auto Install CentOS Linux ^8.0 Mini
  kernel 8/vmlinuz
  append initrd=8/initrd.img ks=http://${ipeth0}/ksdir/ks8.cfg

label linux7
  menu label Auto Install CentOS Linux ^7 Mini
  kernel 7/vmlinuz
  append initrd=7/initrd.img ks=http://${ipeth0}/ksdir/ks7.cfg

label linux6
  menu label Auto Install CentOS Linux ^6 Mini
  kernel 6/vmlinuz
  append initrd=6/initrd.img ks=http://${ipeth0}/ksdir/ks6.cfg

label local
  menu default 
  menu label Boot from ^local drive
  localboot 0xffff
EOF
}

echo "**********************************************************************************************"
echo "***********************************请确保在nat网卡模式下运行***********************************"
echo "**********************************************************************************************"
echo "1..这是一个pxe 自动化安装的脚本；兼容centos6、7、8系统，需要将网卡同一设置为eth0;会自动更改网卡eth0"
echo "2..需要你至少挂载一个光盘；支持cenos6、7、8的光盘"
echo "3..新建虚拟机建议20G 2G内存以上 不然容易报错；"
echo "4..如果运行中有错误请与我联系！谢谢"
echo "5..如果网卡更改后重启了，务必确认是否能ping百度或查看是否有默认网关"
echo "6..如果执行本脚本后发现没有挂载光盘，请执行 yum remove dhcp|dhcp-server httpd tftp-server 清理环境"
echo "7..运行脚本需要在当前shell运行，不要开启子shell，否则无法使用自动更改网卡名功能"
echo "**************************************************************************************"
echo "**************************************************************************************"
echo "虚拟机默认密码为123"
j=20
for i in `seq 20`;do
        echo "${j}s后自动开始运行"
        let j--
        sleep 1
done


}


backup_mysql(){
   #!/bin/bash
#全备方式，一般在从机上执行，适用于小中型mysql数据库
#删除15天以前备份


source /etc/profile        #加载系统环境变量
source ~/.bash_profile    #加载用户环境变量
set -o nounset             #引用未初始化变量时退出
#set -o errexit            #执行shell命令遇到错误时退出

user="root"
password="123456"
host="localhost"
port="3306"
#需备份的数据库，数组
db=("test")
#备份时加锁方式，
#MyISAM为锁表--lock-all-tables，
#InnoDB为锁行--single-transaction
lock="--single-transaction"
mysql_path="/usr/local/mysql"
backup_path="${mysql_path}/backup"
date=$(date +%Y-%m-%d_%H-%M-%S)
day=15
backup_log="${mysql_path}/backup.log"

#建立备份目录
if [ ! -e $backup_path ];then
    mkdir -p $backup_path
fi

#删除以前备份
find $backup_path -type f -mtime +$day -exec rm -rf {} \; > /dev/null 2>&1

echo "开始备份数据库：${db[*]}"

#备份并压缩
backup_sql(){
    dbname=$1
    backup_name="${dbname}_${date}.sql"
    #-R备份存储过程，函数，触发器
    mysqldump -h $host -P $port -u $user -p$password $lock --default-character-set=utf8 --flush-logs -R $dbname > $backup_path/$backup_name    
    if [[ $? == 0 ]];then
        cd $backup_path
        tar zcpvf $backup_name.tar.gz $backup_name
        size=$(du $backup_name.tar.gz -sh | awk '{print $1}')
        rm -rf $backup_name
        echo "$date 备份 $dbname($size) 成功 "
    else
        cd $backup_path
        rm -rf $backup_name
        echo "$date 备份 $dbname 失败 "
    fi
}

#循环备份
length=${#db[@]}
for (( i = 0; i < $length; i++ )); do
        backup_sql ${db[$i]} >> $backup_log 2>&1
done

echo "备份结束,结果查看 $backup_log"
du $backup_path/*$date* -sh | awk '{print "文件:" $2 ",大小:" $1}'
}



install_kvm(){
ISODIR='/data/iso/'
COLOR='echo -e \E[01;31m'
END='\E[0m'
YUM_PACK='qemu-kvm qemu-kvm-tools libvirt libvirtclient virt-manager virt-install'
NETDIR='/etc/sysconfig/network-scripts'
DISKDIR='/var/lib/libvirt/images/centos7-bridge.qcow2'
PACK='CentOS-7-x86_64-Minimal-2009.iso'
#NET=`ip add show eth0 |awk -F '[ /]+' 'NR==3 {print $3}'`
#M='1024'
#CPU='1'
#N='centos7'
#DISK='10G'

$COLOR "请确认镜像是否在$ISODIR下并且已经开启虚拟化.镜像默认为$PACK如果你没有该镜像,将会自动下载"$END
$COLOR "如果网段不同请自行修改配置！"$END
sleep 3

num=$(rpm -qa|grep -c libvirt)
if [ $num -gt 0 ];then
   $COLOR "kvm已经全部安装！"$END
else

$COLOR"开始安装kvm！"$END
$COLOR"开始下载kvm依赖！"$END
yum -y install $YUM_PACK &> /dev/null
fi
mkdir /data/iso/ -p &> /dev/null
$COLOR"开始启动kvm！"$END
systemctl start libvirtd  && $COLOR "kvm 安装完成" $END || { $COLOR "kvm 安装失败" $END false ; exit; }
$COLOR"开始创建虚拟机！"$END
mkdir /data/netbackup/ -p &> /dev/null
mv $NETDIR/* /data/netbackup/ &> /dev/null
cd $NETDIR
cat > $NETDIR/ifcfg-eth0 <<EOF
TYPE=Ethernet
BOOTPROTO=static
NAME=eth0
DEVICE=eth0
ONBOOT=yes
BRIDGE=br0
EOF



cat > $NETDIR/ifcfg-br0 <<EOF
TYPE=Bridge
DEVICE=br0
NAME=br0
BOOTPROTO=static
ONBOOT=yes
IPADDR=
PREFIX=24
GATEWAY=192.168.3.1                                                                          
DNS1=223.5.5.5
DNS2=223.6.6.6
EOF


read -p "$(echo -e '\033[1;32m请输入ip:\033[0m')" NET
read -p "$(echo -e '\033[1;32m请输入网关:\033[0m')" GA
sed -i '/^IPADDR/c IPADDR='''$NET'''' $NETDIR/ifcfg-br0
sed -i '/^GATEWAY/c GATEWAY='''$GA'''' $NETDIR/ifcfg-br0

nmcli c reload &> /dev/null
nmcli c up eth0 &> /dev/null
nmcli c up br0 &> /dev/null

$COLOR"开始下载虚拟机镜像！"$END
if [ -f $ISODIR$PACK ];then
   $COLOR"检测到镜像存在继续执行！"$END
else
   $COLOR"未检测到镜像，开始下载！"$END
   wget -P $ISODIR https://mirrors.tuna.tsinghua.edu.cn/centos/7/isos/x86_64/$PACK
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败，请检查网络配置！！"$END
   exit
fi
fi


   $COLOR"开始创建虚拟机磁盘！"$END
if [ -f $DISKDIR ];then
   $COLOR"磁盘已经存在！"$END
else
read -p "$(echo -e '\033[1;32m请输入虚拟机的磁盘大小:\033[0m')" DISK
qemu-img create -f qcow2 $DISKDIR $DISK && $COLOR "创建完成" $END || { $COLOR "创建硬盘文件失败" $END false ; exit; }
fi

read -p "$(echo -e '\033[1;32m请输入内存:\033[0m')" M
read -p "$(echo -e '\033[1;32m请输入cpu:\033[0m')" CPU
read -p "$(echo -e '\033[1;32m请输入名称:\033[0m')" N

virt-install --virt-type kvm --name $N --memory $M --vcpus $CPU --cdrom=$ISODIR$PACK --disk path=$DISKDIR --network bridge=br0 --graphics vnc,listen=0.0.0.0 --noautoconsole
if [ $? -eq 0 ];then
   $COLOR"完成！！请使用远程工具连接虚拟机！"
   exit
else
   $COLOR"安装失败，请检查环境！！！！"
   exit
fi


}


set_cobbler(){
   #!/bin/bash
#配置yum源
curl -o /etc/yum.repos.d/CentOS7-Base-163.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo
sed -i 's/\$releasever/7/g' /etc/yum.repos.d/CentOS7-Base-163.repo
sed -i 's/^enabled=.*/enabled=1/g' /etc/yum.repos.d/CentOS7-Base-163.repo
yum -y install epel-release

#安装cobbler以及相关软件
yum install -y httpd dhcp tftp python-ctypes cobbler xinetd cobbler-web pykickstart net-tools

#启动服务并设置开机自启
systemctl start httpd
systemctl start cobblerd
systemctl enable httpd
systemctl enable cobblerd

#关闭防火墙
firewall()
{
systemctl stop firewalld
systemctl disable firewalld
systemctl mask firewalld
setenforce 0
}

#获取本机IP地址
ip=`ifconfig eth0 | grep "netmask" | awk '{print $2}'`

#修改server和tftp的IP地址为本机的IP地址
configure_cobbler()
{
if [$? -eq 0];then
    sed -i 's/^server: 127.0.0.1/server: $ip/' /etc/cobbler/settings
    sed -i 's/^next_server: 127.0.0.1/next_server: $ip/' /etc/cobbler/settings
    sed -i '/disable/s/yes/no/g' /etc/xinetd.d/tftp
fi
}

#下载缺失文件
cobbler get-loaders

#启动rsync并设置开机自启
systemctl start rsyncd
systemctl enable rsyncd

#生成加密的密码并添加到配置文件
configure_passwd()
{
if [$? -eq 0];then
passwd=`openssl passwd -1 -salt "$RANDOM" 'yqm123!'`
sed -i "101idefault_password_crypted: \"$pass\"" /etc/cobbler/settings
sed -i '102d' /etc/cobbler/settings
fi
}

#重启cobbler
systemctl restart cobblerd

#获取本机网段
net=`ifconfig eth0 | grep "netmask" | awk '{print $2} | cut -c 1-10'`

#配置cobbler dhcp
configure_dhcp()
{
if [$? -eq 0];then
sed -i '/^manage_dhcp/s/0/1/g' /etc/cobbler/settings
sed -n '/^manage_dhcp/p' /etc/cobbler/settings
sed -i "21s/192.168.1/$net/g" /etc/cobbler/dhcp.template
sed -i "22s/192.168.1.5/$net.1/g" /etc/cobbler/dhcp.template
sed -i "23s/192.168.1.1/$net.2/g" /etc/cobbler/dhcp.template
sed -i "25s/192.168.1.100 192.168.1.254/$net.100 $net.200/" /etc/cobbler/dhcp.template
fi
}

#重启服务并同步配置
systemctl restart cobblerd
cobbler sync
main()
{
firewall&&configure_cobbler&&configure_passwd&&configure_dhcp
}

#导入redhat7镜像
mount /dev/cdrom /mnt
cobbler import --path=/mnt --name=rhel-7 --arch=x86_64

#提取Root密码
root=`awk 'NR==23{print}' anaconda-ks.cfg `

#创建kickstarts自动安装脚本
cat > /var/lib/cobbler/kickstarts/rhel-7-x86_64.ks <<'EOF'
auth --enableshadow --passalgo=sha512
bootloader --location=mbr
clearpart --all --initlabel
part /boot --asprimary --fstype="ext4" --size=500
part swap --fstype="swap" --size=4096
keyboard us
lang en_US
url --url=http://$ip/cobbler/ks_mirror/rhel-7-x86_64
$yum_repo_stanza
reboot

$root

selinux --disabled
skipx
timezone Asia/Shanghai --isUtc --nontp
install
zerombr

%packages
@^minimal
@core
kexec-tools

%end
%addon com_redhat_kdump --enable --reserve-mb='auto' 
%end
%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
EOF

#修改profile
 cobbler profile edit --name rhel-7-x86_64 --kickstart=/var/lib/cobbler/kickstarts/rhel-7-x86_64.ks

#配置网卡名称为传统网卡名称eth0
 cobbler profile edit --name rhel-7-x86_64 --kopts='net.ifnames=0 biosdevname=0'
#同步cobbler
cobbler sync

#重启服务
systemctl restart xinetd
systemctl restart cobblerd
systemctl restart httpd
}


set_rsync(){
   install_sersync(){
test -e sersync2.5.4_64bit_binary_stable_final.tar.gz
    [ $? -ne 0 ] && { echo '请将sersync源码放置于当前目录';exit 3; }
    tar xf sersync2.5.4_64bit_binary_stable_final.tar.gz
    mv GNU-Linux-x86/ /usr/local/sersync
    ln -s /usr/local/sersync/* /usr/local/bin
    echo 'PATH=/usr/local/sersync:$PATH' > /etc/profile.d/sersync.sh
    source /etc/profile.d/sersync.sh
}

#备份服务器
rsync_dst(){
    [ $# -ne 2 ] && { echo "输入错误，退出";exit 2; }
    
    local BACKUP_DIR=$1
    local RSYNCD_MODULE=$2
    local RSYNC_USER=rsyncuser
    local RSYNC_PASS=123456

    #安装rsync
    yum -y install rsync rsync-daemon
    #创建密钥文件
    echo "$RSYNC_USER:$RSYNC_PASS" >> /etc/rsync.pas
    chmod 600 /etc/rsync.pas
    cat > /etc/rsyncd.conf <<EOF
# /etc/rsyncd: configuration file for rsync daemon mode

# See rsyncd.conf man page for more options.

uid = root
gid = root
max connections = 0
ignore errors
exclude = lost+found/
reverse lookup = no
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsyncd.lock
log file = /var/log/rsyncd.log


[$RSYNCD_MODULE]
read only = no
path = $BACKUP_DIR
auth users = $RSYNC_USER
secrets file = /etc/rsync.pas
EOF
    mkdir "$BACKUP_DIR" -p $> /dev/null
    systemctl enable --now rsyncd
}

#同步服务器
rsync_src(){
    #检查内核支持inotify
    grep -qi 'CONFIG_INOTIFY_USER=y' `find /boot -name config*`
    [ $? -ne 0 ] && { echo '内核不支持inotify';exit 2; }
    
    #优化内核参数
    #事件队列最大长度
    echo fs.inotify.max_queued_events = 65536 >> /etc/sysctl.conf
    #可以监视的文件的总数量
    echo fs.inotify.max_user_watches = 100000 >> /etc/sysctl.conf
    sysctl -p

    #安装sersync
    [ -d /usr/local/sersync ] || install_sersync
    
    #rsync客户端
    yum -y install --disablerepo=EPEL rsync
    
    #交互赋值
    [ $# -ne 3 ] && { echo "输入错误，退出";exit 2; }
    
    local WATCH_DIR=$1
    local RSYNCD_IP=$2
    local RSYNCD_MODULE=$3
    local RSYNC_USER=rsyncuser
    local RSYNC_PASS=123456
    
    
    #创建密钥
    echo "$RSYNC_PASS" > /etc/rsync_$RSYNC_USER.pas
    chmod 600 /etc/rsync_$RSYNC_USER.pas
    #创建配置文件
    cat > /usr/local/sersync/`basename $WATCH_DIR`.xml <<EOF
<?xml version="1.0" encoding="ISO-8859-1"?>
<head version="2.5">
    <host hostip="localhost" port="8008"></host>
    <debug start="false"/>
    <!--文件过滤-->
    <fileSystem xfs="false"/>
    <filter start="false">
    <exclude expression="(.*)\.svn"></exclude>
    <exclude expression="(.*)\.gz"></exclude>
    <exclude expression="^info/*"></exclude>
    <exclude expression="^static/*"></exclude>
    </filter>
    <inotify>
    <delete start="true"/>
    <createFolder start="true"/>
    <createFile start="false"/>
    <closeWrite start="true"/>
    <moveFrom start="true"/>
    <moveTo start="true"/>
    <!-- 监控文件属性变化-->
    <attrib start="true"/>
    <modify start="false"/>
    </inotify>

    <sersync>
    <!--监控同步的源目录或文件-->
    <localpath watch="$WATCH_DIR">
        <!--指定备份服务器地址和rsync daemon的module名-->
        <remote ip="$RSYNCD_IP" name="$RSYNCD_MODULE"/>
        <!--<remote ip="192.168.8.39" name="tongbu"/>-->
        <!--<remote ip="192.168.8.40" name="tongbu"/>-->
    </localpath>
    <rsync>
        <commonParams params="-artuz"/>
        <!--修改为ture,指定备份服务器的rsync配置的用户和密码文件-->
        <auth start="true" users="$RSYNC_USER" passwordfile="/etc/rsync_$RSYNC_USER.pas"/>
        <userDefinedPort start="false" port="874"/><!-- port=874 -->
        <timeout start="false" time="100"/><!-- timeout=100 -->
        <ssh start="false"/>
    </rsync>
    <failLog path="/tmp/rsync_fail_log.sh" timeToExecute="60"/><!--default every 60mins execute once-->
    <crontab start="false" schedule="600"><!--600mins-->
        <crontabfilter start="false">
        <exclude expression="*.php"></exclude>
        <exclude expression="info/*"></exclude>
        </crontabfilter>
    </crontab>
    <plugin start="false" name="command"/>
    </sersync>
</head>
EOF


    mkdir "$WATCH_DIR" -p &> /dev/null
    #后台启动服务并指定配置文件
    sersync2 -dro /usr/local/sersync/`basename $WATCH_DIR`.xml
}


PS3="请选择(1-3):"
MENU="
配置源服务器
配置备份服务器
退出
"
select menu in $MENU;do
case $REPLY in
1)
    read -p "请依次输入'同步目录 备份服务器IP 备份模块名':"  SRC
    rsync_src $SRC
    ;;
2)
    read -p "请依次输入'归档目录 备份模块名':" DST 
    rsync_dst $DST
    ;;
3)
    break
    ;;
*)
    echo "输入错误"
    ;;
esac
done

}


docker_lnmp(){
YUM_PACK='git docker-compose'
COLOR='echo -e \E[01;31m'
END='\E[0m'
DIR='/root/Docker-LNMP'

$COLOR"安装lnmp之前先安装docker！请保持网络畅通！！"$END
sleep 5
if [ -f $DIR ];then


$COLOR"开始安装lnmp"$END
cd $DIR

docker-compose -f docker-compose-fast.yml up -d 
  

else
 
$COLOR"开始下载lnmp依赖！"$END
yum -y install $YUM_PACK &> /dev/null
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败，请检查网络配置！！"$END
      exit
fi

$COLOR"开始下载配置文件"$END
cd /root/
git clone https://github.com/duiying/Docker-LNMP.git
if [ $? -eq 0 ];then
   $COLOR"下载成功！！"$END
else
   $COLOR"下载失败，请检查网络配置！！"$END
      exit
fi
$COLOR"开始安装lnmp"$END
cd $DIR
docker-compose -f docker-compose-fast.yml up -d 
fi

}



set_openvpn(){
# Detect Debian users running the script with "sh" instead of bash
if readlink /proc/$$/exe | grep -q "dash"; then
	echo 'This installer needs to be run with "bash", not "sh".'
	exit
fi

# Discard stdin. Needed when running from an one-liner which includes a newline
read -N 999999 -t 0.001

# Detect OpenVZ 6
if [[ $(uname -r | cut -d "." -f 1) -eq 2 ]]; then
	echo "The system is running an old kernel, which is incompatible with this installer."
	exit
fi

# Detect OS
# $os_version variables aren't always in use, but are kept here for convenience
if grep -qs "ubuntu" /etc/os-release; then
	os="ubuntu"
	os_version=$(grep 'VERSION_ID' /etc/os-release | cut -d '"' -f 2 | tr -d '.')
	group_name="nogroup"
elif [[ -e /etc/debian_version ]]; then
	os="debian"
	os_version=$(grep -oE '[0-9]+' /etc/debian_version | head -1)
	group_name="nogroup"
elif [[ -e /etc/centos-release ]]; then
	os="centos"
	os_version=$(grep -oE '[0-9]+' /etc/centos-release | head -1)
	group_name="nobody"
elif [[ -e /etc/fedora-release ]]; then
	os="fedora"
	os_version=$(grep -oE '[0-9]+' /etc/fedora-release | head -1)
	group_name="nobody"
else
	echo "This installer seems to be running on an unsupported distribution.
Supported distributions are Ubuntu, Debian, CentOS, and Fedora."
	exit
fi

if [[ "$os" == "ubuntu" && "$os_version" -lt 1804 ]]; then
	echo "Ubuntu 18.04 or higher is required to use this installer.
This version of Ubuntu is too old and unsupported."
	exit
fi

if [[ "$os" == "debian" && "$os_version" -lt 9 ]]; then
	echo "Debian 9 or higher is required to use this installer.
This version of Debian is too old and unsupported."
	exit
fi

if [[ "$os" == "centos" && "$os_version" -lt 7 ]]; then
	echo "CentOS 7 or higher is required to use this installer.
This version of CentOS is too old and unsupported."
	exit
fi

# Detect environments where $PATH does not include the sbin directories
if ! grep -q sbin <<< "$PATH"; then
	echo '$PATH does not include sbin. Try using "su -" instead of "su".'
	exit
fi

if [[ "$EUID" -ne 0 ]]; then
	echo "This installer needs to be run with superuser privileges."
	exit
fi

if [[ ! -e /dev/net/tun ]] || ! ( exec 7<>/dev/net/tun ) 2>/dev/null; then
	echo "The system does not have the TUN device available.
TUN needs to be enabled before running this installer."
	exit
fi

new_client () {
	# Generates the custom client.ovpn
	{
	cat /etc/openvpn/server/client-common.txt
	echo "<ca>"
	cat /etc/openvpn/server/easy-rsa/pki/ca.crt
	echo "</ca>"
	echo "<cert>"
	sed -ne '/BEGIN CERTIFICATE/,$ p' /etc/openvpn/server/easy-rsa/pki/issued/"$client".crt
	echo "</cert>"
	echo "<key>"
	cat /etc/openvpn/server/easy-rsa/pki/private/"$client".key
	echo "</key>"
	echo "<tls-crypt>"
	sed -ne '/BEGIN OpenVPN Static key/,$ p' /etc/openvpn/server/tc.key
	echo "</tls-crypt>"
	} > ~/"$client".ovpn
}

if [[ ! -e /etc/openvpn/server/server.conf ]]; then
	clear
	echo 'Welcome to this OpenVPN road warrior installer!'
	# If system has a single IPv4, it is selected automatically. Else, ask the user
	if [[ $(ip -4 addr | grep inet | grep -vEc '127(\.[0-9]{1,3}){3}') -eq 1 ]]; then
		ip=$(ip -4 addr | grep inet | grep -vE '127(\.[0-9]{1,3}){3}' | cut -d '/' -f 1 | grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}')
	else
		number_of_ip=$(ip -4 addr | grep inet | grep -vEc '127(\.[0-9]{1,3}){3}')
		echo
		echo "Which IPv4 address should be used?"
		ip -4 addr | grep inet | grep -vE '127(\.[0-9]{1,3}){3}' | cut -d '/' -f 1 | grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}' | nl -s ') '
		read -p "IPv4 address [1]: " ip_number
		until [[ -z "$ip_number" || "$ip_number" =~ ^[0-9]+$ && "$ip_number" -le "$number_of_ip" ]]; do
			echo "$ip_number: invalid selection."
			read -p "IPv4 address [1]: " ip_number
		done
		[[ -z "$ip_number" ]] && ip_number="1"
		ip=$(ip -4 addr | grep inet | grep -vE '127(\.[0-9]{1,3}){3}' | cut -d '/' -f 1 | grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}' | sed -n "$ip_number"p)
	fi
	# If $ip is a private IP address, the server must be behind NAT
	if echo "$ip" | grep -qE '^(10\.|172\.1[6789]\.|172\.2[0-9]\.|172\.3[01]\.|192\.168)'; then
		echo
		echo "This server is behind NAT. What is the public IPv4 address or hostname?"
		# Get public IP and sanitize with grep
		get_public_ip=$(grep -m 1 -oE '^[0-9]{1,3}(\.[0-9]{1,3}){3}$' <<< "$(wget -T 10 -t 1 -4qO- "http://ip1.dynupdate.no-ip.com/" || curl -m 10 -4Ls "http://ip1.dynupdate.no-ip.com/")")
		read -p "Public IPv4 address / hostname [$get_public_ip]: " public_ip
		# If the checkip service is unavailable and user didn't provide input, ask again
		until [[ -n "$get_public_ip" || -n "$public_ip" ]]; do
			echo "Invalid input."
			read -p "Public IPv4 address / hostname: " public_ip
		done
		[[ -z "$public_ip" ]] && public_ip="$get_public_ip"
	fi
	# If system has a single IPv6, it is selected automatically
	if [[ $(ip -6 addr | grep -c 'inet6 [23]') -eq 1 ]]; then
		ip6=$(ip -6 addr | grep 'inet6 [23]' | cut -d '/' -f 1 | grep -oE '([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}')
	fi
	# If system has multiple IPv6, ask the user to select one
	if [[ $(ip -6 addr | grep -c 'inet6 [23]') -gt 1 ]]; then
		number_of_ip6=$(ip -6 addr | grep -c 'inet6 [23]')
		echo
		echo "Which IPv6 address should be used?"
		ip -6 addr | grep 'inet6 [23]' | cut -d '/' -f 1 | grep -oE '([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}' | nl -s ') '
		read -p "IPv6 address [1]: " ip6_number
		until [[ -z "$ip6_number" || "$ip6_number" =~ ^[0-9]+$ && "$ip6_number" -le "$number_of_ip6" ]]; do
			echo "$ip6_number: invalid selection."
			read -p "IPv6 address [1]: " ip6_number
		done
		[[ -z "$ip6_number" ]] && ip6_number="1"
		ip6=$(ip -6 addr | grep 'inet6 [23]' | cut -d '/' -f 1 | grep -oE '([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}' | sed -n "$ip6_number"p)
	fi
	echo
	echo "Which protocol should OpenVPN use?"
	echo "   1) UDP (recommended)"
	echo "   2) TCP"
	read -p "Protocol [1]: " protocol
	until [[ -z "$protocol" || "$protocol" =~ ^[12]$ ]]; do
		echo "$protocol: invalid selection."
		read -p "Protocol [1]: " protocol
	done
	case "$protocol" in
		1|"") 
		protocol=udp
		;;
		2) 
		protocol=tcp
		;;
	esac
	echo
	echo "What port should OpenVPN listen to?"
	read -p "Port [1194]: " port
	until [[ -z "$port" || "$port" =~ ^[0-9]+$ && "$port" -le 65535 ]]; do
		echo "$port: invalid port."
		read -p "Port [1194]: " port
	done
	[[ -z "$port" ]] && port="1194"
	echo
	echo "Select a DNS server for the clients:"
	echo "   1) Current system resolvers"
	echo "   2) Google"
	echo "   3) 1.1.1.1"
	echo "   4) OpenDNS"
	echo "   5) Quad9"
	echo "   6) AdGuard"
	read -p "DNS server [1]: " dns
	until [[ -z "$dns" || "$dns" =~ ^[1-6]$ ]]; do
		echo "$dns: invalid selection."
		read -p "DNS server [1]: " dns
	done
	echo
	echo "Enter a name for the first client:"
	read -p "Name [client]: " unsanitized_client
	# Allow a limited set of characters to avoid conflicts
	client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
	[[ -z "$client" ]] && client="client"
	echo
	echo "OpenVPN installation is ready to begin."
	# Install a firewall in the rare case where one is not already available
	if ! systemctl is-active --quiet firewalld.service && ! hash iptables 2>/dev/null; then
		if [[ "$os" == "centos" || "$os" == "fedora" ]]; then
			firewall="firewalld"
			# We don't want to silently enable firewalld, so we give a subtle warning
			# If the user continues, firewalld will be installed and enabled during setup
			echo "firewalld, which is required to manage routing tables, will also be installed."
		elif [[ "$os" == "debian" || "$os" == "ubuntu" ]]; then
			# iptables is way less invasive than firewalld so no warning is given
			firewall="iptables"
		fi
	fi
	read -n1 -r -p "Press any key to continue..."
	# If running inside a container, disable LimitNPROC to prevent conflicts
	if systemd-detect-virt -cq; then
		mkdir /etc/systemd/system/openvpn-server@server.service.d/ 2>/dev/null
		echo "[Service]
LimitNPROC=infinity" > /etc/systemd/system/openvpn-server@server.service.d/disable-limitnproc.conf
	fi
	if [[ "$os" = "debian" || "$os" = "ubuntu" ]]; then
		apt-get update
		apt-get install -y openvpn openssl ca-certificates $firewall
	elif [[ "$os" = "centos" ]]; then
		yum install -y epel-release
		yum install -y openvpn openssl ca-certificates tar $firewall
	else
		# Else, OS must be Fedora
		dnf install -y openvpn openssl ca-certificates tar $firewall
	fi
	# If firewalld was just installed, enable it
	if [[ "$firewall" == "firewalld" ]]; then
		systemctl enable --now firewalld.service
	fi
	# Get easy-rsa
	easy_rsa_url='https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.8/EasyRSA-3.0.8.tgz'
	mkdir -p /etc/openvpn/server/easy-rsa/
	{ wget -qO- "$easy_rsa_url" 2>/dev/null || curl -sL "$easy_rsa_url" ; } | tar xz -C /etc/openvpn/server/easy-rsa/ --strip-components 1
	chown -R root:root /etc/openvpn/server/easy-rsa/
	cd /etc/openvpn/server/easy-rsa/
	# Create the PKI, set up the CA and the server and client certificates
	./easyrsa init-pki
	./easyrsa --batch build-ca nopass
	EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-server-full server nopass
	EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-client-full "$client" nopass
	EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl
	# Move the stuff we need
	cp pki/ca.crt pki/private/ca.key pki/issued/server.crt pki/private/server.key pki/crl.pem /etc/openvpn/server
	# CRL is read with each client connection, while OpenVPN is dropped to nobody
	chown nobody:"$group_name" /etc/openvpn/server/crl.pem
	# Without +x in the directory, OpenVPN can't run a stat() on the CRL file
	chmod o+x /etc/openvpn/server/
	# Generate key for tls-crypt
	openvpn --genkey --secret /etc/openvpn/server/tc.key
	# Create the DH parameters file using the predefined ffdhe2048 group
	echo '-----BEGIN DH PARAMETERS-----
MIIBCAKCAQEA//////////+t+FRYortKmq/cViAnPTzx2LnFg84tNpWp4TZBFGQz
+8yTnc4kmz75fS/jY2MMddj2gbICrsRhetPfHtXV/WVhJDP1H18GbtCFY2VVPe0a
87VXE15/V8k1mE8McODmi3fipona8+/och3xWKE2rec1MKzKT0g6eXq8CrGCsyT7
YdEIqUuyyOP7uWrat2DX9GgdT0Kj3jlN9K5W7edjcrsZCwenyO4KbXCeAvzhzffi
7MA0BM0oNC9hkXL+nOmFg/+OTxIy7vKBg8P+OxtMb61zO7X8vC7CIAXFjvGDfRaD
ssbzSibBsu/6iGtCOGEoXJf//////////wIBAg==
-----END DH PARAMETERS-----' > /etc/openvpn/server/dh.pem
	# Generate server.conf
	echo "local $ip
port $port
proto $protocol
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
auth SHA512
tls-crypt tc.key
topology subnet
server 10.8.0.0 255.255.255.0" > /etc/openvpn/server/server.conf
	# IPv6
	if [[ -z "$ip6" ]]; then
		echo 'push "redirect-gateway def1 bypass-dhcp"' >> /etc/openvpn/server/server.conf
	else
		echo 'server-ipv6 fddd:1194:1194:1194::/64' >> /etc/openvpn/server/server.conf
		echo 'push "redirect-gateway def1 ipv6 bypass-dhcp"' >> /etc/openvpn/server/server.conf
	fi
	echo 'ifconfig-pool-persist ipp.txt' >> /etc/openvpn/server/server.conf
	# DNS
	case "$dns" in
		1|"")
			# Locate the proper resolv.conf
			# Needed for systems running systemd-resolved
			if grep -q '^nameserver 127.0.0.53' "/etc/resolv.conf"; then
				resolv_conf="/run/systemd/resolve/resolv.conf"
			else
				resolv_conf="/etc/resolv.conf"
			fi
			# Obtain the resolvers from resolv.conf and use them for OpenVPN
			grep -v '^#\|^;' "$resolv_conf" | grep '^nameserver' | grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}' | while read line; do
				echo "push \"dhcp-option DNS $line\"" >> /etc/openvpn/server/server.conf
			done
		;;
		2)
			echo 'push "dhcp-option DNS 8.8.8.8"' >> /etc/openvpn/server/server.conf
			echo 'push "dhcp-option DNS 8.8.4.4"' >> /etc/openvpn/server/server.conf
		;;
		3)
			echo 'push "dhcp-option DNS 1.1.1.1"' >> /etc/openvpn/server/server.conf
			echo 'push "dhcp-option DNS 1.0.0.1"' >> /etc/openvpn/server/server.conf
		;;
		4)
			echo 'push "dhcp-option DNS 208.67.222.222"' >> /etc/openvpn/server/server.conf
			echo 'push "dhcp-option DNS 208.67.220.220"' >> /etc/openvpn/server/server.conf
		;;
		5)
			echo 'push "dhcp-option DNS 9.9.9.9"' >> /etc/openvpn/server/server.conf
			echo 'push "dhcp-option DNS 149.112.112.112"' >> /etc/openvpn/server/server.conf
		;;
		6)
			echo 'push "dhcp-option DNS 94.140.14.14"' >> /etc/openvpn/server/server.conf
			echo 'push "dhcp-option DNS 94.140.15.15"' >> /etc/openvpn/server/server.conf
		;;
	esac
	echo "keepalive 10 120
cipher AES-256-CBC
user nobody
group $group_name
persist-key
persist-tun
verb 3
crl-verify crl.pem" >> /etc/openvpn/server/server.conf
	if [[ "$protocol" = "udp" ]]; then
		echo "explicit-exit-notify" >> /etc/openvpn/server/server.conf
	fi
	# Enable net.ipv4.ip_forward for the system
	echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/30-openvpn-forward.conf
	# Enable without waiting for a reboot or service restart
	echo 1 > /proc/sys/net/ipv4/ip_forward
	if [[ -n "$ip6" ]]; then
		# Enable net.ipv6.conf.all.forwarding for the system
		echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.d/30-openvpn-forward.conf
		# Enable without waiting for a reboot or service restart
		echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
	fi
	if systemctl is-active --quiet firewalld.service; then
		# Using both permanent and not permanent rules to avoid a firewalld
		# reload.
		# We don't use --add-service=openvpn because that would only work with
		# the default port and protocol.
		firewall-cmd --add-port="$port"/"$protocol"
		firewall-cmd --zone=trusted --add-source=10.8.0.0/24
		firewall-cmd --permanent --add-port="$port"/"$protocol"
		firewall-cmd --permanent --zone=trusted --add-source=10.8.0.0/24
		# Set NAT for the VPN subnet
		firewall-cmd --direct --add-rule ipv4 nat POSTROUTING 0 -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j SNAT --to "$ip"
		firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 0 -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j SNAT --to "$ip"
		if [[ -n "$ip6" ]]; then
			firewall-cmd --zone=trusted --add-source=fddd:1194:1194:1194::/64
			firewall-cmd --permanent --zone=trusted --add-source=fddd:1194:1194:1194::/64
			firewall-cmd --direct --add-rule ipv6 nat POSTROUTING 0 -s fddd:1194:1194:1194::/64 ! -d fddd:1194:1194:1194::/64 -j SNAT --to "$ip6"
			firewall-cmd --permanent --direct --add-rule ipv6 nat POSTROUTING 0 -s fddd:1194:1194:1194::/64 ! -d fddd:1194:1194:1194::/64 -j SNAT --to "$ip6"
		fi
	else
		# Create a service to set up persistent iptables rules
		iptables_path=$(command -v iptables)
		ip6tables_path=$(command -v ip6tables)
		# nf_tables is not available as standard in OVZ kernels. So use iptables-legacy
		# if we are in OVZ, with a nf_tables backend and iptables-legacy is available.
		if [[ $(systemd-detect-virt) == "openvz" ]] && readlink -f "$(command -v iptables)" | grep -q "nft" && hash iptables-legacy 2>/dev/null; then
			iptables_path=$(command -v iptables-legacy)
			ip6tables_path=$(command -v ip6tables-legacy)
		fi
		echo "[Unit]
Before=network.target
[Service]
Type=oneshot
ExecStart=$iptables_path -t nat -A POSTROUTING -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j SNAT --to $ip
ExecStart=$iptables_path -I INPUT -p $protocol --dport $port -j ACCEPT
ExecStart=$iptables_path -I FORWARD -s 10.8.0.0/24 -j ACCEPT
ExecStart=$iptables_path -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
ExecStop=$iptables_path -t nat -D POSTROUTING -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j SNAT --to $ip
ExecStop=$iptables_path -D INPUT -p $protocol --dport $port -j ACCEPT
ExecStop=$iptables_path -D FORWARD -s 10.8.0.0/24 -j ACCEPT
ExecStop=$iptables_path -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT" > /etc/systemd/system/openvpn-iptables.service
		if [[ -n "$ip6" ]]; then
			echo "ExecStart=$ip6tables_path -t nat -A POSTROUTING -s fddd:1194:1194:1194::/64 ! -d fddd:1194:1194:1194::/64 -j SNAT --to $ip6
ExecStart=$ip6tables_path -I FORWARD -s fddd:1194:1194:1194::/64 -j ACCEPT
ExecStart=$ip6tables_path -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
ExecStop=$ip6tables_path -t nat -D POSTROUTING -s fddd:1194:1194:1194::/64 ! -d fddd:1194:1194:1194::/64 -j SNAT --to $ip6
ExecStop=$ip6tables_path -D FORWARD -s fddd:1194:1194:1194::/64 -j ACCEPT
ExecStop=$ip6tables_path -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT" >> /etc/systemd/system/openvpn-iptables.service
		fi
		echo "RemainAfterExit=yes
[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/openvpn-iptables.service
		systemctl enable --now openvpn-iptables.service
	fi
	# If SELinux is enabled and a custom port was selected, we need this
	if sestatus 2>/dev/null | grep "Current mode" | grep -q "enforcing" && [[ "$port" != 1194 ]]; then
		# Install semanage if not already present
		if ! hash semanage 2>/dev/null; then
			if [[ "$os_version" -eq 7 ]]; then
				# Centos 7
				yum install -y policycoreutils-python
			else
				# CentOS 8 or Fedora
				dnf install -y policycoreutils-python-utils
			fi
		fi
		semanage port -a -t openvpn_port_t -p "$protocol" "$port"
	fi
	# If the server is behind NAT, use the correct IP address
	[[ -n "$public_ip" ]] && ip="$public_ip"
	# client-common.txt is created so we have a template to add further users later
	echo "client
dev tun
proto $protocol
remote $ip $port
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
auth SHA512
cipher AES-256-CBC
ignore-unknown-option block-outside-dns
block-outside-dns
verb 3" > /etc/openvpn/server/client-common.txt
	# Enable and start the OpenVPN service
	systemctl enable --now openvpn-server@server.service
	# Generates the custom client.ovpn
	new_client
	echo
	echo "Finished!"
	echo
	echo "The client configuration is available in:" ~/"$client.ovpn"
	echo "New clients can be added by running this script again."
else
	clear
	echo "OpenVPN is already installed."
	echo
	echo "Select an option:"
	echo "   1) Add a new client"
	echo "   2) Revoke an existing client"
	echo "   3) Remove OpenVPN"
	echo "   4) Exit"
	read -p "Option: " option
	until [[ "$option" =~ ^[1-4]$ ]]; do
		echo "$option: invalid selection."
		read -p "Option: " option
	done
	case "$option" in
		1)
			echo
			echo "Provide a name for the client:"
			read -p "Name: " unsanitized_client
			client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
			while [[ -z "$client" || -e /etc/openvpn/server/easy-rsa/pki/issued/"$client".crt ]]; do
				echo "$client: invalid name."
				read -p "Name: " unsanitized_client
				client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
			done
			cd /etc/openvpn/server/easy-rsa/
			EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-client-full "$client" nopass
			# Generates the custom client.ovpn
			new_client
			echo
			echo "$client added. Configuration available in:" ~/"$client.ovpn"
			exit
		;;
		2)
			# This option could be documented a bit better and maybe even be simplified
			# ...but what can I say, I want some sleep too
			number_of_clients=$(tail -n +2 /etc/openvpn/server/easy-rsa/pki/index.txt | grep -c "^V")
			if [[ "$number_of_clients" = 0 ]]; then
				echo
				echo "There are no existing clients!"
				exit
			fi
			echo
			echo "Select the client to revoke:"
			tail -n +2 /etc/openvpn/server/easy-rsa/pki/index.txt | grep "^V" | cut -d '=' -f 2 | nl -s ') '
			read -p "Client: " client_number
			until [[ "$client_number" =~ ^[0-9]+$ && "$client_number" -le "$number_of_clients" ]]; do
				echo "$client_number: invalid selection."
				read -p "Client: " client_number
			done
			client=$(tail -n +2 /etc/openvpn/server/easy-rsa/pki/index.txt | grep "^V" | cut -d '=' -f 2 | sed -n "$client_number"p)
			echo
			read -p "Confirm $client revocation? [y/N]: " revoke
			until [[ "$revoke" =~ ^[yYnN]*$ ]]; do
				echo "$revoke: invalid selection."
				read -p "Confirm $client revocation? [y/N]: " revoke
			done
			if [[ "$revoke" =~ ^[yY]$ ]]; then
				cd /etc/openvpn/server/easy-rsa/
				./easyrsa --batch revoke "$client"
				EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl
				rm -f /etc/openvpn/server/crl.pem
				cp /etc/openvpn/server/easy-rsa/pki/crl.pem /etc/openvpn/server/crl.pem
				# CRL is read with each client connection, when OpenVPN is dropped to nobody
				chown nobody:"$group_name" /etc/openvpn/server/crl.pem
				echo
				echo "$client revoked!"
			else
				echo
				echo "$client revocation aborted!"
			fi
			exit
		;;
		3)
			echo
			read -p "Confirm OpenVPN removal? [y/N]: " remove
			until [[ "$remove" =~ ^[yYnN]*$ ]]; do
				echo "$remove: invalid selection."
				read -p "Confirm OpenVPN removal? [y/N]: " remove
			done
			if [[ "$remove" =~ ^[yY]$ ]]; then
				port=$(grep '^port ' /etc/openvpn/server/server.conf | cut -d " " -f 2)
				protocol=$(grep '^proto ' /etc/openvpn/server/server.conf | cut -d " " -f 2)
				if systemctl is-active --quiet firewalld.service; then
					ip=$(firewall-cmd --direct --get-rules ipv4 nat POSTROUTING | grep '\-s 10.8.0.0/24 '"'"'!'"'"' -d 10.8.0.0/24' | grep -oE '[^ ]+$')
					# Using both permanent and not permanent rules to avoid a firewalld reload.
					firewall-cmd --remove-port="$port"/"$protocol"
					firewall-cmd --zone=trusted --remove-source=10.8.0.0/24
					firewall-cmd --permanent --remove-port="$port"/"$protocol"
					firewall-cmd --permanent --zone=trusted --remove-source=10.8.0.0/24
					firewall-cmd --direct --remove-rule ipv4 nat POSTROUTING 0 -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j SNAT --to "$ip"
					firewall-cmd --permanent --direct --remove-rule ipv4 nat POSTROUTING 0 -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j SNAT --to "$ip"
					if grep -qs "server-ipv6" /etc/openvpn/server/server.conf; then
						ip6=$(firewall-cmd --direct --get-rules ipv6 nat POSTROUTING | grep '\-s fddd:1194:1194:1194::/64 '"'"'!'"'"' -d fddd:1194:1194:1194::/64' | grep -oE '[^ ]+$')
						firewall-cmd --zone=trusted --remove-source=fddd:1194:1194:1194::/64
						firewall-cmd --permanent --zone=trusted --remove-source=fddd:1194:1194:1194::/64
						firewall-cmd --direct --remove-rule ipv6 nat POSTROUTING 0 -s fddd:1194:1194:1194::/64 ! -d fddd:1194:1194:1194::/64 -j SNAT --to "$ip6"
						firewall-cmd --permanent --direct --remove-rule ipv6 nat POSTROUTING 0 -s fddd:1194:1194:1194::/64 ! -d fddd:1194:1194:1194::/64 -j SNAT --to "$ip6"
					fi
				else
					systemctl disable --now openvpn-iptables.service
					rm -f /etc/systemd/system/openvpn-iptables.service
				fi
				if sestatus 2>/dev/null | grep "Current mode" | grep -q "enforcing" && [[ "$port" != 1194 ]]; then
					semanage port -d -t openvpn_port_t -p "$protocol" "$port"
				fi
				systemctl disable --now openvpn-server@server.service
				rm -rf /etc/openvpn/server
				rm -f /etc/systemd/system/openvpn-server@server.service.d/disable-limitnproc.conf
				rm -f /etc/sysctl.d/30-openvpn-forward.conf
				if [[ "$os" = "debian" || "$os" = "ubuntu" ]]; then
					apt-get remove --purge -y openvpn
				else
					# Else, OS must be CentOS or Fedora
					yum remove -y openvpn
				fi
				echo
				echo "OpenVPN removed!"
			else
				echo
				echo "OpenVPN removal aborted!"
			fi
			exit
		;;
		4)
			exit
		;;
	esac
fi
}


set_v2ray(){
  #定时任务北京执行时间(0~23)
BEIJING_UPDATE_TIME=3

#记录最开始运行脚本的路径
BEGIN_PATH=$(pwd)

#安装方式, 0为全新安装, 1为保留v2ray配置更新
INSTALL_WAY=0

#定义操作变量, 0为否, 1为是
HELP=0

REMOVE=0

CHINESE=0

BASE_SOURCE_PATH="https://multi.netlify.app"

UTIL_PATH="/etc/v2ray_util/util.cfg"

UTIL_CFG="$BASE_SOURCE_PATH/v2ray_util/util_core/util.cfg"

BASH_COMPLETION_SHELL="$BASE_SOURCE_PATH/v2ray"

CLEAN_IPTABLES_SHELL="$BASE_SOURCE_PATH/v2ray_util/global_setting/clean_iptables.sh"

#Centos 临时取消别名
[[ -f /etc/redhat-release && -z $(echo $SHELL|grep zsh) ]] && unalias -a

[[ -z $(echo $SHELL|grep zsh) ]] && ENV_FILE=".bashrc" || ENV_FILE=".zshrc"

#######color code########
RED="31m"
GREEN="32m"
YELLOW="33m"
BLUE="36m"
FUCHSIA="35m"

colorEcho(){
    COLOR=$1
    echo -e "\033[${COLOR}${@:2}\033[0m"
}

#######get params#########
while [[ $# > 0 ]];do
    key="$1"
    case $key in
        --remove)
        REMOVE=1
        ;;
        -h|--help)
        HELP=1
        ;;
        -k|--keep)
        INSTALL_WAY=1
        colorEcho ${BLUE} "keep config to update\n"
        ;;
        --zh)
        CHINESE=1
        colorEcho ${BLUE} "安装中文版..\n"
        ;;
        *)
                # unknown option
        ;;
    esac
    shift # past argument or value
done
#############################

help(){
    echo "bash v2ray.sh [-h|--help] [-k|--keep] [--remove]"
    echo "  -h, --help           Show help"
    echo "  -k, --keep           keep the config.json to update"
    echo "      --remove         remove v2ray,xray && multi-v2ray"
    echo "                       no params to new install"
    return 0
}

removeV2Ray() {
    #卸载V2ray脚本
    bash <(curl -L -s https://multi.netlify.app/go.sh) --remove >/dev/null 2>&1
    rm -rf /etc/v2ray >/dev/null 2>&1
    rm -rf /var/log/v2ray >/dev/null 2>&1

    #卸载Xray脚本
    bash <(curl -L -s https://multi.netlify.app/go.sh) --remove -x >/dev/null 2>&1
    rm -rf /etc/xray >/dev/null 2>&1
    rm -rf /var/log/xray >/dev/null 2>&1

    #清理v2ray相关iptable规则
    bash <(curl -L -s $CLEAN_IPTABLES_SHELL)

    #卸载multi-v2ray
    pip uninstall v2ray_util -y
    rm -rf /usr/share/bash-completion/completions/v2ray.bash >/dev/null 2>&1
    rm -rf /usr/share/bash-completion/completions/v2ray >/dev/null 2>&1
    rm -rf /usr/share/bash-completion/completions/xray >/dev/null 2>&1
    rm -rf /etc/bash_completion.d/v2ray.bash >/dev/null 2>&1
    rm -rf /usr/local/bin/v2ray >/dev/null 2>&1
    rm -rf /etc/v2ray_util >/dev/null 2>&1

    #删除v2ray定时更新任务
    crontab -l|sed '/SHELL=/d;/v2ray/d'|sed '/SHELL=/d;/xray/d' > crontab.txt
    crontab crontab.txt >/dev/null 2>&1
    rm -f crontab.txt >/dev/null 2>&1

    if [[ ${PACKAGE_MANAGER} == 'dnf' || ${PACKAGE_MANAGER} == 'yum' ]];then
        systemctl restart crond >/dev/null 2>&1
    else
        systemctl restart cron >/dev/null 2>&1
    fi

    #删除multi-v2ray环境变量
    sed -i '/v2ray/d' ~/$ENV_FILE
    sed -i '/xray/d' ~/$ENV_FILE
    source ~/$ENV_FILE

    colorEcho ${GREEN} "uninstall success!"
}

closeSELinux() {
    #禁用SELinux
    if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
        setenforce 0
    fi
}

checkSys() {
    #检查是否为Root
    [ $(id -u) != "0" ] && { colorEcho ${RED} "Error: You must be root to run this script"; exit 1; }

    if [[ `command -v apt-get` ]];then
        PACKAGE_MANAGER='apt-get'
    elif [[ `command -v dnf` ]];then
        PACKAGE_MANAGER='dnf'
    elif [[ `command -v yum` ]];then
        PACKAGE_MANAGER='yum'
    else
        colorEcho $RED "Not support OS!"
        exit 1
    fi
}

#安装依赖
installDependent(){
    if [[ ${PACKAGE_MANAGER} == 'dnf' || ${PACKAGE_MANAGER} == 'yum' ]];then
        ${PACKAGE_MANAGER} install socat crontabs bash-completion which -y
    else
        ${PACKAGE_MANAGER} update
        ${PACKAGE_MANAGER} install socat cron bash-completion ntpdate -y
    fi

    #install python3 & pip
    source <(curl -sL https://python3.netlify.app/install.sh)
}

updateProject() {
    [[ ! $(type pip 2>/dev/null) ]] && colorEcho $RED "pip no install!" && exit 1

    pip install -U v2ray_util

    if [[ -e $UTIL_PATH ]];then
        [[ -z $(cat $UTIL_PATH|grep lang) ]] && echo "lang=en" >> $UTIL_PATH
    else
        mkdir -p /etc/v2ray_util
        curl $UTIL_CFG > $UTIL_PATH
    fi

    [[ $CHINESE == 1 ]] && sed -i "s/lang=en/lang=zh/g" $UTIL_PATH

    rm -f /usr/local/bin/v2ray >/dev/null 2>&1
    ln -s $(which v2ray-util) /usr/local/bin/v2ray
    rm -f /usr/local/bin/xray >/dev/null 2>&1
    ln -s $(which v2ray-util) /usr/local/bin/xray

    #移除旧的v2ray bash_completion脚本
    [[ -e /etc/bash_completion.d/v2ray.bash ]] && rm -f /etc/bash_completion.d/v2ray.bash
    [[ -e /usr/share/bash-completion/completions/v2ray.bash ]] && rm -f /usr/share/bash-completion/completions/v2ray.bash

    #更新v2ray bash_completion脚本
    curl $BASH_COMPLETION_SHELL > /usr/share/bash-completion/completions/v2ray
    curl $BASH_COMPLETION_SHELL > /usr/share/bash-completion/completions/xray
    if [[ -z $(echo $SHELL|grep zsh) ]];then
        source /usr/share/bash-completion/completions/v2ray
        source /usr/share/bash-completion/completions/xray
    fi
    
    #安装V2ray主程序
    [[ ${INSTALL_WAY} == 0 ]] && bash <(curl -L -s https://multi.netlify.app/go.sh)
}

#时间同步
timeSync() {
    if [[ ${INSTALL_WAY} == 0 ]];then
        echo -e "${Info} Time Synchronizing.. ${Font}"
        if [[ `command -v ntpdate` ]];then
            ntpdate pool.ntp.org
        elif [[ `command -v chronyc` ]];then
            chronyc -a makestep
        fi

        if [[ $? -eq 0 ]];then 
            echo -e "${OK} Time Sync Success ${Font}"
            echo -e "${OK} now: `date -R`${Font}"
        fi
    fi
}

profileInit() {

    #清理v2ray模块环境变量
    [[ $(grep v2ray ~/$ENV_FILE) ]] && sed -i '/v2ray/d' ~/$ENV_FILE && source ~/$ENV_FILE

    #解决Python3中文显示问题
    [[ -z $(grep PYTHONIOENCODING=utf-8 ~/$ENV_FILE) ]] && echo "export PYTHONIOENCODING=utf-8" >> ~/$ENV_FILE && source ~/$ENV_FILE

    #全新安装的新配置
    [[ ${INSTALL_WAY} == 0 ]] && v2ray new

    echo ""
}

installFinish() {
    #回到原点
    cd ${BEGIN_PATH}

    [[ ${INSTALL_WAY} == 0 ]] && WAY="install" || WAY="update"
    colorEcho  ${GREEN} "multi-v2ray ${WAY} success!\n"

    if [[ ${INSTALL_WAY} == 0 ]]; then
        clear

        v2ray info

        echo -e "please input 'v2ray' command to manage v2ray\n"
    fi
}


main() {

    [[ ${HELP} == 1 ]] && help && return

    [[ ${REMOVE} == 1 ]] && removeV2Ray && return

    [[ ${INSTALL_WAY} == 0 ]] && colorEcho ${BLUE} "new install\n"

    checkSys

    installDependent

    closeSELinux

    timeSync

    updateProject

    profileInit

    installFinish
}

main
}


install_gitlab(){
COLOR='echo -e \E[01;31m'
END='\E[0m'
OS=`awk -F= '/^NAME/{print $2}' /etc/os-release | sed "s/\"//g"`
ubuntuurl='https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/ubuntu/pool/bionic/main/g/gitlab-ce/'
ubuntupack='gitlab-ce_12.9.9-ce.0_amd64.deb'
centosurl='https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/'
centospack='gitlab-ce-12.9.9-ce.0.el7.x86_64.rpm'
APTPACK='apt-file selinux-utils iproute2 ntpdate tcpdump telnet traceroute nfs-kernel-server nfs-common lrzsz tree openssl libssl-dev libpcre3 libpcre3-dev zlib1g-dev ntpdate tcpdump telnet traceroute gcc openssh-server lrzsz tree openssl libssl-dev libpcre3 libpcre3-dev zlib1g-dev ntpdate tcpdump telnet traceroute iotop unzip zip ipmitool'
YUMPACK='policycoreutils-python vim gcc gcc-c++ wget net-tools lrzsz iotop lsof iotop bash-completion curl policycoreutils openssh-server openssh-clients postfix'
packdir='/usr/local/src/'
if [[ "$OS" == "Ubuntu" ]];then
  :
elif [[ "$OS" == "CentOS Linux" ]];then
  OS="CentOS"
else
  echo "Unknown OS: \"$OS\", exit"
  exit 2
fi

$COLOR"注意！要求的最小配置为2c4g！"$END
sleep 5s

if [[ "$OS" == "Ubuntu" ]];then
    $COLOR"检测到当前系统为Ubuntu，开始下载依赖"$END
    apt install -y $APTPACK
if [ $? -eq 0 ];then
   $COLOR"下载成功！"$END
else
   $COLOR"下载失败！"$END
    exit      
fi
    ufw disable &> /dev/null
    setenforce 0 && sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config  &> /dev/null

if [ -f $packdir$ubuntupack ];then
   $COLOR"检测到deb存在"$END
else
   $COLOR"开始下载gitlab"$END
   wget -P $packdir $ubuntuurl$ubuntupack
if [ $? -eq 0 ];then
   $COLOR"下载成功！"$END
else
   $COLOR"下载失败！"$END
    exit      
fi  
fi
   $COLOR"开始执行初始化"$END
   sleep 5s
   dpkg -i $packdir$ubuntupack
   read -p "$(echo -e '\033[1;32m请输入gitlab要使用的域名或ip:\033[0m')" gitlabip
   sed -i "/^external_url/c external_url 'http://$gitlabip'" /etc/gitlab/gitlab.rb
   gitlab-ctl reconfigure
   gitlab-ctl start
if [ $? -eq 0 ];then
   $COLOR"启动成功！"$END
   exit
else
   $COLOR"启动失败！"$END
   exit      
fi


elif [[ "$OS" == "CentOS" ]];then
   $COLOR"检测到当前系统为Centos，开始下载依赖"$END
   yum -y install $YUMPACK
if [ $? -eq 0 ];then
   $COLOR"下载成功！"$END
else
   $COLOR"下载失败！"$END
    exit      
fi
   setenforce 0 && sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config  &> /dev/null
   systemctl stop firewalld &> /dev/null
   systemctl disable firewalld.service &> /dev/null
if [ -f $packdir$centospack ];then
   $COLOR"检测到rpm存在"$END
else
   $COLOR"开始下载gitlab"$END
   wget -P $packdir $centosurl$centospack
if [ $? -eq 0 ];then
   $COLOR"下载成功！"$END
else
   $COLOR"下载失败！"$END
   exit      
fi
fi
   $COLOR"开始执行初始化"$END
    sleep 5s
    #yum -y install $packdir$centospack
    rpm -ivh $packdir$centospack
    read -p "$(echo -e '\033[1;32m请输入gitlab要使用的域名或ip:\033[0m')" gitlabip
    sed -i "/^external_url/c external_url 'http://$gitlabip'" /etc/gitlab/gitlab.rb
    gitlab-ctl reconfigure
    gitlab-ctl start
if [ $? -eq 0 ];then
   $COLOR"启动成功！"$END
    exit
else
   $COLOR"启动失败！"$END
   exit      
fi
fi
}


install_jenkins(){
   echo "123"
}






































































































pull_script(){
yum_pack=git
apt_pack=git
OS=`awk -F= '/^NAME/{print $2}' /etc/os-release | sed "s/\"//g"`

if [[ "$OS" == "Ubuntu" ]];then
  :
elif [[ "$OS" == "CentOS Linux" ]];then
  OS="CentOS"
else
  echo "Unknown OS: \"$OS\", exit"
  exit 2
fi

if [[ "$OS" == "Ubuntu" ]];then
    apt install -y $apt_pack
    git clone https://gitee.com/amyoo/test-script.git
if [ $? -eq 0 ];then
    echo -e "\033[1;36m下载成功！\033[0m"
else
    echo -e "\033[1;36m下载失败！！\033[0m"
    exit
fi


elif [[ "$OS" == "CentOS" ]];then
    yum -y install $yum_pack
    git clone https://gitee.com/amyoo/test-script.git
if [ $? -eq 0 ];then
    echo -e "\033[1;36m下载成功！\033[0m"
else
    echo -e "\033[1;36m下载失败！！\033[0m"
    exit
fi

else
    echo "Unknown OS: \"$OS\", exit"
    exit
fi




}








set_sys(){
while :;do
echo -e "\033[1;36m  1.设置haporxy    \033[0m"
echo -e "\033[1;36m  2.设置lvs      \033[0m"
echo -e "\033[1;36m  3.设置rs服务器      \033[0m"
echo -e "\033[1;36m  4.安装pxe      \033[0m"
echo -e "\033[1;36m  5.备份mysql      \033[0m"
echo -e "\033[1;36m  6.安装kvm虚拟机    \033[0m"
echo -e "\033[1;36m  7.安装cobbler    \033[0m"
echo -e "\033[1;36m  8.设置rsync      \033[0m"
echo -e "\033[1;36m  9.docker安装lnmp    \033[0m"
echo -e "\033[1;36m  10.设置openvpn    \033[0m"
echo -e "\033[1;36m  11.设置v2ray    \033[0m"
echo -e "\033[1;36m  12.退出      \033[0m"
read -p "$(echo -e '\033[1;32m请输入你的选项:\033[0m')" option

case $option in

1)
  set_haporxy
  ;;
2)
  set_lvs_vs
  ;;
3)
  set_lvs_rs
  ;;
4)
  install_pxe
  ;;
5)
  backup_mysql
  ;;
6)
  install_kvm
  ;;
7)
  set_cobbler
  ;;
8)
  set_rsync
  ;;
9)
  docker_lnmp
  ;;
10)
  set_openvpn
  ;;
11)
  set_v2ray
  ;;
12)
  break
  ;;
*)
  echo -e "\033[1;36m输入错误！ \033[0m"
esac
done
}



install_all(){
COLOR='echo -e \E[01;31m'
End='\033[0m'
while :;do
echo -e "\033[1;36m  1.安装httpd      \033[0m"
echo -e "\033[1;36m  2.安装mysql      \033[0m"
echo -e "\033[1;36m  3.安装php        \033[0m"
echo -e "\033[1;36m  4.安装nginx      \033[0m"
echo -e "\033[1;36m  5.安装jdk        \033[0m"
echo -e "\033[1;36m  6.安装memcached  \033[0m"
echo -e "\033[1;36m  7.安装docker     \033[0m"
echo -e "\033[1;36m  8.安装tengine    \033[0m"
echo -e "\033[1;36m  9.安装openresty  \033[0m"
echo -e "\033[1;36m  10.安装keepalived\033[0m"
echo -e "\033[1;36m  11.安装lua       \033[0m"
echo -e "\033[1;36m  12.安装HAProxy   \033[0m"
echo -e "\033[1;36m  13.安装wordpress \033[0m"
echo -e "\033[1;36m  14.安装tomcat    \033[0m"
echo -e "\033[1;36m  15.安装halo      \033[0m"
echo -e "\033[1;36m  16.安装redis     \033[0m"
echo -e "\033[1;36m  17.安装zabbix    \033[0m"
echo -e "\033[1;36m  18.安装k8s集群   \033[0m"
echo -e "\033[1;36m  19.安装gitlab   \033[0m"
#echo -e "\033[1;36m  20.安装jenkins   \033[0m"
echo -e "\033[1;36m  20.退出          \033[0m"

read -p "$(echo -e '\033[1;32m请输入你的选项:\033[0m')" option
case $option in



1)
  install_httpd

   ;;
2)
  install_mysql
   ;;
3)
  install_php
   ;;
4)
  install_nginx
  ;;
5)
  install_jdk
  ;;
6)
  install_memcached
  ;;
7)
  IN_docker
  ;;
8)
  install_tengine
  ;;
9)
  install_openresty
  ;;
10)
  install_keepalived
  ;;
11)
  install_lua
  ;;
12)
  install_HAProxy
  ;;
13)
  install_wordpress
  ;;
14)  
  install_tomcat
  ;;
15)  
  install_halo
  ;;
16)
  install_redis
  ;;
17)
  install_zabbix
  ;;
18)
  install_kubeadma
  ;;
19)
  install_gitlab
  ;;
#20)
#  install_jenkins
#  ;;
20)
  break
  ;;
*)
  $COLOR"输入错误!!!"$END
   ;;
esac
done
}




while :;do
echo -e "\033[1;36m  
  使用系统设置时请注意linux版本，目前只支持centos和ubuntu
  使用一键服务时请小心配置，请注意是否配置了该服务以及环境问题          \033[0m"
echo -e "\033[1;36m  1.安装服务          \033[0m"
echo -e "\033[1;36m  2.系统设置          \033[0m"
echo -e "\033[1;36m  3.一键服务          \033[0m"
echo -e "\033[1;36m  4.下载脚本最新版本  \033[0m"
echo -e "\033[1;36m  5.退出          \033[0m"
read -p "$(echo -e '\033[1;32m请输入你的选项:\033[0m')" option
case $option in 
1)
  install_all
  ;;
2)
  reboot_all
  ;;
3)
  set_sys
  ;;
4)
  pull_script
  ;;
5)
  break
  ;;
*)
  echo -e "\033[1;36m输入错误！\033[0m"
esac
done
