#!/bin/bash

##############################
#检查MAKE安装的Apache是否加载expires模块
##############################

updatedb

#注意主配置文件所在的路径不包含关键字："/etc/httpd/conf/httpd.conf" |"share"|"doc"|"ln*mp*"等

locate   "httpd.conf"  |  grep  -i  "\/conf\/httpd\.conf$" |  grep  -v  "\/etc\/httpd\/conf\/httpd.conf" |  grep  -vi "\/doc"  |  grep  -vi  "\/share\/"  |  grep -vi  "ln*mp*"  

#判断是否存在编译安装生成的httpd.conf文件，没有的话退出当前脚本
[  `echo  $?`  ==  0 ]   ||  exit  1

#定位主配置文件的路径
CONF=`locate   "httpd.conf"  |  grep  -i  "\/conf\/httpd\.conf$" |  grep  -v  "\/etc\/httpd\/conf\/httpd.conf" |  grep  -vi "\/doc"  |  grep  -vi  "\/share\/"  |  grep -vi  "ln*mp*"`
#定位安装目录
ServerRoot=`grep   -iw  "serverroot"   $CONF |  grep  -v  "^#"  |  awk  '{print $2}'  |  awk  -F  '"'  '{print  $2}'`

ENV_PATH=../env_config

#查看已加载module中是否包含php

CMD_PATH=`locate  apachectl  | grep "\/apachectl$"  |  grep  -v  "/usr/sbin/apachectl"`

$CMD  -t -D  DUMP_MODULES | awk  '{print $1}' |  grep  "expires"

#判断上一个命令的返回值，返回"0"表示安装了php模块

if [ `echo  $?` == 0 ] 
then
	sed  -ie  "/Apache_Make_mod_expires/a \'Apache_Make_mod_expires\':\'On\'" $ENV_PATH
else
	sed  -ie  "/Apache_Make_mod_expires/a \'Apache_Make_mod_expires\':\'Off\'" $ENV_PATH
fi
