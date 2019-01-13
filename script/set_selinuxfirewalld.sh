#!/bin/bash
echo "设置selinux为disabled....."
setenforce 0
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
sed -n  '/^SELINUX=/p' /etc/selinux/config | grep disabled
if [ $? -eq 0 ];then
	echo "设置成功！！！"
else
	echo "设置失败！！！，请退出查看......" && exit
fi
yum remove firewalld &> /dev/null
rpm -q firewalld
if [ $? -gt 0 ];then
	echo "firewalld卸载成功！！！"
else
	echo "firewalld卸载失败！！！，请退出查看......" && exit
fi
