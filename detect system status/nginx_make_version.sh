#!/bin/bash

##############################
#检测Make编译安装方式Nginx的安装版本
##############################
updatedb

ENV_PATH=../env_config

#查看make编译安装的nginx命令路径

CMD=`locate nginx   |  grep  "\/nginx$"    |  grep   -i  "\/*nginx*\/"`

#判断是否存在编译安装生成的nginx命令文件，没有的话退出当前脚本
[  `echo  $?`  ==  0 ]   ||  exit  1

#查看nginx编译时的参数

$CMD  -v  &>   ./cache.tmp

VERSION=`cat   ./cache.tmp |  awk  '{print $3}'`

rm  -rf   ./cache.tmp

#查看"Nginx_Make_Version"所在的行号

LINE_NUM=`grep  -n  "Nginx_Make_Version"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Nginx_Make_Version"行之后添加一行

sed  -ie  "/Nginx_Make_Version/a \'Nginx_Make_Version\':\'$VERSION\'" $ENV_PATH

#删除原来的"Nginx_Make_Version"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH






