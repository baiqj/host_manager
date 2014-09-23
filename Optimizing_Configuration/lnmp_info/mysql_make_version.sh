#!/bin/bash

##############################
#检测Make编译安装方式mysql的安装版本
##############################
updatedb

ENV_PATH=../env_config

#如果rpm安装mysql，退出当前脚本
rpm  -q mysql
[ `echo  $?` ]  &&  exit  1

#查看make编译安装的mysql命令路径

CMD=`locate  mysql  |  grep  "\/mysql$"  |  grep  "\/bin/mysql"   |  grep  -v  "\/usr\/*bin\/"`

#判断是否存在编译安装生成的mysql命令文件，没有的话退出当前脚本
[  `echo  $?`  ==  0 ]   ||  exit  1

#查看nginx编译时的参数

$CMD  -V  &>   ./cache.tmp

VERSION=`cat   ./cache.tmp |  awk -F ','   '{print  $1}'  |  awk  '{print  $5}'`

rm  -rf   ./cache.tmp

#查看"MySql_Make_Version"所在的行号

LINE_NUM=`grep  -n  "MySql_Make_Version"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"MySql_Make_Version"行之后添加一行

sed  -ie  "/MySql_Make_Version/a \'MySql_Make_Version\':\'$VERSION\'" $ENV_PATH

#删除原来的"MySql_Make_Version"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH






