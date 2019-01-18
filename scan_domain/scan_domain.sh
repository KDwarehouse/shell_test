#!/bin/bash
source /root/send_message.sh
URL_LIST=`awk '{print $1}' /root/ce_url_list.txt`
DATE=`date +%F[%T]`
#echo ${DATE}
for URL in ${URL_LIST}
do
	status_code=`curl -o /dev/null -s -w %{http_code} "${URL}"`
	INFO_NAME=`grep ${URL} /root/ce_url_list.txt | awk '{print $2}'`
	if [ ${status_code} -lt 200 -o ${status_code} -ge 400 ];then
		text="${DATE},${INFO_NAME}${URL}有问题，请检查!"
		send_message ${text}
	else
		continue
	fi
done
