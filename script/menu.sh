#!/bin/bash
usera_chioce() {
read -p "请选择你要进行的操作
1) 检查服务器硬件信息
2) 设置主机名，设置登录root密码
3) 设置selinux和卸载firewalld
4) 修改时区并安装时间同步【服务端】
5) 修改时区并安装时间同步【客户端】
6) 修改服务器打开文件最大数
7) 修改ssh端口，设置远程登录限制
8) 安装宝塔面板
9) 安装mysql配置主库信息，设置开机自启
10) 安装mysql配置从库信息，设置开机自启
11) 安装redis服务，自定义端口，设置本地ip地址访问，设置开机自启
12) 安装nginx，配置调度器设置前端ip和开机自启
13) 安装zabbix客户端，并修改配置文件
14) 添加防火墙规则
15) 退出程序
请输入上面编号进行选择：" user_chioce
}
com_chioce() {
case ${user_chioce} in
1)
	bash /tmp/work/shell_test/script/check_server.sh
	continue;;
2)
	bash /tmp/work/shell_test/script/set_hostname.sh
	continue;;
3)
	bash /tmp/work/shell_test/script/set_selinuxfirewalld.sh
	continue;;
4)
	bash /tmp/work/shell_test/script/set_chronyserver.sh
	continue;;
5)
	bash /tmp/work/shell_test/script/set_chronydesk.sh
	continue;;
6)
	bash /tmp/work/shell_test/script/set_ulimit.sh
	continue;;
7)
	bash /tmp/work/shell_test/script/set_ssh.sh
	continue;;
8)
	bash /tmp/work/shell_test/script/install_bt.sh
	continue;;
9)
	bash /tmp/work/shell_test/script/install_masterdb.sh
	continue;;
10)
	bash /tmp/work/shell_test/script/install_slavedb.sh
	continue;;
11)
	bash /tmp/work/shell_test/script/install_redis.sh
	continue;;
12)
	bash /tmp/work/shell_test/script/install_nginx.sh
	continue;;
13)
	bash /tmp/work/shell_test/script/set_zabbix.sh
	continue;;
14)
	bash /tmp/work/shell_test/script/set_iptables.sh
	continue;;
15)

	rm -rf /tmp/work	
	exit;;
*)
	echo "输入格式不对！请输入数字！"
	sleep 1
esac
}
while :
do
	usera_chioce
	com_chioce
done
