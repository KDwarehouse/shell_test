#!/bin/bash
usera_chioce() {
read -p "请选择你要进行的操作
1) 申请二级域名证书
2) 申请泛域名证书
3) 申请主域名证书
4) 退出程序
请输入上面编号进行选择：" user_chioce
}
com_chioce() {
case ${user_chioce} in
1)
        bash /root/Lets_Encrypt/Second_Level_Domain.sh
        continue;;
2)
        bash /root/Lets_Encrypt/XX_Domain.sh
        continue;;
3)
        bash /root/Lets_Encrypt/Z_Domain.sh
        continue;;
4)
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

