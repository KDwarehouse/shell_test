#!/bin/bash
mkdir /tmp/soft
cd /tmp/soft
yum -y install autoconf perl-JSON wget except
wget https://downloads.mysql.com/archives/get/file/MySQL-5.6.41-1.el7.x86_64.rpm-bundle.tar
tar xf MySQL-5.6.41-1.el7.x86_64.rpm-bundle.tar
yum -y install MySQL-*.rpm
rm -rf /etc/my.cnf
systemctl start mysql

if [ $? -eq 0 ];then
	echo "mysql安装已经完成！"
else
	echo "mysql安装失败！"
fi


read -p "请输入你要创建的密码：" passwdb
passwda=`awk '{print $NF}' /root/.mysql_secret`
expect <<  EOF
spawn mysql -uroot  -p
expect "password:" {send "${passwda}\r"}
expect "mysql>" {send "SET PASSWORD FOR root@localhost=PASSWORD('${passwdb}');\r"}
expect "mysql>" {send "exit\r"}
EOF
[ $? -eq 0 ] && echo mysql密码修改成功,密码是:${passwdb} || echo 密码修改失



rm -rf /usr/my.cnf
cp /tmp/work/shell_test/conf/master.cnf /usr/my.cnf

read -p "设置主库ID编号：" id_a
read -p "设置主库binlog日志代号：" a_name
read -p "设置mysql端口号：" port_a
sed -i "s/server_id=1/server_id=${id_a}/" /usr/my.cnf
sed -i "s/log_bin=master/log_bin=${a_name}/" /usr/my.cnf
sed -i "s/port=4273/port=${port_a}/" /usr/my.cnf

systemctl restart mysql

mysql -uroot -p${passwdb} -e "GRANT REPLICATION SLAVE ON *.* TO 'slave'@'192.168.%.%' IDENTIFIED BY 'slave1212';"
m_binfile=`mysql -uroot -p${passwdb} -e "show master status\G"  2>/dev/null | awk '/File/{print $2}'`
m_posi=`mysql -uroot -p${passwdb} -e "show master status\G"  2>/dev/null | awk '/Position/{print $2}'`
echo "bin文件名为:$m_binfile posi位置为:$m_posi"

rm -rf /tmp/soft
