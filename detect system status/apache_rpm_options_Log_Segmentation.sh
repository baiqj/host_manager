#!/bin/bash

##############################
#检查RPM安装的Apache是否启用日志分割
##############################

updatedb

ENV_PATH=../env_config

#查看已加载ErrorLog设置中是否包含rotatelogs命令

/grep   -v  "^#"  /etc/httpd/conf/httpd.conf  |  grep  -wi  "errorlog"  | grep  -iw  "rotatelogs"

#判断上一个命令的返回值，返回"0"表示安装了php模块

if [ `echo  $?` == 0 ] 
then
	sed  -ie  "/Apache_Rpm_Log_Segmentation/a \'Apache_Rpm_Log_Segmentation\':\'On\'"  $ENV_PATH
else
	sed  -ie  "/Apache_Rpm_Log_Segmentation/a \'Apache_Rpm_Log_Segmentation\':\'Off\'" $ENV_PATH
fi
