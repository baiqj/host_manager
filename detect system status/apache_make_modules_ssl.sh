#!/bin/bash

##############################
#检查MAKE安装的Apache是否加载ssl模块
##############################

updatedb

#判断是否存在Make编译安装的Apahce主配置文件，没有的话退出本脚本

locate   "httpd.conf"  |  grep  -i  "\/conf\/httpd\.conf$" |  grep  -v  "\/etc\/httpd\/conf\/httpd.conf" |  grep  -vi "\/doc"  |  grep  -vi  "\/share\/"  |  grep -vi  "ln*mp*"  

[ `echo  $?` == 0 ] ||  exit 1

#查看编译安装的apache的主配置文件的路径

CONF_PATH=`locate   "httpd.conf"  |  grep  -i  "\/conf\/httpd\.conf$" |  grep  -v  "\/etc\/httpd\/conf\/httpd.conf" |  grep  -vi "\/doc"  |  grep  -vi  "\/share\/"  |  grep -vi  "ln*mp*"  `

ENV_PATH=../env_config

#查看已加载module中是否包含php

CMD_PATH=`locate  apachectl  | grep "\/apachectl$"  |  grep  -v  "/usr/sbin/apachectl"`

$CMD  -t -D  DUMP_MODULES | awk  '{print $1}' |  grep  "ssl"

#判断上一个命令的返回值，返回"0"表示安装了php模块

if [ `echo  $?` == 0 ] 
then
	sed  -ie  "/Apache_Make_ssl/a \'Apache_Make_ssl\':\'On\'" $ENV_PATH
else
	sed  -ie  "/Apache_Make_ssl/a \'Apache_Make_ssl\':\'Off\'" $ENV_PATH
fi
