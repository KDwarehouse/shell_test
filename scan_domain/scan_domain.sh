#!/bin/bash
source /root/df/shell_test/scan_domain/send_message.sh
URL_LIST=`awk '{print $1}' /root/df/shell_test/scan_domain/ce_url_list.txt`
DATE=`date +%F[%T]`
CURL_TEST() {
        status_code=`curl -o /dev/null  --retry 3 --retry-max-time 8 -s -w %{http_code} "${URL}"` 
        INFO_NAME=`grep ${URL} /root/df/shell_test/scan_domain/ce_url_list.txt | awk '{print $2}'`
        if [ ${status_code} -lt 200 -o ${status_code} -ge 400 ];then
                text="${DATE},${INFO_NAME}${URL}有问题，请检查!"
                send_message ${text}
        else    
                continue
        fi
}

for URL in ${URL_LIST}
do
	CURL_TEST &
done
wait
