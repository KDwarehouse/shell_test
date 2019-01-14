#/bin/bash
echo "安装宝塔面板"
yum -y update
yum install -y wget && wget -O install.sh http://download.bt.cn/install/install.sh && sh install.sh
