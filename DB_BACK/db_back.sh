#!/bin/bash
#使用innobackupex进行完全+增量备份
#定义下面代码使用的变量
db_user=root
db_passwd=avy0,.s0Ytfh
all_dir=/dbbackup/all_backup
incremental_dir=/dbbackup/incremental
new_incremental_dir=`ls -rtl ${incremental_dir}  | tail -1 | awk  '{print $NF}'`
#一、安装提供innobackupex命令的软件包percona-xtrabackup
if [ ! -f /usr/bin/innobackupex ];then
	wget -P /tmp https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.4/binary/redhat/7/x86_64/percona-xtrabackup-24-2.4.4-1.el7.x86_64.rpm
	yum -y install /tmp/percona-xtrabackup-24-2.4.4-1.el7.x86_64.rpm
fi
#二、判断数据库是否正常运行，主从是否成功
db_status=`systemctl status mysqld | awk '/Active/{print $3}'| sed 's/[()]//g'`
IO_status=`mysql -u${db_user} -p${db_passwd} -e "show slave status\G;" 2> /dev/null | awk '/Slave_IO_Running:/{print $NF}'`
SQL_status=`mysql -u${db_user} -p${db_passwd} -e "show slave status\G;" 2> /dev/null | awk '/Slave_SQL_Running:/{print $NF}'`
if [ ${db_status} = 'running' ];then
	if [ ${IO_status} = 'Yes' -a ${SQL_status} = 'Yes' ];then
		echo "数据库运行正常，主从正常"
	else
		echo "数据库运行正常，主从错误，请修复"
		exit
	fi
else
	echo "数据库运行错误，请修复"
	exit
fi

#完全备份
function all_back(){
	innobackupex --user ${db_user} --password ${db_passwd} ${all_dir} --no-timestamp
}

#第一次增量备份
function first_back(){
	innobackupex --user ${db_user} --password ${db_passwd} --incremental ${incremental_dir}  --incremental-basedir=${all_dir}
}

#多次增量备份
function many_back(){
	innobackupex --user ${db_user} --password ${db_passwd} --incremental ${incremental_dir}  --incremental-basedir=${incremental_dir}/${new_incremental_dir}
}

#三、判断当前该执行那种备份
if [ ! -d ${all_dir} ];then
	all_back
elif [ ! -d ${incremental_dir} ];then
	first_back
else
	many_back
fi
