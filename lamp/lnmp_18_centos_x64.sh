#!/bin/bash
# install nginx 1.5.8 mysql 5.5.28 php 5.5.7 for centos 6.3 x64

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 验证当前的用户是否为root账号，不是的话退出当前脚本
[ `id  -u`  == 0 ]  ||  echo "Error: You must be root to run this script, please use root to install lnmp"  ||  exit  1


pwd=`pwd`

chmod +x lnmp_scripts_for_centos_x64/*.sh
#数据盘初始化分区
./lnmp_scripts_for_centos_x64/initialize_disk.sh
#centos初始化
./lnmp_scripts_for_centos_x64/centos_env.sh

#Mysql Version
#5.5.28

#install mysql
./lnmp_scripts_for_centos_x64/mysql-5.5.28.sh
./lnmp_scripts_for_centos_x64/mysqldata.sh


#Nginx  Version
#1.5.8

./lnmp_scripts_for_centos_x64/nginx-1.5.8.sh

#PHP Version
#5.5.7

./lnmp_scripts_for_centos_x64/php_5.5.7.sh


#./lnmp_scripts_for_centos_x64/nginx-vhost.sh






