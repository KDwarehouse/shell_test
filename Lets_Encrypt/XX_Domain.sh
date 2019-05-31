#!/bin/bash
#清除上次操作遗留痕迹
>/root/Lets_Encrypt/Conf/DnsPod_User_ListToken.txt
>/root/Lets_Encrypt/Json/DnsPod_User_ListToken.json
>/root/Lets_Encrypt/Json/Over_Domain.json

#获取DnsPod账号信息&获取Domain信息
bash /root/Lets_Encrypt/DnsPod_User_Token.sh
bash /root/Lets_Encrypt/Domain.sh

read -p "请输入域名：" domain_name
tmp=${domain_name#*.} #截取主域名

#获取此主域名属于那个DnsPod账号，并输出该账号的Token
dnspod_user=`grep -A 15 ${tmp} /root/Lets_Encrypt/Json/Over_Domain.json | awk '/"owner"/{print $2}' | sed 's/"//g'`
num=`grep -n "${dnspod_user}" /root/Lets_Encrypt/Conf/DnsPod_User_List.txt | awk -F: '{print $1}'`
user_token=`awk -v b=${num} 'NR == b' /root/Lets_Encrypt/Conf/DnsPod_User_ListToken.txt`

#获取该主域名的id
domain_id=`grep -B 2 ${tmp} /root/Lets_Encrypt/Json/Over_Domain.json | awk '/"id"/{print $2}' | sed 's/,//g'`

#获取TXT记录相对应的值
/root/.acme.sh/acme.sh --issue -d "*.${tmp}" --dns --yes-I-know-dns-manual-mode-enough-go-ahead-please
over_sub_domain=`/root/.acme.sh/acme.sh --issue -d ${domain_name} --dns --yes-I-know-dns-manual-mode-enough-go-ahead-please 2> /dev/null | awk '/Domain:/{print $8}' | sed "s/'//g"`
sub_domain=${over_sub_domain%.${domain_name}*}
value=`/root/.acme.sh/acme.sh --issue -d "*.${tmp}" --dns --yes-I-know-dns-manual-mode-enough-go-ahead-please 2> /dev/null | awk '/TXT\ value:/{print $9}' | sed "s/'//g"`


grep ${tmp} /root/Lets_Encrypt/Json/Over_Domain.json > /dev/null
if [ $? -ne 0 ];then
	echo "此域名没有记录在DnsPod里，请手动添加"
else
	ls /root/Lets_Encrypt/SSL/ | egrep "*.${tmp}" > /dev/null
	if [ $? -eq 0 ];then
		echo "*.${tmp}证书已经生成好，无需在申请"
	else
		curl -X POST https://api.dnspod.com/Record.Create -d "user_token=${user_token}&format=json&domain_id=${domain_id}&sub_domain=${sub_domain}&record_type=TXT&record_line=default&value=${value}"
		if [ $? -eq 0 ];then
			/root/.acme.sh/acme.sh --renew -d "*.${tmp}" --dns --yes-I-know-dns-manual-mode-enough-go-ahead-please
			/root/.acme.sh/acme.sh --installcert -d "*.${tmp}" --key-file /root/Lets_Encrypt/SSL/*.${tmp}.key --fullchain-file /root/Lets_Encrypt/SSL/*.${tmp}.cer
			tmpa=`du -sh /root/Lets_Encrypt/SSL/*.${tmp}.cer | awk '{print $1}'`
			if [ ${tmpa} != 0 ];then
				echo "证书申请成功"
			else
				echo "证书申请失败"
			fi
		fi
	fi
fi
