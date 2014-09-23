#!/bin/bash


PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lamp"
    exit 1
fi

pwd=`pwd`

chmod +x ./lamp_scripts_for_ubuntu_x64/*.sh
#系统初始化检测
#云主机数据盘自动分区
cat "running initialize_disk.sh" >>install_log
./lamp_scripts_for_ubuntu_x64/initialize_disk.sh
#对centos进行初始化
cat "running centos_env.sh">>install_log
./lamp_scripts_for_ubuntu_x64/ubuntu_env.sh

#Mysql Version
#5.5.28

#install mysql 5.5.28
cat "running mysql-5.5.28.sh" >> install_log
./lamp_scripts_for_ubuntu_x64/mysql_5.5.28.sh
cat "running mysqldata.sh" >> install_log
./lamp_scripts_for_ubuntu_x64/mysqldata.sh


#Apache Version
#2.2.22
cat "running apache-2.2.22.sh" >>install_log
./lamp_scripts_for_ubuntu_x64/apache_2.2.22.sh

#PHP Version
#5.5.7
cat "running php_5.5.7.sh" >>install_log
./lamp_scripts_for_ubuntu_x64/php_5.5.7.sh


#./lamp_scripts_for_ubuntu_x64/apache-vhost.sh






