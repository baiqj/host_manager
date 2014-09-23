#!/bin/bash

##############################
#检测Nginx是否已经安装
##############################
updatedb

ENV_PATH=../../env_config


#查看nginx的主配置文件是否存在

locate   "nginx.conf"  |  grep  -i  "\/nginx\.conf$"   

if  [ `echo $?`  == 0  ] 
then
	 sed -i  "/'Nginx_Install':/s/$/\'On\'/"  $ENV_PATH
else
	 sed -i  "/'Nginx_Install':/s/$/\'Off\'/"  $ENV_PATH
fi

