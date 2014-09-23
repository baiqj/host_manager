#!/bin/bash

##############################
#检查RPM安装的Apache是否加载security模块
##############################

updatedb

ENV_PATH=../env_config

#查看已加载module中是否包含php

/usr/sbin/apachectl  -t -D  DUMP_MODULES | awk  '{print $1}' |  grep  "security"

#判断上一个命令的返回值，返回"0"表示安装了php模块

if [ `echo  $?` == 0 ] 
then
	sed  -ie  "/Apache_Rpm_mod_security/a \'Apache_Rpm_mod_security\':\'On\'" $ENV_PATH
else
	sed  -ie  "/Apache_Rpm_mod_security/a \'Apache_Rpm_mod_security\':\'Off\'" $ENV_PATH
fi
