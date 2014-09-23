#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi



echo "============================Install Nginx================================="

#检测系统是否有www用户，如果没有则添加该用户，如果有则不做处理
id   www
if  [ `echo  $?` != 0 ]
then
	groupadd www
	useradd -s /sbin/nologin -g www www
fi

mkdir -p /home/wwwroot/default
chmod +w /home/wwwroot/default
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

cd ../

\cp   ./conf/nginx/*        /usr/local/nginx/conf

chown   www:www  -R  /usr/local/nginx

ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx

#复制nginx的启动关闭重启脚本到/etc/init.d，将nginx加入开机启动

################
#Restarting  Nginx
################

/usr/bin/nginx
/usr/bin/nginx  -s  stop

