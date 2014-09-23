#!/bin/bash

##############################
#检测Make安装方式PHP的安装目录
##############################
updatedb

ENV_PATH=../env_config

#查看make编译安装的php命令路径

CMD=`locate  php   |  grep  "\/php$"  |   grep  "\/php\/bin\/"`

#判断是否存在编译安装生成的php命令文件，没有的话退出当前脚本
[  `echo  $?`  ==  0 ]   ||  exit  1

#查看php编译时的参数

$CMD  -i  &>   ./cache.tmp

#查看编译安装的安装目录
DOCUMENT_PATH=`cat  ./cache.tmp  |   grep  -i "Configure Command"  |  awk -F '--prefix='  '{print $2}'  | awk  -F  "' '"  '{print  $1}'`

rm  -rf   ./cache.tmp

LINE_NUM=`grep  -n  "Php_Make_Installation_Directory"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Php_Make_Installation_Directory"行之后添加一行

sed  -ie  "/Php_Make_Installation_Directory/a \'Php_Make_Installation_Directory\':\'$DOCUMENT_PATH\'"   $ENV_PATH

#删除原来的"Php_Make_Installation_Directory"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH
