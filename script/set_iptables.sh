#!/bin/bash
read -p "请输入你防火墙要开放的端口以逗号分隔：" ip_port
iptables -I INPUT -p tcp -m multiport --dport ${ip_port} -j ACCEPT

iptables-save >> /etc/sysconfig/iptables
echo "iptables-restore < /etc/sysconfig/iptables" >>/etc/rc.local
chmod 777 /etc/rc.local
echo ''
echo ''
