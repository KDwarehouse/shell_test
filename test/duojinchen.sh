#!/bin/bash
Njob=15
for i in `seq ${Njob}`
do
	echo "progress $i is sleeping for 3 seconds zzz…"
sleep 3 & #循环内容放到后台执行
done
wait #等待循环结束再执行wait后面的内容
echo -e "time-consuming: $SECONDS seconds" #显示脚本执行耗时
