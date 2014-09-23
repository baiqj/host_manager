#!/bin/bash

##############################
#检测RPM编译安装方式PHP的安装版本
##############################
updatedb

ENV_PATH=../env_config

#判断是否安装php

rpm  -q  php

[ `echo  $?` == 0 ] ||  exit 1

#查看rpm安装的php命令路径

CMD=`which  php`

#将php的版本赋值给"VERSION"变量

VERSION=`$CMD -v  |  grep  -i "^PHP"  |  grep  "(built:"  |  awk '{print  $2}'`

#查看"Php_Rpm_Version"所在的行号

LINE_NUM=`grep  -n  "Php_Rpm_Version"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Php_Rpm_Version"行之后添加一行

sed  -ie  "/Php_Rpm_Version/a \'Php_Rpm_Version\':\'$VERSION\'" $ENV_PATH

#删除原来的"Php_Rpm_Version"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH






