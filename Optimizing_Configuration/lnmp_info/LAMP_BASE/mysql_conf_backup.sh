#!/bin/bash

##############################
#mysql的主配置文件的备份
##############################
updatedb

ENV_PATH=../../env_config

#判断是否存在"CONF_BACK"目录

[ -d   ./CONF_BACK  ]  ||  mkdir  ./CONF_BACK



#判断/etc/my.cnf内容不为空
[ -s  /etc/my.cnf ]  &&  \cp    /etc/my.cnf    ./CONF_BACK/`date  +%Y-%m-%d`-my.cnf




