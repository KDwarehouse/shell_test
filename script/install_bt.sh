#/bin/bash
echo -e "\033[41;30m 准备安装宝塔面板...... \033[0m"

yum_num=`yum repolist | sed -n '/^repolist/p' | awk '{print $2}' | sed -n 's/,//p'`
if [ ${yum_num} -gt 0 ];then
	yum -y update
	yum install -y wget && wget -O install.sh http://download.bt.cn/install/install.sh && sh install.sh
else
	echo -e "\033[41;30m 没有可用的yum源，请配好yum在使用脚本！\033[0m"
fi 
if [ $? -eq 0 ];then
	echo -e "\033[42;38m 安装宝塔面板成功 \033[0m"
else
	echo -e "\033[41;30m error 安装失败 \033[0m"
	exit
fi
