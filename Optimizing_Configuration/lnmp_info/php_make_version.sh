#!/bin/bash

##############################
#检测Make编译安装方式PHP的安装版本
##############################
updatedb

ENV_PATH=../env_config

#判断是否存在Make编译安装的php主配置文件，没有的话退出本脚本

locate   "php.ini"  |  grep  -i  "\/php\.ini$" |  grep  -v  "\/etc\/php.ini" |  grep  -vi "\/doc"  |  grep  -vi  "\/share\/"  |  grep -vi  "ln*mp*"  

[ `echo  $?` == 0 ] ||  exit 1


#查看make编译安装的php命令路径

CMD=`locate  php  | grep  "\/php$"   |  grep  "/php/bin/"`

#将php的版本赋值给"VERSION"变量

VERSION=`$CMD -v  |  grep  -i "^PHP"  |  grep  "(built:"  |  awk '{print  $2}'`

#查看"Php_Make_Version"所在的行号

LINE_NUM=`grep  -n  "Php_Make_Version"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Php_Make_Version"行之后添加一行

sed  -ie  "/Php_Make_Version/a \'Php_Make_Version\':\'$VERSION\'" $ENV_PATH

#删除原来的"Php_Make_Version"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH






