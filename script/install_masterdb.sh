#!/bin/bash
if [ -d /tmp/soft ];then
	mkdir /tmp/softsoft11
	cd /tmp/softsoft11
	yum -y install autoconf perl-JSON perl wget expect 
	yum -y remove mariadb*
	wget https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.24-1.el7.x86_64.rpm-bundle.tar
	tar xf mysql-5.7.24-1.el7.x86_64.rpm-bundle.tar
else
	mkdir /tmp/soft
	cd /tmp/soft
	yum -y install autoconf perl-JSON perl wget expect
	yum -y remove mariadb*
	wget https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.24-1.el7.x86_64.rpm-bundle.tar
	tar xf mysql-5.7.24-1.el7.x86_64.rpm-bundle.tar
fi

if [ -d /var/lib/mysql ];then
	echo -e "\033[41;37m MYSQL已经安装 \033[0m"
	read -p "1）卸载并重新安装 2）退出" user_chi
	case ${user_chi} in
	1)
		rm -rf /var/lib/mysql
		yum remove mysql*
		pkill -9 mysqld
		a=`find / -name mysql`
		for i in $a
		do
			rm -rf $i
		done
		rm -rf /var/log/mysqld.log
		;;
	2)
		exit;;
	esac
fi
mv mysql-community-server-minimal-5.7.24-1.el7.x86_64.rpm /tmp
yum -y install mysql-*.rpm
systemctl start mysqld
ss -nutlp | grep mysqld
if [ $? -eq 0 ];then
	echo "mysql安装已经完成！"
else
	echo "mysql安装失败！"
fi

read -p "请输入你要创建的密码：" passwdb
passwda=`awk '/password/{print $NF}' /var/log/mysqld.log`
expect <<  EOF
spawn mysql -uroot  -p
expect "password:" {send "${passwda}\r"}
expect "mysql>" {send "SET PASSWORD FOR root@localhost=PASSWORD('${passwdb}');\r"}
expect "mysql>" {send "exit\r"}
EOF
[ $? -eq 0 ] && echo mysql密码修改成功,密码是:${passwdb} || echo 密码修改失败！

\cp -rf /root/git-hub/shell_test/conf/master.cnf /etc/my.cnf

read -p "设置主库ID编号：" id_a
read -p "设置主库binlog日志代号：" a_name
read -p "设置mysql端口号：" port_a
sed -i "s/server_id=1/server_id=${id_a}/" /etc/my.cnf
sed -i "s/log_bin=master/log_bin=${a_name}/" /etc/my.cnf
sed -i "s/port=4273/port=${port_a}/" /etc/my.cnf
systemctl restart mysqld

read -p "请输入你要允许那个ip同步本机的数据" ip_onlya
expect << EOF
spawn mysql -uroot -p
expect "password:"	{send "${passwdb}\r"}
expect "mysql>"		{send "GRANT REPLICATION SLAVE ON *.* TO 'slave'@'${ip_onlya}' IDENTIFIED BY 'slave1212';\r"}
expect "mysql>"		{send "GRANT REPLICATION SLAVE ON *.* TO 'slave'@'${ip_onlyb}' IDENTIFIED BY 'slave1212';\r"}
expect "mysql>"		{send "exit\r"}
EOF

m_binfile=`mysql -uroot -p${passwdb} -e "show master status\G"  2>/dev/null | awk '/File/{print $2}'`
m_posi=`mysql -uroot -p${passwdb} -e "show master status\G"  2>/dev/null | awk '/Position/{print $2}'`
echo -e "\033[42;37m bin文件名为:$m_binfile \033[0m"
echo -e "\033[42;37m posi位置为:$m_posi \033[0m"
chmod 777 /etc/rc.local
echo "systemctl start mysqld" >> /etc/rc.local
rm -rf /tmp/soft || rm -rf /tmp/softsoft11
