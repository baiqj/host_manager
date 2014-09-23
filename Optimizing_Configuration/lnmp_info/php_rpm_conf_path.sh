#!/bin/bash

##############################
#检测Rpm安装方式PHP的主配置文件的路径
##############################
updatedb

ENV_PATH=../env_config

#判断是否有rpm方式安装的PHP，没有的话退出该脚本

[ `rpm -q   php` ] ||  exit 1


CONF="/etc/php.ini"

LINE_NUM=`grep  -n  "Php_Rpm_Conf_Path"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Php_Rpm_Conf_Path"行之后添加一行

sed  -ie  "/Php_Rpm_Conf_Path/a \'Php_Rpm_Conf_Path\':\'$CONF\'"   $ENV_PATH

#删除原来的"Php_Rpm_Conf_Path"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH
