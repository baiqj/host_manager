#!/bin/bash

##############################
#检测mysql是否已经安装
##############################
updatedb

ENV_PATH=../../env_config

#判断mysqld的文件是否存在

locate  mysqld  |  grep   "\/mysqld$"

if  [ `echo $?`  == 0  ] 
then
	 sed -i  "/'MySql_Install':/s/$/\'On\'/"  $ENV_PATH
else
	 sed -i  "/'MySql_Install':/s/$/\'Off\'/"  $ENV_PATH
fi
