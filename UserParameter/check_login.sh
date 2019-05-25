#!/bin/bash
source /root/check_ip/send_message.sh
#服务器名称（例如：lc-01）
pt_name='lc-01'
user_ip=`who | awk '{print $NF}'| sed 's/[()]//g'`
for i in ${user_ip}
do
        if [ ${i} != '222.127.22.62' ];then
                text="${i}登录${pt_name}服务器!!!"
                send_message ${text}
        fi
done
