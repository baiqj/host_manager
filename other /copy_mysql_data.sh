#!/bin/sh
#
# ******************************************************************************
# 感谢您使用LuNamp，本软件遵循GPL协议，详情请看：http://www.gnu.org/copyleft/gpl.html
# Thank you for choosing LuNamp, This program is free software; 
# you can redistribute it and/or modify it under the terms of the GNU General 
# Public License as published by the Free Software Foundation; 
# either version 2 of the License, or (at your option) any later version.
# http://www.gnu.org/copyleft/gpl.html
# ------------------------------------++++
# 软件名：	LuNamp
# 作者：		刘新（网名：爱洞特漏）
# 官方网站：	www.zijidelu.org
# 服务邮箱：	service@zijidelu.org
# ------------------------------------++++
# Software:  LuNamp
# Author:    Liu Xin
# Website:   www.zijidelu.org
# Email:     service@zijidelu.org
# ------------------------------------++++
# Thank you for choosing LuNamp!
# ******************************************************************************
#

#转移MySQL数据库位置的脚本

mysql_user='lu_mysql'
#原目录
if [ "$1" ] && [ "$2" ]; then
	mysql_data_dir_old=$1
else
	mysql_data_dir_old=/usr/local/mysql/var
fi

#新目录
if [ "$1" ] && [ "$2" ]; then
	mysql_data_dir_new=$2
else
	mysql_data_dir_new=/home/mysql_data
fi


if [ ! -d $mysql_data_dir_new ]; then
	mkdir -p $mysql_data_dir_new
fi
ls ${mysql_data_dir_old}/ > /tmp/_mysql_data_list.txt
data_list=/tmp/_mysql_data_list.txt
data_count=`ls ${mysql_data_dir_old} | wc -l`

i=1
while [ $i -le $data_count ] ; do
	filename=`head -n $i $data_list | tail -n -1`
	full_filename=$mysql_data_dir_old/$filename
	if [ -d "$full_filename" ]; then
		if [ "$filename" != 'test' ] && [ "$filename" != 'performance_schema' ]; then
			echo "Coping ${full_filename} $mysql_data_dir_new/$filename";
			cp -rf $full_filename $mysql_data_dir_new/
			sleep 1
		fi
	fi

	i=$(($i + 1))
done

if [ -d $mysql_data_dir_new/mysql ]; then
	chown -R ${mysql_user}:${mysql_user} $mysql_data_dir_new
	chmod -R 2770 $mysql_data_dir_new
	
	mysql-restart

	echo '数据转移完毕'

	echo '要删除旧数据吗（删除后不可恢复，请谨慎操作）？[y/n]'
	echo 'Do you want to delete the old data(Can not be revert)?[y/n]'
	
	read del_old_data
	if [ "$del_old_data" = 'y' ] || [ "$del_old_data" = 'Y' ]; then
		rm -rf $mysql_data_dir_old/*
	fi
else
	echo '数据转移失败'
fi
