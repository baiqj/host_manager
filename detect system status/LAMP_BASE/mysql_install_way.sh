#!/bin/bash

##############################
#检测mysql的安装方式rpm或者make
##############################
updatedb

ENV_PATH=../../env_config

#判断是否安装了mysql,返回值为零时为已经安装
locate  mysqld |   grep  "\/mysqld$"

[  `echo  $?` ]  ||  exit  1

#判断mysql是否为rpm方式安装，返回值为零时为rpm安装
rpm  -q   mysql-server

#如果mysql已经安装，且不是rpm安装的话即认为是make安装

if  [ `echo $?`  == 0  ] 
then
		sed -i  "/'MySql_Install_Way':/s/$/\'Rpm\'/"  $ENV_PATH
else
		sed -i  "/'MySql_Install_Way':/s/$/\'\Make\'/"  $ENV_PATH
fi
	

