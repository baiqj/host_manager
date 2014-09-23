#!/bin/bash

CONF_PATH=`find  /  -name  "php.ini"`

##edit the configuration file

if [ -f  /usr/local/backup/php.ini.old ]

then

sed  -i  '/^expose_php =/d'        $CONF_PATH
echo  "expose_php = Off"     >>      $CONF_PATH

sed  -i  '/^display_startup_errors =/d'        $CONF_PATH
echo  "display_startup_errors = Off"     >>      $CONF_PATH

else 
        echo '###please run backup.sh first!!!###'
fi
