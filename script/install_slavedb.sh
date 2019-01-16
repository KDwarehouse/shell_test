#!/bin/bash
mkdir /tmp/soft
cd /tmp/soft
yum -y install autoconf perl-JSON wget expect
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
passwda=`awk -F: '{print $4}' /root/.mysql_secret`
mysql -uroot -p${passwda} -e "set password=password('$passwdb')"

rm -rf /usr/my.cnf
cp /tmp/work/shell_test/conf/slave.cnf /usr/my.cnf

read -p "设置从库ID编号：" id_a
read -p "设置库binlog日志代号：" a_name
read -p "设置mysql端口号：" port_a
sed -i "s/server_id=1/server_id=${id_a}/" /usr/my.cnf
sed -i "s/log_bin=master/log_bin=${a_name}/" /usr/my.cnf
sed -i "s/port=4273/port=${port_a}/" /usr/my.cnf

systemctl restart mysql


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
