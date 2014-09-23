#!/bin/bash

##############################
#检测Linux系统版本信息
##############################

#安装locate工具

rpm  -ivh  ./mlocate-0.22.2-4.el6.x86_64.rpm

rpm  -ivh  ./dos2unix-3.1-37.el6.x86_64.rpm

#转换格式
dos2unix  ../env_config 
dos2unix  ../user_config
dos2unix  ../website_config
dos2unix   ./*.sh
dos2unix   ./LAMP_BASE/*.sh


#查看系统版本信息并赋予到env_config的OS_version

ENV_PATH=../env_config

OS=`cat  /etc/issue | grep  -i  release`

sed -i  "/'OS_version':/s/$/\'$OS\'/"  $ENV_PATH

#判断Linux系统的位数

uname  -a    |  grep  -i  "x86_64"

if  [ `echo $?`  == 0  ] 
then
	 sed -i  "/'OS_bit':/s/$/\'x86_64\'/"  $ENV_PATH
else
	 sed -i  "/'OS_bit':/s/$/\'i386\'/"  $ENV_PATH
fi


