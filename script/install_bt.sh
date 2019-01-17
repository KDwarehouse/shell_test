#/bin/bash
echo -e "\033[41;30m 准备安装宝塔面板...... \033[0m"

yum -y update
yum install -y wget && wget -O install.sh http://download.bt.cn/install/install.sh && sh install.sh
echo ''
echo ''
if [ $? -eq 0 ];then
	echo -e "\033[42;38m 安装宝塔面板成功 \033[0m"
else
	echo -e "\033[41;30m error 安装失败"
	exit
fi
echo ''
echo ''
