#!/bin/bash
read -p "请输入你的选择(s代表石头,j代表剪刀,b代表布)!
s/j/b)" user_chioce
case ${user_chioce} in 
s)
	echo "你选择了石头！"
	user_num=1;;
j)
	echo "你选择了剪刀！"
	user_num=2;;
b)
	echo "你选择了布！"
	user_num=3;;
*)
	echo "你输入的不正确！"
	sleep 1
	exit
esac
com_num=$[RANDOM%3 +1]
if [ $com_num -eq 1 ];then
	echo "电脑选择了石头！"
	if [ $user_num -eq 1 ];then
		echo "平局"
	elif [ $user_num -eq 2 ];then
		echo "输了"
	elif [ $user_num -eq 3 ];then
		echo "赢了"
	fi
elif [ $com_num -eq 2 ];then
	echo "电脑选择了剪刀！"
	if [ $user_num -eq 1 ];then
                echo "赢了"
        elif [ $user_num -eq 2 ];then
                echo "平局"
        elif [ $user_num -eq 3 ];then
                echo "输了"
        fi
else
	echo "电脑选择了布！"
	if [ $user_num -eq 1 ];then
                echo "输了"
        elif [ $user_num -eq 2 ];then
                echo "赢了"
        elif [ $user_num -eq 3 ];then
                echo "平局"
        fi
fi

