#!/bin/bash
read -p "请输入你要设置的主机名：" host_name
read -p "请输入你要设置的密码：" passwd_a
read -p "请再次输入你要设置的密码：" passwd_b


hostname ${host_name}
echo ${host_name} > /etc/hostname

if [ ${passwd_a} == ${passwd_b} ];then
	echo ${passwd_a} | passwd --stdin root
	echo "你设置的主机名是：${host_name}"
	echo "你设置的密码是：${passwd_a}"
else
	echo "两次输入密码不一致！" 
	exit
fi
echo ''
echo ''
echo ''
echo ''
echo ''
echo ''
