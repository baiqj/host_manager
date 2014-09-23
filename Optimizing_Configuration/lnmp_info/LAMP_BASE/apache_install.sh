#!/bin/bash

##############################
#检测Apache是否已经安装
##############################
updatedb

ENV_PATH=../../env_config

#判断Apache的主配置文件是否存在

#注意主配置文件所在的路径不包含关键字："/etc/httpd/conf/httpd.conf" |"share"|"doc"|"ln*mp*"等

locate   "httpd.conf"  |  grep  -i  "\/conf\/httpd\.conf$" |   grep  -vi "\/doc"  |  grep  -vi  "\/share\/"  |  grep -vi  "ln*mp*"  


if  [ `echo $?`  == 0  ] 
then
	 sed -i  "/'Apache_Install':/s/$/\'On\'/"  $ENV_PATH
else
	 sed -i  "/'Apache_Install':/s/$/\'Off\'/"  $ENV_PATH
fi

