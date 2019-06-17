#!/bin/bash
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
if [ -d /tmp/soft ];then
        mkdir /tmp/softsoft11
        cd /tmp/softsoft11
        yum -y install autoconf perl-JSON perl wget expect
        yum -y remove mariadb*
        wget https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.24-1.el7.x86_64.rpm-bundle.tar
        tar xf mysql-5.7.24-1.el7.x86_64.rpm-bundle.tar
	mv mysql-community-server-minimal-5.7.24-1.el7.x86_64.rpm /tmp
	rm -rf mysql-5.7.24-1.el7.x86_64.rpm-bundle.tar
	yum -y install mysql-community-*.rpm
	systemctl start mysqld
else
        mkdir /tmp/soft
        cd /tmp/soft
        yum -y install autoconf perl-JSON perl wget expect
        yum -y remove mariadb*
        wget https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.24-1.el7.x86_64.rpm-bundle.tar
        tar xf mysql-5.7.24-1.el7.x86_64.rpm-bundle.tar
	mv mysql-community-server-minimal-5.7.24-1.el7.x86_64.rpm /tmp
	rm -rf mysql-5.7.24-1.el7.x86_64.rpm-bundle.tar
	yum -y install mysql-community-*.rpm
	systemctl start mysqld
fi
ss -nutlp | grep mysqld
if [ $? -eq 0 ];then
        echo "mysql安装已经完成！"
else
        echo "mysql安装失败！"
fi
\cp -rf /tmp/work/shell_test/conf/slave.cnf /etc/my.cnf
read -p "请输入你要创建的密码：" passwdb
passwda=`awk '/password/{print $NF}' /var/log/mysqld.log`
expect <<  EOF
spawn mysql -uroot  -p
expect "password:" {send "${passwda}\r"}
expect "mysql>" {send "SET PASSWORD FOR root@localhost=PASSWORD('${passwdb}');\r"}
expect "mysql>" {send "exit\r"}
EOF
[ $? -eq 0 ] && echo mysql密码修改成功,密码是:${passwdb} || echo 密码修改失败！
read -p "设置从库ID编号：" id_a
read -p "设置库binlog日志代号：" a_name
read -p "设置mysql端口号：" port_a
sed -i "s/server_id=1/server_id=${id_a}/" /etc/my.cnf
sed -i "s/log_bin=master/log_bin=${a_name}/" /etc/my.cnf
sed -i "s/port=4273/port=${port_a}/" /etc/my.cnf
systemctl restart mysqld
read -p "主库bin文件名为:" m_bin
read -p "主库position位置为:" m_position
read -p "主库内网ip：" m_ip
read -p "主库mysql端口：" m_port
mysql -uroot -p${passwdb} -e "change master to master_host='$m_ip',master_port=$m_port,master_user='slave',master_password='slave1212',master_log_file='$m_bin',master_log_pos=$m_position;"
mysql -uroot -p${passwdb} -e "start slave;" && echo 从库启动中
sleep 10
slave_status=`mysql -uroot -p${passwdb} -e "show slave status\G" 2>/dev/null | grep Yes |wc -l`
if [ "$slave_status" -eq 2 ] ;then
   echo "从库配置成功"
else
   echo "从库配置失败请检查"
fi
echo "systemctl start mysqld" >> /etc/rc.local
chmod 777 /etc/rc.local
rm -rf /tmp/soft || rm -rf /tmp/softsoft11
