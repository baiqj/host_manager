#!/bin/bash

##############################
#检测Make安装方式mysql的安装目录
##############################
updatedb

ENV_PATH=../env_config

#rpm安装mysql时退出当前脚本

rpm   -q  mysql
[ `echo  $?` ]  &&  exit  1

#查看编译安装的安装目录
DOCUMENT_PATH=`locate   mysqlbug  |  grep  "\/bin\/mysqlbug$"  |  awk -F '/bin'   '{print  $1}'`


LINE_NUM=`grep  -n  "MySql_Make_Installation_Directory"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"MySql_Make_Installation_Directory"行之后添加一行

sed  -ie  "/MySql_Make_Installation_Directory/a \'MySql_Make_Installation_Directory\':\'$DOCUMENT_PATH\'"   $ENV_PATH

#删除原来的"MySql_Make_Installation_Directory"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH
