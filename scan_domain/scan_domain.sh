#!/bin/bash
source /root/df/shell_test/scan_domain/send_message.sh
URL_LIST=`awk '{print $1}' /root/df/shell_test/scan_domain/ce_url_list.txt`
DATE=`date +%F[%T]`

CURL_HOST() {
	#ping域名主机是否通畅
	#ping -c 3 -i 0.2 -W 1 ${URL} &> /dev/null
	#if [ $? -eq 0 ];then
		#curl请求网站的状态码
		INFO_NAME=`grep ${URL} /root/df/shell_test/scan_domain/ce_url_list.txt | awk '{print $2}'`
        	status_code=`curl -o /dev/null  --retry 3 --retry-max-time 8 -s -w %{http_code} "${URL}"`
		
		if [ ${status_code} -lt 200 -o ${status_code} -ge 400 ];then
                	#wget下载网页页面
        		wget -t 2 -T 5 --spider "${URL}" &> /dev/null	
			if [ $? -ne 0 ];then
				text="${DATE},${INFO_NAME}${URL}有问题，请检查!"
                		send_message ${text}
        		else
                		continue
        		fi
		else
			continue
		fi
	#else
		#text="${DATE},${INFO_NAME}${URL}有问题，请检查!"
                #send_message ${text}
	#fi
}

for URL in ${URL_LIST}
do
	CURL_HOST &
done
wait
