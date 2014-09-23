#!/bin/bash

##############################
#检测Rpm安装方式Nginx的安装目录
##############################
updatedb

ENV_PATH=../env_config

#判断是否有rpm方式安装的php，没有的话退出该脚本

[ `rpm  -q  nginx` ] ||  exit 1

CONF="/etc/nginx/nginx.conf"

#将nginx的安装参数存放到cache.tmp文件中

CMD=`rpm  -ql  nginx  |  grep  "\/nginx$"  |  grep  -E  "/usr/sbin/|/usr/bin/"`
$CMD  -V   &>  ./cache.tmp


DOCUMENT_PATH=`cat  ./cache.tmp  | grep -i  "configure arguments"  |  awk -F  "--prefix="  '{print  $2}'  |  awk  '{print  $1}'`

rm  -rf   ./cache.tmp

LINE_NUM=`grep  -n  "Nginx_Rpm_Installation_Directory"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Nginx_Rpm_Installation_Directory"行之后添加一行

sed  -ie  "/Nginx_Rpm_Installation_Directory/a \'Nginx_Rpm_Installation_Directory\':\'$DOCUMENT_PATH\'"   $ENV_PATH

#删除原来的"Nginx_Rpm_Installation_Directory"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH
