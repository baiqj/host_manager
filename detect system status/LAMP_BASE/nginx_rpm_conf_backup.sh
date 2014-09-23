#!/bin/bash

##############################
#Rpm安装方式NGINX的主配置文件的备份
##############################
updatedb

ENV_PATH=../../env_config

#判断nginx是否为rpm方式安装
rpm  -q  nginx
[ `echo  $?` ] ||  exit  1

#判断是否存在"CONF_BACK"目录

[ -d   CONF_BACK  ]  ||  mkdir  ./CONF_BACK

\cp    /etc/nginx/nginx.conf   ./CONF_BACK/`date  +%Y-%m-%d`-nginx.conf


