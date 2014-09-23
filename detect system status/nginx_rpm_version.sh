#!/bin/bash

##############################
#检测Rpm安装方式Nginx的安装版本
##############################
updatedb

ENV_PATH=../env_config

#判断是否有rpm方式安装的nginx，没有的话退出该脚本

[ `rpm -qa | grep  nginx` ] ||  exit 1

#将nginx的版本赋值给"VERSION"变量

CMD=`rpm  -ql  nginx  |  grep  "\/nginx$"  |  grep  -E  "/usr/sbin/|/usr/bin/"`
$CMD  -v   &>  ./cache.tmp

VERSION=`cat  ./cache.tmp | awk  '{print $3}'`

rm  -rf   ./cache.tmp

#查看"Nginx_Rpm_Version"所在的行号

LINE_NUM=`grep  -n  "Nginx_Rpm_Version"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Nginx_Rpm_Version"行之后添加一行

sed  -ie  "/Nginx_Rpm_Version/a \'Nginx_Rpm_Version\':\'$VERSION\'" $ENV_PATH

#删除原来的"Nginx_Rpm_Version"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH






