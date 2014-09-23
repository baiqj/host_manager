#!/bin/bash

#Enable SQL safe mode

CONF_PATH=`find  /  -name  "php.ini"`

##edit the configuration file

if [ -f  /usr/local/backup/php.ini.old ]

then

sed  -i  '/^sql.safe_mode =/d'        $CONF_PATH
echo  "sql.safe_mode = On"     >>      $CONF_PATH

sed  -i  '/^magic_quotes_gpc =/d'        $CONF_PATH
echo  "magic_quotes_gps = Off"     >>      $CONF_PATH

else 
        echo '###please run backup.sh first!!!###'
fi
