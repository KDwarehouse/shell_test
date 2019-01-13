#!/bin/bash
echo "install nginx"
echo "......"
echo "......"
echo "......"
echo "create user nginx"
useradd -s /sbin/nologin nginx
echo "......"
echo "......"
echo "......"
echo "create success"


echo "install rely"
yum -y install wget
yum -y install gcc pcre-devel openssl-devel zlib-devel 

mkdir /tmp/soft
cd /tmp/soft
wget http://nginx.org/download/nginx-1.14.2.tar.gz
tar xf nginx-1.14.2.tar.gz
cd nginx-1.14.2
./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_ssl_module --with-stream --with-http_stub_status_module
make
make install

rm -rf /usr/local/nginx/conf/nginx.conf
cp /root/work/shell_test/conf/nginx.conf  /usr/local/nginx/conf/nginx.conf
/usr/local/nginx/sbin/nginx 


cd /root && rm -rf /tmp/soft/*
echo "......"
echo "......"
echo "......"
echo "install nginx success"
