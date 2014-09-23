#!/bin/bash

#Disabled  Upload  File

CONF_PATH=`find  /  -name  "php.ini"`

##edit the configuration file

if [ -f  /usr/local/backup/php.ini.old ]

then

sed  -i  '/^file_uploads =/d'        $CONF_PATH
echo  "file_uploads = Off"     >>      $CONF_PATH

else 
        echo '###please run backup.sh first!!!###'
fi

