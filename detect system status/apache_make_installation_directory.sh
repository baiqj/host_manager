#!/bin/bash

##############################
#检测Make安装方式Apache的安装目录
##############################
updatedb

ENV_PATH=../env_config

#注意主配置文件所在的路径不包含关键字："/etc/httpd/conf/httpd.conf" |"share"|"doc"|"ln*mp*"等

locate   "httpd.conf"  |  grep  -i  "\/conf\/httpd\.conf$" |  grep  -v  "\/etc\/httpd\/conf\/httpd.conf" |  grep  -vi "\/doc"  |  grep  -vi  "\/share\/"  |  grep -vi  "ln*mp*"  

#判断是否存在编译安装生成的httpd.conf文件，没有的话退出当前脚本
[  `echo  $?`  ==  0 ]   ||  exit  1

CONF=`locate   "httpd.conf"  |  grep  -i  "\/conf\/httpd\.conf$" |  grep  -v  "\/etc\/httpd\/conf\/httpd.conf" |  grep  -vi "\/doc"  |  grep  -vi  "\/share\/"  |  grep -vi  "ln*mp*"  `

DOCUMENT_PATH=`grep  -i  "ServerRoot "   $CONF  | grep -v "^#" |  awk   '{print  $2}'`

LINE_NUM=`grep  -n  "Apache_Make_Installation_Directory"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Apache_Make_Installation_Directory"行之后添加一行

sed  -ie  "/Apache_Make_Installation_Directory/a \'Apache_Make_Installation_Directory\':\'$DOCUMENT_PATH\'"   $ENV_PATH

#删除原来的"Apache_Make_Installation_Directory"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH
