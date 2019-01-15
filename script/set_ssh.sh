#!/bin/bash
read -p "请输入你要开放ssh端口：" ssh_port
sed -i "s/#Port 22/Port ${ssh_port}/" /etc/ssh/sshd_config
systemctl restart sshd

read -p "请输入你要允许那些ip远程登录自己，以逗号分隔：" ip_allow
echo "sshd:${ip_allow}:allow" >> /etc/hosts.allow
echo "sshd:all" >> /etc/hosts.deny

echo "hosts.allow和hosts.deny设置完成"
