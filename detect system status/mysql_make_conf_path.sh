#!/bin/bash

##############################
#检测Make安装方式mysql的主配置文件的路径
##############################
updatedb

ENV_PATH=../env_config

#rpm安装mysql则退出当前脚本

rpm -q  mysql
[ `echo  $?` ] &&   exit 1

#查看编译安装的主配置文件的路径

CONF="/etc/mysql.cnf"

LINE_NUM=`grep  -n  "MySql_Make_Conf_Path"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"MySql_Make_Conf_Path"行之后添加一行

sed  -ie  "/MySql_Make_Conf_Path/a \'MySql_Make_Conf_Path\':\'$CONF\'"   $ENV_PATH

#删除原来的"MySql_Make_Conf_Path"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH
