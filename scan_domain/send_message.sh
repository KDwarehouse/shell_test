#!/bin/bash
function send_message(){
        # main机器人token
        #tele_token='748091669:AAHH0lF3qVj4hD5qHFp4qQowyqbAwdh67xU'
        #group_id='-390922010'
        #测试chat_id
        tele_token='619423079:AAFPQuGFbCwH8O3jSefntGa8rd0Tr_Wq_zs'
        group_id='-342008533'
        text="<b>angry发现</b> »> "$1
        curl -g "https://api.telegram.org/bot${tele_token}/sendMessage?chat_id=${group_id}&text=${text}&parse_mode=html"
}
