#!/bin/bash

#Shows the apache version information is disabled

CONF_PATH=`find / -name 'httpd.conf'  -a  -type f`

[ -d  /usr/local/backup ] ||  mkdir  -p  /usr/local/backup
[ -d  /usr/local/resault ] ||  mkdir  -p  /usr/local/resault

##edit the configuration file

if [ -f  /usr/local/backup/httpd.conf.old ]

then

sed  -i  '/^ServerSignature /d'        $CONF_PATH
echo  "ServerSignature On"     >>      $CONF_PATH

sed  -i  '/^ServerTokens /d'        $CONF_PATH
echo  "ServerTokens Prod"     >>      $CONF_PATH

else 
        echo '###please run backup.sh first!!!###'
fi

