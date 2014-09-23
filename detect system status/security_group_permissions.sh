#!/bin/bash

##############################
#检测/etc/group文件的属性权限
##############################

updatedb

ENV_PATH=../env_config

VALUE=`ll  /etc/group  |  awk  -F '.'   '{print  $1}'`

#查看"Group_Permissions"所在的行号

LINE_NUM=`grep  -n  "Group_Permissions"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Group_Permissions"行之后添加一行

sed  -ie  "/Group_Permissions/a \'Group_Permissions\':\'$VERSION\'" $ENV_PATH

#删除原来的"Group_Permissions"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH