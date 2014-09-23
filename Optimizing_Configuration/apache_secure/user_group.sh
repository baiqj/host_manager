#!/bin/bash

#Specify the apache running account

CONF_PATH=`find / -name 'httpd.conf'  -a  -type f`

[ -d  /usr/local/backup ] ||  mkdir  -p  /usr/local/backup
[ -d  /usr/local/resault ] ||  mkdir  -p  /usr/local/resault

if [ -f /usr/local/backup/httpd.conf.old ]
then
	groupadd  -rf   apache
	useradd  -Mr  -g apache  -s /sbin/nologin   apache

	sed  -i  '/^User /d'   $CONF_PATH
	echo  "User apache"  >>  $CONF_PATH

	sed  -i  '/^Group /d'   $CONF_PATH
	echo  "Group apache"  >>  $CONF_PATH
	
else
	echo 'please running backup.sh first!!!'
fi





