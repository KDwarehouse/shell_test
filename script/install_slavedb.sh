#!/bin/bash
mkdir /tmp/soft
cd /tmp/soft
yum -y install autoconf perl-JSON wget
wget https://downloads.mysql.com/archives/get/file/MySQL-5.6.41-1.el7.x86_64.rpm-bundle.tar
tar xf MySQL-5.6.41-1.el7.x86_64.rpm-bundle.tar && yum -y install Mysql-*.rpm
rm -rf /etc/my.cnf
systemctl start mysql

if [ $? -eq 0 ];then
	echo "mysql安装已经完成！"
else
	echo "mysql安装失败！"
fi


read -p "请输入你要创建的密码：" passwdb
passwda=`awk -F: '{print $4}' /root/.mysql_secret`
mysql -uroot -p${passwda} -e "set password=password('$passwdb')"

rm -rf /usr/my.cnf
cp /tmp/work/shell_test/conf/slave.cnf /usr/my.cnf

read -p "设置从库ID编号：" id_a
read -p "设置库binlog日志代号：" a_name
read -P "设置mysql端口号：" port_a
sed -i "s/server_id=1/server_id=${id_a}/" /usr/my.cnf
sed -i "s/log_bin=master/log_bin=${a_name}/" /usr/my.cnf
sed -i "s/port=4273/port=${port_a}/" /usr/my.cnf

systemctl restart mysql
