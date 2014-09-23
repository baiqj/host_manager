#!/bin/bash

#Shows the apache version information is disabled

CONF_PATH=`find / -name 'httpd.conf'  -a  -type f`

[ -d  /usr/local/backup ] ||  mkdir  -p  /usr/local/backup
[ -d  /usr/local/resault ] ||  mkdir  -p  /usr/local/resault

##edit the configuration file

if [ -f  /usr/local/backup/httpd.conf.old ]

then

	sed  -i  '/LimitRequestBody /d'        $CONF_PATH
	echo  "LimitRequestBody 512000"     >>      $CONF_PATH

else 
        echo '###please run backup.sh first!!!###'
fi
