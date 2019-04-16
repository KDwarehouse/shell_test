#!/bin/bash
echo -e "\033[41;30m 警告：配置前，宝塔上安装nginx1.14，php7.1软件，禁用proc_open函数\033[0m"

read -p '请确认以上操作已经完成  y/n : ' a
if [ ! $a == 'y' ];then
echo '终止运行';exit
fi

read -p "输入搭建平台的名称：" name
read -p "输入需要克隆前台仓库的代号：" git_name


git config --global credential.helper store
mkdir /www/wwwroot/${name}/
cd /www/wwwroot/${name}/
git clone root@gogs.dohub.cn:laomumeme/wx_before.git
cd /www/wwwroot/${name}/wx_before
git submodule init
git submodule update

\cp /www/wwwroot/${name}/wx_before/.env.example /www/wwwroot/${name}/wx_before/.env
chown -R www /www/wwwroot/${name}/wx_before/storage
chmod -R 775 /www/wwwroot/${name}/wx_before/storage
chown -R www /www/wwwroot/${name}/wx_before/bootstrap/cache
chmod -R 775 /www/wwwroot/${name}/wx_before/bootstrap/cache
mkdir /www/wwwroot/${name}/wx_before/public/staticimg
chown -R www /www/wwwroot/${name}/wx_before/public/staticimg
chmod -R 775 /www/wwwroot/${name}/wx_before/public/staticimg
mkdir /www/wwwroot/${name}/wx_before/public/dobet/
chown -R www /www/wwwroot/${name}/wx_before/public/dobet/
cd /www/wwwroot/${name}/wx_before

echo "添加站点如:c70.com 选择网站根目录/www/wwwroot/c70/wx_before，先配置伪静态默认为laravel5;配置网站的运行目录为/public"
echo "此站点中的env请拷贝前台01的env"
echo -e "\033[41;30m 警告：在安装composer前需要进入宝塔删除有中文字的地方，否则会报错！！！\033[0m"

composer install

mkdir /www/wwwroot/${name}/wx_before/public/web
mkdir /www/wwwroot/${name}/wx_before/public/m
cd /www/wwwroot/${name}/wx_before/public/web
git init
git remote add origin root@gogs.dohub.cn:laomumeme/${git_name}-home.git
git pull origin master
cd /www/wwwroot/${name}/wx_before/public/m
git init
git remote add origin root@gogs.dohub.cn:laomumeme/${git_name}-home-m.git
git pull origin master


cd /www/wwwroot/${name}/wx_before/public/
ln -s /www/wwwroot/${name}/wx_before/public/web/static/ static
ln -s /www/wwwroot/${name}/wx_before/public/web/favicon.ico favicon.ico
mkdir /www/wwwroot/${name}/wx_before/public/web/static/m
mkdir /www/wwwroot/${name}/wx_before/public/web/static/flexible

\cp /www/wwwroot/${name}/wx_before/public/m/static/js/* /www/wwwroot/${name}/wx_before/public/web/static/js/
\cp /www/wwwroot/${name}/wx_before/public/m/static/css/* /www/wwwroot/${name}/wx_before/public/web/static/css/
\cp /www/wwwroot/${name}/wx_before/public/m/static/m/* /www/wwwroot/${name}/wx_before/public/web/static/m/
\cp /www/wwwroot/${name}/wx_before/public/m/static/img/* /www/wwwroot/${name}/wx_before/public/web/static/img/
\cp /www/wwwroot/${name}/wx_before/public/m/static/flexible/* /www/wwwroot/${name}/wx_before/public/web/static/flexible/


mkdir /www/wwwroot/${name}/wx_before/public/magent
cd /www/wwwroot/${name}/wx_before/public/magent
git init
git remote add origin root@gogs.dohub.cn:laomumeme/wx_agent_m.git
git pull origin master


\cp /www/wwwroot/${name}/wx_before/public/magent/static/js/* /www/wwwroot/${name}/wx_before/public/web/static/js/
\cp /www/wwwroot/${name}/wx_before/public/magent/static/css/* /www/wwwroot/${name}/wx_before/public/web/static/css/
\cp /www/wwwroot/${name}/wx_before/public/magent/static/img/* /www/wwwroot/${name}/wx_before/public/web/static/img/
\cp /www/wwwroot/${name}/wx_before/public/magent/static/flexible/* /www/wwwroot/${name}/wx_before/public/web/static/flexible/
