#!/bin/bash

##############################
#检测Rpm安装方式Apache的安装目录
##############################
updatedb

ENV_PATH=../env_config

CONF_PATH="/etc/httpd/conf/httpd.conf"

DOCUMENT_PATH=`grep  -i  "ServerRoot "   $CONF_PATH  | grep -v "^#" |  awk   '{print  $2}'`

LINE_NUM=`grep  -n  "Apache_Rpm_Installation_Directory"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Apache_Rpm_Installation_Directory"行之后添加一行

sed  -ie  "/Apache_Rpm_Installation_Directory/a \'Apache_Rpm_Installation_Directory\':\'$DOCUMENT_PATH\'"   $ENV_PATH

#删除原来的"Apache_Rpm_Installation_Directory"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH
