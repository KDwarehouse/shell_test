#!/bin/bash
awk  '{ip[$1]++} END{for(i in ip) {print ip[i],i}}' /root/gaun.com.log | sort -nr > /tmp/gaun.com.log
num_file=`awk '{print $1}' /tmp/gaun.com.log`
ip_file=`awk '{print $2}' /tmp/gaun.com.log`
a=`sed -n '$=' /tmp/gaun.com.log`

numa=`wc -l /tmp/gaun.com.log | awk '{print $1}'`
numb=$[numa/2]
#numc=`awk -v i=${numb} '{print $i} /tmp/gaun.com.log'`
numc=`sed -n "${numb}p" /tmp/gaun.com.log | awk '{print $1}'`
for i in ${num_file}
do
	if [ $i -gt $[numc+1500] ];then
		echo $i 
		b=`grep $i /tmp/gaun.com.log | awk '{print $2}'`
		c=`grep "$b" /root/df/shell_test/test/server_ip.txt |awk '{print $1}'`
		echo $c
	else
		continue
	fi
	
done
