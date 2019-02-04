#!/bin/bash
echo -e "\033[41;37m 安装时间同步服务端 \033[0m"
ctime_zone=`timedatectl | sed -n '/Time zone/p' | awk '{print $3}'`
if [ $ctime_zone != 'Asia/Shanghai' ];then
	echo -e "\033[41;37m 时区错误！！！修改时区中...... \033[0m"
	mv /etc/localtime /etc/localtime.bak
	ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
else
	echo -e "\033[42;37m 时区正确！！！\033[0m"
fi

rpm -q chronyd
if [ $? -eq 0 ];then
	echo "时间同步服务已经安装，修改配置文件中......"
else
	echo "准备安装时间同步服务，请稍等......"
	num=`yum repolist | sed -n 's/^repolist: //p' | sed -nr 's/,//p'`
	if [ $num -gt 0 ];then
        	echo "yum源可用数为${num}个"
		yum -y install chrony 
	else
        	echo "yum源不可用，请配好yum源再使用此脚本"
        	exit
	fi
	sleep 2
fi
read -p "请输入允许同步本机客户端ip段：" IP_chrony
sed -i '/server 1.centos.pool.ntp.org iburst/d' /etc/chrony.conf
sed -i '/server 2.centos.pool.ntp.org iburst/d' /etc/chrony.conf
sed -i '/server 3.centos.pool.ntp.org iburst/d' /etc/chrony.conf
sed -i "s%#allow 192.168.0.0/16%allow ${IP_chrony} %" /etc/chrony.conf
sed -i 's/#local stratum 10/local stratum 10/' /etc/chrony.conf
echo '......'
echo -e "\033[42;37m 时间同步服务端安装成功，配置文件修改成功！！！\033[0m"
systemctl start chronyd
systemctl enable chronyd
