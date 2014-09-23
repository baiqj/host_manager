#!/bin/bash


PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 验证当前的用户是否为root账号，不是的话退出当前脚本
[ `id  -u`  == 0 ]  ||  echo "Error: You must be root to run this script, please use root to install lnmp"  ||  exit  1

pwd=`pwd`

chmod +x lamp_scripts_for_centos_x64/*.sh
#系统初始化检测
#云主机数据盘自动分区

./lamp_scripts_for_centos_x64/initialize_disk.sh
#对centos进行初始化

./lamp_scripts_for_centos_x64/centos_env.sh

#Mysql Version
#5.5.28

#install mysql 5.5.28

./lamp_scripts_for_centos_x64/mysql-5.5.28.sh

./lamp_scripts-for_centos_x64/mysqldata.sh


#Apache Version
#2.2.22

./lamp_scripts_for_centos_x64/apache-2.2.22.sh

#PHP Version
#5.5.7

./lamp_scripts_for_centos_x64/php_5.5.7.sh

echo "the apache + php + mysql install is finished!"
echo "the apache version is 2.2.22"
echo "the php version is 5.5.7"
echo "the mysql version is 5.5.28"







