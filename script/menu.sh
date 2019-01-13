#!/bin/bash
read -p "请选择你要进行的操作
1) 检查服务器硬件信息
2) 设置selinux和卸载firewalld
3) 修改时区并安装时间同步【服务端】
4) 修改时区并安装时间同步【客户端】
5) 安装宝塔
6) 安装mysql并设置开机自启
7) 安装nginx并设置开机自启
8) 安装redi并设置开机自启
9) 安装zabbix客户端
10) 设置文件最大打开数量
11) 添加防火墙规则
12) 退出程序
请输入上面编号进行选择：" user_chioce
chioce() {
case ${user_chioce} in
1)
	bash /tmp/work/shell_test/script/check_server.sh;;
2)
	bash /tmp/work/shell_test/script/set_selinuxfirewalld.sh;;
3)
	bash /tmp/work/shell_test/script/set_chronyserver.sh;;
4)
	bash /tmp/work/shell_test/script/set_chronydesk.sh;;
5)
	bash /tmp/work/shell_test/script/install_bt.sh;;
6)
	bash /tmp/work/shell_test/script/install_mysql.sh;;
7)
	bash /tmp/work/shell_test/script/install_nginx.sh;;
8)
	bash /tmp/work/shell_test/script/install_redis.sh;;
9)
	bash /tmp/work/shell_test/script/set_zabbixagent.sh;;
10)
	bash /tmp/work/shell_test/script/set_ulimit.sh;;
11)
	bash /tmp/work/shell_test/script/set_iptables.sh;;
12)
	exit;;
*)
	echo "输入格式不对！请输入数字！"
	sleep 1
esac
}
while :
do
	chioce
done
