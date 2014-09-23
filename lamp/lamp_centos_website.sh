#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 验证当前的用户是否为root账号，不是的话退出当前脚本
[ `id  -u`  == 0 ]  ||  echo "Error: You must be root to run this script, please use root to install lnmp"  ||  exit  1

pwd=`pwd`

#为脚本添加可执行权限
chmod +x lamp_scripts_for_website/*.sh

#根据config.list执行apache-vhost.sh创建vhost
./lamp_scripts_for_website/apache-vhost.sh











