#!/bin/bash

##############################
#检测Make安装方式Nginx的关闭命令
##############################
updatedb

ENV_PATH=../../env_config

#查看make编译安装的nginx命令路径

CMD=`locate nginx   |  grep  "\/nginx$"    |  grep   -i  "\/*nginx*\/"`

#使用编译安装的方式关闭nginx服务
[  `echo  $?`  ==  0 ]   &&  $CMD  -s  stop

#查看nginx的启动脚本
locate  nginx  |  grep  "\/etc\/rc.d\/init\.d\/nginx$"

[ `echo  $?` == 0  ]  &&  chkconfig  nginx  off  &&  service   nginx  stop

#删除rc.local中的apache启动项

sed   -i   '/nginx/d'   /etc/rc.d/rc.local


