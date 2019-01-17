#!/bin/bash
echo "安装时间同步客户端"
ctime_zone=`timedatectl | sed -n '/Time zone/p' | awk '{print $3}'`
if [ $ctime_zone != 'Asia/Shanghai' ];then
        echo "时区错误！！！修改时区中......"
        mv /etc/localtime /etc/localtime.bak
        ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
else
        echo "时区正确！！！"
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
read -p "请输入同步服务器的ip：" IP_chrony
sed -i "s/0.centos.pool.ntp.org/${IP_chrony}/" /etc/chrony.conf
sed -i '/server 1.centos.pool.ntp.org iburst/d' /etc/chrony.conf
sed -i '/server 2.centos.pool.ntp.org iburst/d' /etc/chrony.conf
sed -i '/server 3.centos.pool.ntp.org iburst/d' /etc/chrony.conf
echo '......'
echo '......'
echo '时间同步客户端安装成功，配置文件修改成功！！！'
systemctl start chronyd
systemctl enable chronyd
echo ''
echo ''
echo ''
echo ''
echo ''
echo ''
