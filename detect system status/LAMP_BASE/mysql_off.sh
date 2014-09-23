#!/bin/bash

##############################
#mysql关闭脚本
##############################
updatedb

ENV_PATH=../../env_config


#查看mysql的启动脚本
locate  mysqld  |  grep  "\/etc\/rc.d\/init\.d\/mysqld$"
[ `echo  $?` == 0  ]  &&  chkconfig  mysqld  off  &&  service  mysqld  stop 

locate  mysql  |  grep  "\/etc\/rc.d\/init\.d\/mysql$"
[ `echo  $?`  == 0 ]  &&  chkconfig  mysql  off   &&  service  mysql  stop


#删除rc.local中的mysql启动项

sed   -i   '/mysql/d'   /etc/rc.d/rc.local



