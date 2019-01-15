#!/bin/bash
echo "警告！如果有安装宝塔面板，请进入宝塔面板里开放自定义ssh的端口，如果没有宝塔请执行设置防火墙时添加此自定义的端口！"
read -p "请输入你要开放ssh端口：" ssh_port
sed -i "s/#Port 22/Port ${ssh_port}/" /etc/ssh/sshd_config
systemctl restart sshd

read -p "请输入你要允许那些ip远程登录自己，以逗号分隔：" ip_allow
echo "sshd:${ip_allow}:allow" >> /etc/hosts.allow
echo "sshd:all" >> /etc/hosts.deny

echo "hosts.allow和hosts.deny设置完成"
