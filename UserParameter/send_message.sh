#!/bin/bash
function send_message(){
        tele_token='871414905:AAEaJ1cMVH0zP7vHGOhzxngZV_kBkZR8o9M'
        chat_id='-326718089'
        text="<b>Zabbix警告</b>: "$1
        curl  "https://api.telegram.org/bot${tele_token}/sendMessage?chat_id=${chat_id}&text=${text}&parse_mode=html"
}
