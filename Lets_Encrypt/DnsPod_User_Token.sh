#!/bin/bash
DnsNum=`sed -n '$=' /root/Lets_Encrypt/Conf/DnsPod_User_List.txt`
for i in `seq ${DnsNum}`
do
	a=`awk -v  a=${i} 'NR == a {print $1}' /root/Lets_Encrypt/Conf/DnsPod_User_List.txt`
	b=`awk -v  b=${i} 'NR == b {print $2}' /root/Lets_Encrypt/Conf/DnsPod_User_List.txt`
	curl -X POST https://api.dnspod.com/Auth -d "login_email=${a}&login_password=${b}&format=json" | jq . >> /root/Lets_Encrypt/Json/DnsPod_User_ListToken.json
done
grep "user_token" /root/Lets_Encrypt/Json/DnsPod_User_ListToken.json | awk '{print $2}' | sed 's/"//g' >> /root/Lets_Encrypt/Conf/DnsPod_User_ListToken.txt
