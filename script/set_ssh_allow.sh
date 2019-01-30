#!/bin/bash
echo -e "\033[41;37m 警告：安装宝塔的服务器请在宝塔面板上面添加了ssh端口后再运行此脚本！！！\033[0m"
read -p "请输入你要允许那些ip远程登录自己，以逗号分隔：" ip_allow
echo "sshd:${ip_allow}:allow" >> /etc/hosts.allow
echo "sshd:all" >> /etc/hosts.deny

echo -e "\033[42;37m hosts.allow和hosts.deny设置完成 \033[0m"
ssh_allow=`tail -1 /etc/hosts.allow`
ssh_deny=`tail -1 /etc/hosts.deny`
echo -e "\033[42;37m 你允许${ssh_allow}这些IP能远程登录本机 \033[0m"
