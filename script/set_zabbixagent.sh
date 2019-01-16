#!/bin/bash
useradd -s /sbin/nologin zabbix
yum -y install wget gcc pcre-devel
mkdir /tmp/soft
cd /tmp/soft
wget https://www.ttl178.com/tools/zabbix-4.0.1.tar.gz
tar xf zabbix-4.0.1.tar.gz
cd zabbix-4.0.1
./configure --enable-agent
make && make install

read -p "请输入zabbix服务端的ip地址：" IP_server
read -p "请输入主机名称（必须和现在服务器名称一致）：" host_name
sed -i "s/Server=127.0.0.1/Server=127.0.0.1,${IP_server}/" /usr/local/etc/zabbix_agentd.conf
sed -i "s/ServerActive=127.0.0.1/ServerActive=127.0.0.1,${IP_server}/" /usr/local/etc/zabbix_agentd.conf
sed -i "s/Hostname=Zabbix server/Hostname=${host_name}/" /usr/local/etc/zabbix_agentd.conf
sed -i "s/# EnableRemoteCommands=0/EnableRemoteCommands=1/" /usr/local/etc/zabbix_agentd.conf
sed -i "s/# UnsafeUserParameters=0/UnsafeUserParameters=1/" /usr/local/etc/zabbix_agentd.conf

zabbix_agentd
if [ $? -eq 0 ];then
        echo "zabbix_agentd安装成功！"
else
        echo "zabbix_agentd安装失败！"
fi
ss -nutlp | grep zabbix_agentd >/dev/null
if [ $? -eq 0 ];then
	echo "zabbix_agentd启动成功！"
else
	echo "zabbix_agentd启动失败！"
fi


rm -rf /tmp/soft
