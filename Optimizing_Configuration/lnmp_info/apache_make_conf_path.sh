#!/bin/bash

##############################
#检测Make安装方式Apache主配置文件的路径
##############################
updatedb

ENV_PATH=../env_config

#判断是否存在Make编译安装的Apahce主配置文件，没有的话退出本脚本

locate   "httpd.conf"  |  grep  -i  "\/conf\/httpd\.conf$" |  grep  -v  "\/etc\/httpd\/conf\/httpd.conf" |  grep  -vi "\/doc"  |  grep  -vi  "\/share\/"  |  grep -vi  "ln*mp*"  

[ `echo  $?` == 0 ] ||  exit 1

#查看编译安装的apache的主配置文件的路径

CONF=`locate   "httpd.conf"  |  grep  -i  "\/conf\/httpd\.conf$" |  grep  -v  "\/etc\/httpd\/conf\/httpd.conf" |  grep  -vi "\/doc"  |  grep  -vi  "\/share\/"  |  grep -vi  "ln*mp*"  `


LINE_NUM=`grep  -n  "Apache_Make_Conf_Path"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Apache_Make_Conf_Path"行之后添加一行

sed  -ie  "/Apache_Make_Conf_Path/a \'Apache_Make_Conf_Path\':\'$CONF\'"   $ENV_PATH

#删除原来的"Apache_Make_Conf_Path"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH




