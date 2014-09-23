#!/bin/bash

##############################
#检测Rpm安装方式Apache的安装版本
##############################
updatedb

ENV_PATH=../env_config

#判断是否有rpm方式安装的apache，没有的话退出该脚本

[ `rpm -qa | grep  httpd` ] ||  exit 1

#将apache的版本赋值给"VERSION"变量

VERSION=`/usr/sbin/apachectl  -v | grep  -i "version"  | awk  '{print $3}'`

#查看"Apache_Rpm_Version"所在的行号

LINE_NUM=`grep  -n  "Apache_Rpm_Version"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Apache_Rpm_Version"行之后添加一行

sed  -ie  "/Apache_Rpm_Version/a \'Apache_Rpm_Version\':\'$VERSION\'" $ENV_PATH

#删除原来的"Apache_Rpm_Version"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH






