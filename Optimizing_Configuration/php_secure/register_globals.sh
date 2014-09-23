#!/bin/bash

#Close the registered global variables

CONF_PATH=`find  /  -name  "php.ini"`

##edit the configuration file

if [ -f  /usr/local/backup/php.ini.old ]

then

sed  -i  '/^register_globals =/d'        $CONF_PATH
echo  "register_globals = Off"     >>      $CONF_PATH

else 
        echo '###please run backup.sh first!!!###'
fi
