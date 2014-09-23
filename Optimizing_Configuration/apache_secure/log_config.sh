#!/bin/bash

#The log format setting

CONF_PATH=`find / -name 'httpd.conf'  -a  -type f`

[ -d  /usr/local/backup ] ||  mkdir  -p  /usr/local/backup
[ -d  /usr/local/resault ] ||  mkdir  -p  /usr/local/resault

##edit the configuration file

CMD_PATH=`find  / -name "rotatelogs" -a -type f -a -perm +111`

if [ -f  /usr/local/backup/httpd.conf.old ]

then
	sed  -i  '/^ErrorLog /d'   $CONF_PATH
	sed  -i  '/^CustomLog /d'   $CONF_PATH

	ErrorLog "| $CMD_PATH -l logs/error-%Y-%m-%d.log 86400 480 1M"
	CustomLog "| $CMD_PATH -l logs/access-%Y-%m-%d.log 86400 480 1M"  common
else 
        echo '###please run backup.sh first!!!###'
fi


