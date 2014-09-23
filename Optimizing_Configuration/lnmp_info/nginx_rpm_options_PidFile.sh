#!/bin/bash

##############################
#检测Rpm安装方式Nginx的pid的路径
##############################
updatedb

ENV_PATH=../env_config

#判断是否有rpm方式安装的nginx，没有的话退出该脚本

[ `rpm -qa | grep  nginx` ] ||  exit 1


#将nginx的安装参数存放到cache.tmp文件中

CMD=`rpm  -ql  nginx  |  grep  "\/nginx$"  |  grep  -E  "/usr/sbin/|/usr/bin/"`
$CMD  -V   &>  ./cache.tmp


CONF=`cat  ./cache.tmp  | grep -i  "configure arguments"  |  awk -F  "--conf-path="  '{print  $2}'  |  awk  '{print  $1}'`

rm  -rf   ./cache.tmp

VALUE=`grep -v "#"   $CONF   |  grep  -iw  "pid"  | awk  '{print  $2}'  |  awk  -F ';'  '{print  $1}'`

LINE_NUM=`grep  -n  "Nginx_Rpm_PidFile"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Nginx_Rpm_PidFile"行之后添加一行

sed  -ie  "/Nginx_Rpm_PidFile/a \'Nginx_Rpm_PidFile\':\'$VALUE\'"   $ENV_PATH

#删除原来的"Nginx_Rpm_PidFile"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH

