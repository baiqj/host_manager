#!/bin/bash

##############################
#检测Rpm安装方式Nginx的运行组名称
##############################
updatedb

ENV_PATH=../env_config

#判断是否有rpm方式安装的nginx，没有的话退出该脚本

[ `rpm -qa | grep  nginx` ] ||  exit 1


#将nginx的安装参数存放到cache.tmp文件中

CMD=`rpm  -ql  nginx  |  grep  "\/nginx$"  |  grep  -E  "/usr/sbin/|/usr/bin/"`
$CMD  -V   &>  ./cache.tmp

VALUE=`cat  ./cache.tmp  | grep -i  "configure arguments"  |  awk -F  "--group="  '{print  $2}'  |  awk  '{print  $1}'`

rm  -rf   ./cache.tmp

LINE_NUM=`grep  -n  "Nginx_Rpm_Group"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Nginx_Rpm_Group"行之后添加一行

sed  -ie  "/Nginx_Rpm_Group/a \'Nginx_Rpm_Group\':\'$VALUE\'"   $ENV_PATH

#删除原来的"Nginx_Rpm_Group"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH

