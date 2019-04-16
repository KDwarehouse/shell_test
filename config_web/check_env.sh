#!/bin/bash
read -p "输入你正在部署平台的名称：" name
read -p "主库内网IP：" master_ip
read -p "主库数据库端口：" master_port
read -p "平台库名：" db_name
read -p "授权用户名：" master_user
read -p "授权用户密码：" master_passwd
read -p "redis服务器内网IP：" slave_ip
read -p "redis服务器端口：" slave_port

before_env="/www/wwwroot/${name}/wx_before/.env"
bfswoole_env="/www/wwwroot/bfswoole/wx_bfswoole/.env"
back_env="/www/wwwroot/back/fh-back/.env"
chat_env="/www/wwwroot/chat-back/fh-chat/.env"
test_env="/www/wwwroot/test/wx_before/.env"

for i in ${before_env},${bfswoole_env},${back_env},${chat_env},${test_env}
do
    if [ -d $i ];then
        sed -i "s/^DB_HOST=/DB_HOST=${master_ip}/"
        sed -i "s/^DB_WRITE_HOST_1=/DB_WRITE_HOST_1=${master_ip}/"
        sed -i "s/^DB_READ_HOST_1=/DB_READ_HOST_1=${master_ip}/"
        sed -i "s/^DB_READ_HOST_2=/DB_READ_HOST_2=${master_ip}/"
        sed -i "s/^DB_PORT=/DB_PORT=${master_port}/"
        sed -i "s/^DB_DATABASE=/DB_DATABASE=${db_name}/"
        sed -i "s/^DB_USERNAME=/DB_USERNAME=${master_user}/"
        sed -i "s/^DB_PASSWORD=/DB_PASSWORD=${master_passwd}/"

        sed -i "/^REDIS_HOST=/REDIS_HOST=${slave_ip}/"
        sed -i "/^REDIS_PORT=/REDIS_PORT=${slave_port}/"
    else
        continue;
    fi
done
