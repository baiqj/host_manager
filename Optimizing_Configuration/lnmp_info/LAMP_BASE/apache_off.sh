#!/bin/bash

##############################
#Apache的关闭脚本
##############################
updatedb

ENV_PATH=../../env_config


CMD=`locate  "apachectl"  |  grep  "\/apachectl$"  |  grep  -v  "/usr/sbin/apachectl"`

#关闭Apache服务

[  `echo  $?`  == 0  ]   &&  $CMD  -k   stop 

#查看apache的启动脚本
locate  httpd  |  grep  "\/etc\/rc.d\/init\.d\/httpd$"

[ `echo  $?` ]  &&  chkconfig  httpd  off   &&   service  httpd  stop

#删除rc.local中的apache启动项

sed   -i   '/http/d'   /etc/rc.d/rc.local

sed   -i   '/apache/d'   /etc/rc.d/rc.local

