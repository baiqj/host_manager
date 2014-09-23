#!/bin/bash

#Limits the PHP process from accessing files outside

CONF_PATH=`find  /  -name  "php.ini"`

[ -d  /usr/local/resault ] ||  mkdir  -p  /usr/local/resault
[ -d  /usr/local/backup ]  ||  mkdir  -p  /usr/local/backup

find  /  -name  "vhost.list"  -a  -type  f  -exec  \cp  {}  /usr/local/resault  \;

if [ -f  /usr/local/resault/vhost.list ]
then
	if [ -s /usr/local/resault/vhost.list ]
	then
		grep   "^DOCUMENT="  /usr/local/resault/vhost.list |  awk -F "="  '{print  $2}' >  /usr/local/resault/web_document.txt
		WWW=`sed   ':t;N;s/\n/:/;b t'   /usr/local/resault/web_document.txt `	
	else
		echo 'this host have not website!!!'
		exit 1
	fi
		
else
		echo 'plsase check website-info!!!'
		exit 1
fi

##edit the configuration file


if [ -f  /usr/local/backup/php.ini.old ]

then

	sed  -i  '/^open_basedir =/d'        $CONF_PATH
	echo  "open_basedir = $WWW"     >>      $CONF_PATH

else 
        echo '###please run backup.sh first!!'
fi
