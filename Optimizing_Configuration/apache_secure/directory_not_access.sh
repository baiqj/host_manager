#!/bin/bash

#Limit the PHP directory can be accessed

CONF_PATH=`find / -name 'httpd.conf'  -a  -type f`

[ -d  /usr/local/backup ] ||  mkdir  -p  /usr/local/backup
[ -d  /usr/local/resault ] ||  mkdir  -p  /usr/local/resault

##edit the configuration file

if [ -f  /usr/local/backup/httpd.conf.old ]

then
	sed  -ie  '/###/{h;s/.*/cat   directory_not_access.txt/e;G}'   $CONF_PATH
else 
        echo '###please run backup.sh first!!!###'
fi
