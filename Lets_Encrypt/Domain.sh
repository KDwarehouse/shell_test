#!/bin/bash
rpm -qa jq
if [ $? -ne 0 ];then
	yum -y install jq
fi
DnsNum=`sed -n '$=' /root/Lets_Encrypt/Conf/DnsPod_User_ListToken.txt`
for i in `seq ${DnsNum}`
do
	a=`awk -v  a=${i} 'NR == a {print $1}' /root/Lets_Encrypt/Conf/DnsPod_User_ListToken.txt`
	curl -X POST https://api.dnspod.com/Domain.List -d "user_token=${a}&format=json" | jq . >> /root/Lets_Encrypt/Json/Over_Domain.json
done
