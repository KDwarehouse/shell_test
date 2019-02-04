#!/bin/bash
echo -e "\033[41;37m 设置selinux为disabled.....\033[0m"
setenforce 0
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
sed -n  '/^SELINUX=/p' /etc/selinux/config | grep disabled
if [ $? -eq 0 ];then
	echo -e "\033[42;37m selinux设置成功！！！\033[0m"
else
	echo -e "\033[41;37m 设置失败！！！，请退出查看......\033[0m" && exit
fi
yum remove firewalld 
rpm -q firewalld
if [ $? -gt 0 ];then
	echo -e "\033[42;37m firewalld卸载成功！！！\033[0m"
else
	echo -e "\033[41;37m firewalld卸载失败！！！，请退出查看......\033[0m" && exit
fi
