#!/bin/bash
echo -e "\033[41;30m 警告：配置前，宝塔上安装nginx1.14，php7.1软件，禁用proc_open函数\033[0m"
read -p "请确认以上操作完成 y/n " DA

if [ $DA == 'n' ];then
    echo "请完成上述操作";exit
fi

mkdir /www/wwwroot/back/
cd /www/wwwroot/back/
git clone git@git.dohub.cn:laomumeme/fh-back.git
cd /www/wwwroot/back/fh-back/
git submodule init
git submodule update

\cp /www/wwwroot/back/fh-back/.env.example /www/wwwroot/back/fh-back/.env
chown -R www /www/wwwroot/back/fh-back/storage
chmod -R 775 /www/wwwroot/back/fh-back/storage
chown -R www /www/wwwroot/back/fh-back/bootstrap/cache
chmod -R 775 /www/wwwroot/back/fh-back/bootstrap/cache
chown -R www /www/wwwroot/back/fh-back/public/static
cd /www/wwwroot/back/fh-back/

cd /tmp/
wget http://pecl.php.net/get/swoole-4.3.1.tgz
tar zxvf swoole-4.3.1.tgz
cd swoole-4.3.1 && phpize
./configure --enable-openssl --with-php-config=/www/server/php/71/bin/php-config && make && make install


cd /www/wwwroot/back/fh-back/
composer install
php artisan key:generate

yum install python-setuptools
easy_install supervisor


cat <<EOF >/etc/supervisord.conf
[unix_http_server]
file=/var/run/supervisor.sock   ; UNIX socket 文件，supervisorctl 会使用

[supervisord]
logfile=/tmp/supervisord.log ; 日志文件，默认是 $CWD/supervisord.log
logfile_maxbytes=50MB        ; 日志文件大小，超出会 rotate，默认 50MB
logfile_backups=10           ; 日志文件保留备份数量默认 10
loglevel=info                ; 日志级别，默认 info，其它: debug,warn,trace
pidfile=/var/run/supervisord.pid ; pid 文件
nodaemon=false               ; 是否在前台启动，默认是 false，即以 daemon 的方式启动
minfds=1024                  ; 可以打开的文件描述符的最小值，默认 1024
minprocs=200                 ; 可以打开的进程数的最小值，默认 200

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///var/run/supervisor.sock ; 通过 UNIX socket 连接 supervisord，路径与 unix_http_server 部分的 file 一致

; 包含其他的配置文件
[include]
files = /usr/local/share/supervisor/*.conf
EOF

mkdir /usr/local/share/supervisor/
cat << EOF >/usr/local/share/supervisor/thread.conf
[program:swoole-thread]
command=php /www/wwwroot/back/fh-back/artisan swoole start
user=root
autostart=true
autorestart=true
numprocs=1
redirect_stderr=true
stdout_logfile=/tmp/swoole/thread.log
EOF

echo "请在php配置文件的1904行添加extension=swoole.so"
echo "请将每台上面的宝塔里面的文件回收站关掉"
echo "请将gameData.php上传到/www/wwwroot/back/fh-back/storage/app"

supervisord -c /etc/supervisord.conf
supervisorctl reload

supervisorctl restart swoole-thread

cat <<EOF >/etc/cron.d/back
0 1 * * * root mkdir /tmp/swoole;chown -R www /tmp/swoole;chmod -R 775 /tmp/swoole; > /tmp/swoole/crond.log
1 1 * * * cd /tmp/swoole/;rm -f *;
0 6 * * * root supervisorctl -c /etc/supervisord.conf restart swoole-thread > /tmp/swoole/crond.log
EOF
systemctl restart crond.service

cd /usr/lib/systemd/system/
cat <<EOF >supervisord.service
[Unit]
Description=Supervisor daemon

[Service]
Type=forking
ExecStart=/usr/bin/supervisord -c /etc/supervisord.conf
ExecStop=/usr/bin/supervisorctl shutdown
ExecReload=/usr/bin/supervisorctl reload
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target
EOF
systemctl enable supervisord
