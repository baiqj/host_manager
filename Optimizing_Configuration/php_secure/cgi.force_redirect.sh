#!/bin/bash

#Enable cgi.force_redirect

CONF_PATH=`find  /  -name  "php.ini"`

##edit the configuration file

if [ -f  /usr/local/backup/php.ini.old ]

then

sed  -i  '/^cgi\.force_redirect =/d'        $CONF_PATH
echo   'cgi.force_redirect = On'     >>      $CONF_PATH

else 
        echo '###please run backup.sh first!!!###'
fi
