#!/bin/bash
yum -y install gcc make wget
mkdir /tmp/soft
cd /tmp/soft
wget http://download.redis.io/releases/redis-5.0.3.tar.gz
tar xf redis-5.0.3.tar.gz
cd redis-5.0.3
make 
make install
./utils/install_server.sh
read -p "请输入本机内网ip地址：" ip_add
sed -i "s/bind 127.0.0.1/bind 127.0.0.1 ${ip_add}/" /etc/redis/6379.conf
mingling() {
ls /etc/init.d/redis_*
}
mingling stop
mingling start

num=`ss -nutlp | grep redis | sed -n '1p' | awk '{print $5}'`
echo "本机redis服务ip和端口是：${num}"
