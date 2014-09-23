#!/bin/bash

##############################
#检查MAKE安装的Apache是否启用日志分割
##############################
updatedb

ENV_PATH=../env_config

#判断是否存在Make编译安装的Apahce主配置文件，没有的话退出本脚本

locate   "httpd.conf"  |  grep  -i  "\/conf\/httpd\.conf$" |  grep  -v  "\/etc\/httpd\/conf\/httpd.conf" |  grep  -vi "\/doc"  |  grep  -vi  "\/share\/"  |  grep -vi  "ln*mp*"  

[ `echo  $?` == 0 ] ||  exit 1

#查看编译安装的apache的主配置文件的路径

CONF=`locate   "httpd.conf"  |  grep  -i  "\/conf\/httpd\.conf$" |  grep  -v  "\/etc\/httpd\/conf\/httpd.conf" |  grep  -vi "\/doc"  |  grep  -vi  "\/share\/"  |  grep -vi  "ln*mp*"  `

#查看已加载ErrorLog设置中是否包含rotatelogs命令

/grep   -v  "^#"  $CONF  |  grep  -wi  "errorlog"  | grep  -iw  "rotatelogs"

#判断上一个命令的返回值，返回"0"表示安装了日志分割工具

if [ `echo  $?` == 0 ] 
then
	sed  -ie  "/Apache_Make_Log_Segmentation/a \'Apache_Make_Log_Segmentation\':\'On\'"  $ENV_PATH
else
	sed  -ie  "/Apache_Make_Log_Segmentation/a \'Apache_Make_Log_Segmentation\':\'Off\'" $ENV_PATH
fi
