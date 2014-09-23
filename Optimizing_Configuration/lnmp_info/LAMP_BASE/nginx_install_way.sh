#!/bin/bash

##############################
#检测Nginx的安装方式rpm或者make
##############################
updatedb

ENV_PATH=../../env_config

#判断rpm方式的conf文件是否存在

RPM=`locate   "/etc/nginx/conf/nginx.conf" |  wc -l`

#判断make方式的conf文件是否存在
#注意主配置文件所在的路径不包含关键字："/etc/nginx/conf/nginx.conf" |"share"|"doc"|"ln*mp*"等
MAKE=`locate   "nginx.conf"  |  grep  -i  "\/conf\/nginx\.conf$" |  grep  -v  "\/etc\/nginx\/conf\/nginx.conf" |  grep  -vi "\/doc"  |  grep  -vi  "\/share\/"  |  grep -vi  "ln*mp*"   | wc -l`


locate   "nginx.conf"  |  grep  -i  "\/conf\/nginx\.conf$" |  grep  -vi "\/doc"  |  grep  -vi  "\/share\/"  |  grep -vi  "ln*mp*"    

if  [ `echo $?`  == 0  ] 
then
	if [ $RPM  == 1 -a  $MAKE == 0 ] 
	then
		sed -i  "/'Nginx_Install_Way':/s/$/\'Rpm\'/"  $ENV_PATH
	fi
	if [ $RPM == 0 -a  $MAKE == 1 ]
	then
		sed -i  "/'Nginx_Install_Way':/s/$/\'\Make\'/"  $ENV_PATH
	fi
	if [ $RPM == 1 -a $MAKE == 1 ]
	then
		sed -i  "/'Nginx_Install_Way':/s/$/\'\Rpm|Make\'/"  $ENV_PATH
	fi
else	
	sed -i  "/'Nginx_Install_Way':/s/$/\'\Not\'/"  $ENV_PATH
fi


