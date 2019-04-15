#!/bin/bash
usera_chioce() {
read -p "请选择你要进行的操作：
1) 前台01配置
2) 前台02配置
3) 后台配置
4) 聊天室配置
5) 异步任务配置
6) 定时任务配置
7) 测试机配置
8) speed配置
9) app配置
10) nav配置
11) 退出程序
请输入上面编号进行选择：" user_chioce
}
com_chioce() {
case ${user_chioce} in
1)
	bash /tmp/work/shell_test/script/configure_before01.sh
	continue;;
2)
	bash /tmp/work/shell_test/script/configure_before02.sh
	continue;;
3)
    bash /tmp/work/shell_test/script/configure_back.sh
	continue;;
4)
	bash /tmp/work/shell_test/script/configure_chat.sh
	continue;;
5)
	bash /tmp/work/shell_test/script/configure_bfswoole.sh
	continue;;
6)
	bash /tmp/work/shell_test/script/configure_time.sh
	continue;;
7)
	bash /tmp/work/shell_test/script/configure_test.sh
	continue;;
8)
	bash /tmp/work/shell_test/script/configure_speed.sh
	continue;;
9)
	bash /tmp/work/shell_test/script/configure_app.sh
	continue;;
10)
	bash /tmp/work/shell_test/script/configure_nav.sh
	continue;;
11)
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
