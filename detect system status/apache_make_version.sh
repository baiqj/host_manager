#!/bin/bash

##############################
#检测Make编译安装方式Apache的安装版本
##############################
updatedb

ENV_PATH=../env_config

#判断是否存在Make编译安装的Apahce主配置文件，没有的话退出本脚本

locate   "httpd.conf"  |  grep  -i  "\/conf\/httpd\.conf$" |  grep  -v  "\/etc\/httpd\/conf\/httpd.conf" |  grep  -vi "\/doc"  |  grep  -vi  "\/share\/"  |  grep -vi  "ln*mp*"  

[ `echo  $?` == 0 ] ||  exit 1

#查看编译安装的apache的主配置文件的路径

CONF=`locate   "httpd.conf"  |  grep  -i  "\/conf\/httpd\.conf$" |  grep  -v  "\/etc\/httpd\/conf\/httpd.conf" |  grep  -vi "\/doc"  |  grep  -vi  "\/share\/"  |  grep -vi  "ln*mp*"  `

#查看make编译安装的apachectl命令路径

CMD=`locate  apachectl  | grep  "\/apachectl$"  | grep  -v "/usr/sbin"`

#将apache的版本赋值给"VERSION"变量

VERSION=`$CMD  -v | grep  -i "version"  | awk  '{print $3}'`

#查看"Apache_Make_Version"所在的行号

LINE_NUM=`grep  -n  "Apache_Make_Version"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Apache_Make_Version"行之后添加一行

sed  -ie  "/Apache_Make_Version/a \'Apache_Make_Version\':\'$VERSION\'" $ENV_PATH

#删除原来的"Apache_Make_Version"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH






