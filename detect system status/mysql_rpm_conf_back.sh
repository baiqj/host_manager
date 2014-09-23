#!/bin/bash

##############################
#Rpm安装方式mysql的主配置文件的备份
##############################
updatedb

ENV_PATH=../env_config

#判断mysql是否为rpm方式安装
rpm  -q  mysql
[ `echo  $?` ] ||  exit  1

#判断是否存在"CONF_BACK"目录

if  [ -d   CONF_BACK  ]
then	
	
else
	mkdir  ./CONF_BACK
if

\cp    /etc/mysql.cnf    .\CONG_BACK


