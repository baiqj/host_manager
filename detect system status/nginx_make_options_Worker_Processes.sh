#!/bin/bash

##############################
#检测Make安装方式Nginx的worker_processes进程数
##############################
updatedb

ENV_PATH=../env_config

#查看make编译安装的nginx命令路径

CMD=`locate nginx   |  grep  "\/nginx$"    |  grep   -i  "\/*nginx*\/"`

#判断是否存在编译安装生成的nginx命令文件，没有的话退出当前脚本
[  `echo  $?`  ==  0 ]   ||  exit  1


#将nginx的安装参数存放到cache.tmp文件中

$CMD  -V   &>  ./cache.tmp

CONF=`cat  ./cache.tmp  | grep -i  "configure arguments"  |  awk -F  "--conf-path="  '{print  $2}'  |  awk  '{print  $1}'`

rm  -rf   ./cache.tmp

VALUE=`grep -v "#"  $CONF   |  grep  -iw  "worker_process"  | awk  '{print  $2}'  |  awk  -F ';'  '{print  $1}'`

LINE_NUM=`grep  -n  "Nginx_Make_Worker_Processes"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Nginx_Make_Worker_Processes"行之后添加一行

sed  -ie  "/Nginx_Make_Worker_Processes/a \'Nginx_Make_Worker_Processes\':\'$VALUE\'"   $ENV_PATH

#删除原来的"Nginx_Make_Worker_Processes"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH