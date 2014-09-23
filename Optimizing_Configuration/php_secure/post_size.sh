#!/bin/bash

CONF_PATH=`find  /  -name  "php.ini"`

##edit the configuration file

if [ -f  /usr/local/backup/php.ini.old ]

then

sed  -i  '/^post_max_size =/d'        $CONF_PATH
echo  "post_max_size = 1k"     >>      $CONF_PATH

else 
        echo '###please run backup.sh first!!!###'
fi
