#!/bin/bash
#install nginx 1.5.8 on centos_6.3_x64
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 验证当前的用户是否为root账号，不是的话退出当前脚本
[ `id  -u`  == 0 ]  ||  echo "Error: You must be root to run this script, please use root to install lnmp"  ||  exit  1



echo "============================Install Nginx================================="
#检测系统是否有www用户，如果没有则添加该用户，如果有则不做处理
id   www
[ `echo  $?` != 0 ] &&  groupadd www ; useradd -s /sbin/nologin -g www www

mkdir -p /home/wwwroot/default
chown www:www /home/wwwroot/default
mkdir -p /home/wwwlogs
chown www:www /home/wwwlogs
touch /home/wwwlogs/nginx_error.log
chown -R www:www   /home/wwwroot/


cd ./packages
tar -zxvf pcre-8.12.tar.gz
cd pcre-8.12/
./configure
make && make install
cd ../

ldconfig

unzip mirrors-nginx-v1.5.8.zip 
 
cd nginx

./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-ipv6
make && make install

\cp    ../../conf/nginx/*        /usr/local/nginx/conf/

chown   www:www  -R  /usr/local/nginx

ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx

#启动nginx服务

/usr/bin/nginx

#设置nginx开机自启动

echo  "/usr/bin/nginx"  >>  /etc/rc.d/rc.local



