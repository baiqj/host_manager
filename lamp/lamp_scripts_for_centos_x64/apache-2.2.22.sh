#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 验证当前的用户是否为root账号，不是的话退出当前脚本
[ `id  -u`  == 0 ]  ||  echo "Error: You must be root to run this script, please use root to install lnmp"  ||  exit  1

#检测系统是否有www用户，如果没有则添加该用户，如果有则不做处理
id  www
[  `echo $?`  ==  0  ]  ||  groupadd www ; useradd -s /sbin/nologin -g www www

cd ./packages
tar zxvf httpd-2.2.22.tar.gz
cd httpd-2.2.22/
./configure --prefix=/usr/local/apache --enable-so  --enable-rewrite
make && make install


#回到根目录
cd  ../../
rm  -rf  ./packages/httpd-2.2.22

\cp   -rpv   conf/httpd.conf  /usr/local/apache/conf/httpd.conf

mkdir -p /usr/local/apache/conf/vhost

chown  www:www  -R  /usr/local/apache

#设置apache开机启动
rpm  -ivh    ./packages/dos2unix-3.1-37.el6.x86_64.rpm

\cp   -rpv   ./conf/apache   /etc/init.d/
dos2unix     /etc/init.d/apache
chmod  +x   /etc/init.d/apache

chkconfig  apache  --add
chkconfig  apache  on

service  apache  start




