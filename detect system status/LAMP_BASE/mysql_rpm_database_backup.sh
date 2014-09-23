#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

########################################
#用于已有的rpm安装的mysql数据库的本地备份迁移，让出/usr/local/mysql目录
#执行脚本完成后，手动启动源mysql的命令：/usr/bin/mysqld_safe  --defaults-file=/etc/my_3307.cnf  &
#########################################

updatedb

ENV_PATH=../../env_config

#查看mysql是否在运行，正在运行的话退出当前脚本
ps  -ef  |  grep  mysqld  |  grep  -v  "grep" 

[ `echo  $?` == 0 ] &&  exit  1


[ rpm -q  mysql-server ]  ||  exit  1  ||  


#将端口由3306更改为3307
\cp  -rpv /etc/my.cnf    	/etc/my_3307.cnf

#删除所有的注释行
sed  -i   '/#/d'  /etc/my_3307.cnf
#删除所有的空行
sed  -i   '/^$/d'  /etc/my_3307.cnf

#需要判断是否设置了port参数

PORT=`grep   '\[mysqld\]'  -A4   /etc/my_3307.cnf   |  grep  "port" | awk -F "="  '{print $2}'`

if  [ `echo  $?` != 0 ]
then
	sed -e "/^\[mysqld\]$/a  port =   3307 " -i      /etc/my_3307.cnf 
else
	sed  -i  's/3306/3307/g'   /etc/my_3307.cnf
fi







 

 


