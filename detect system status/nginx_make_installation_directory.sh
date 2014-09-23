#!/bin/bash

##############################
#检测Make安装方式Nginx的安装目录
##############################
updatedb

ENV_PATH=../env_config

#查看make编译安装的nginx命令路径

CMD=`locate nginx   |  grep  "\/nginx$"    |  grep   -i  "\/*nginx*\/"`

#判断是否存在编译安装生成的nginx命令文件，没有的话退出当前脚本
[  `echo  $?`  ==  0 ]   ||  exit  1

#查看nginx编译时的参数

$CMD  -V  &>   ./cache.tmp

#查看编译安装的安装目录
DOCUMENT_PATH=`cat  ./cache.tmp  |   grep  -i "configure *arguments"  |  awk -F '--prefix='  '{print $2}'  |  awk  '{print  $1}'`

rm  -rf   ./cache.tmp


LINE_NUM=`grep  -n  "Nginx_Make_Installation_Directory"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Nginx_Make_Installation_Directory"行之后添加一行

sed  -ie  "/Nginx_Make_Installation_Directory/a \'Nginx_Make_Installation_Directory\':\'$DOCUMENT_PATH\'"   $ENV_PATH

#删除原来的"Nginx_Make_Installation_Directory"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH
