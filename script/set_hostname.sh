#!/bin/bash
read -p "请输入你要设置的主机名：" host_name
hostname ${host_name}
echo ${host_name} > /etc/hostname


while :
do
	read -p "请输入你要设置的密码：" passwd_a
	read -p "请再次输入你要设置的密码：" passwd_b
	if [ ${passwd_a} == ${passwd_b} ];then
		echo ${passwd_a} | passwd --stdin root
		echo -e "\033[42;38m 设置成功！主机名是：${host_name} 密码是：${passwd_a} \033[0m"
		exit
	else
		echo -e "\033[41;30m 两次输入密码不一致！请重新输入密码！\033[0m" 
	fi
done
