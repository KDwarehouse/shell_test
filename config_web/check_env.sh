#!/bin/bash
read -p "输入你正在部署平台的名称:" name
before_env="/www/wwwroot/${name}/wx_before/.env"
bfswoole_env="/www/wwwroot/bfswoole/wx_bfswoole/.env"
back_env="/www/wwwroot/back/fh-back/.env"
chat_env="/www/wwwroot/chat-back/fh-chat/.env"
test_env="/www/wwwroot/test/wx_before/.env"

