#!/bin/bash

#Dynamic link library loading is disable

CONF_PATH=`find  /  -name  "php.ini"`

##edit the configuration file

if [ -f  /usr/local/backup/php.ini.old ]

then

sed  -i  '/^disable_dl =/d'        $CONF_PATH
sed  -i  '/^enable_dl =/d'        $CONF_PATH
echo  "enable_dl = Off"     >>      $CONF_PATH

else 
        echo '###please run backup.sh first!!!###'
fi
