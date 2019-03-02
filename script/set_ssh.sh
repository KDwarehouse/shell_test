#!/bin/bash
echo -e "\033[41;37m 警告！如果有安装宝塔面板，请进入宝塔面板里开放自定义ssh的端口，如果没有宝塔请执行设置防火墙时添加此自定义的端口！\033[0m"
read -p "请输入你要开放ssh端口：" ssh_port
sed -i "s/#Port 22/Port ${ssh_port}/" /etc/ssh/sshd_config
systemctl restart sshd
a=`awk '/^Port / {print $2}' /etc/ssh/sshd_config`
if [ $a != ${ssh_port} ];then
        sed -i "s/${a}/Port ${ssh_port}/" /etc/ssh/sshd_config
        systemctl restart sshd
fi

echo -e "\033[42;37m 你开放的端口是${ssh_port},请注意添加防火墙规则！\033[0m"
