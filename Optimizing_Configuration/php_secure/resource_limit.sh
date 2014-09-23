#!/bin/bash

#Resource usage restrictions

CONF_PATH=`find  /  -name  "php.ini"`

##edit the configuration file

if [ -f  /usr/local/backup/php.ini.old ]

then

sed  -i  '/^max_execution_time =/d'        $CONF_PATH
echo  "max_execution_time = 30"     >>      $CONF_PATH

sed  -i  '/^max_input_time =/d'        $CONF_PATH
echo  "max_input_time = 30"     >>      $CONF_PATH

sed  -i  '/^memory_limit =/d'        $CONF_PATH
echo  "memory_limit = 40"     >>      $CONF_PATH

else 
        echo '###please run backup.sh first!!!###'
fi
