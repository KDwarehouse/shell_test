#!/bin/bash
echo "警告：安装宝塔的服务器请在宝塔面板上面添加了ssh端口后再运行此脚本！！！"
read -p "请输入你要允许那些ip远程登录自己，以逗号分隔：" ip_allow
echo "sshd:${ip_allow}:allow" >> /etc/hosts.allow
echo "sshd:all" >> /etc/hosts.deny

echo "hosts.allow和hosts.deny设置完成"
