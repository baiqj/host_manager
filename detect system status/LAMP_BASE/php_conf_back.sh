#!/bin/bash

##############################
#make安装方式PHP的主配置文件的备份
##############################
updatedb

ENV_PATH=../../env_config

#判断是否存在"CONF_BACK"目录

[ -d   CONF_BACK  ]   ||   mkdir  ./CONF_BACK


#判断php是否为rpm方式安装
[ `echo  $?` == 0 ] &&  \cp   /etc/php-fpm.conf    ./CONG_BACK/`date  +%Y-%m-%d`-php-fpm.conf    &&   \cp   /etc/php.ini			./CONG_BACK/`date  +%Y-%m-%d`-php.ini 


#查看make编译安装的php命令路径

CMD=`locate  php   |  grep  "\/php$"  |   grep  "\/php\/bin\/"`

[  `echo  $?` != 0 ]  &&  exit  1

#查看php编译时的参数

$CMD  -i  &>   ./cache.tmp


#查看编译安装的主配置文件的路径

DOCUMENT_PATH=`cat  ./cache.tmp  |   grep  -i "Configure Command"  |  awk -F '--prefix='  '{print $2}'  | awk  -F  "' '"  '{print  $1}'`

rm  -rf   ./cache.tmp


CONF=`locate  "php.ini"  |  grep  "$DOCUMENT_PATH"   | grep  "\/php.ini$"`

\cp    $CONF    ./CONF_BACK/`date  +%Y-%m-%d`-php.ini

CONF=`locate  "php-fpm.conf"  |  grep  "$DOCUMENT_PATH"   | grep  "\/php-fpm\.conf$"`

\cp    $CONF    ./CONF_BACK/`date  +%Y-%m-%d`-php-fpm.conf   
