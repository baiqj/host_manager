#!/bin/bash

##############################
#检测/etc/passwd文件的属性权限
##############################

updatedb

ENV_PATH=../env_config

VALUE=`ll  /etc/passwd  |  awk  -F '.'   '{print  $1}'`

#查看"Passwd_Permissions"所在的行号

LINE_NUM=`grep  -n  "Passwd_Permissions"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Passwd_Permissions"行之后添加一行

sed  -ie  "/Passwd_Permissions/a \'Passwd_Permissions\':\'$VERSION\'" $ENV_PATH

#删除原来的"Passwd_Permissions"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH