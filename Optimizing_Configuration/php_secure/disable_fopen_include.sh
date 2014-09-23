#!/bin/bash

#Disable code running remotely


CONF_PATH=`find  /  -name  "php.ini"`

##edit the configuration file

if [ -f  /usr/local/backup/php.ini.old ]

then

sed  -i  '/^allow_url_fopen =/d'        $CONF_PATH
echo  "allow_url_fopen = Off"     >>      $CONF_PATH

sed  -i  '/^allow_url_include =/d'	$CONF_PATH
echo  "allow_url_include = Off"		$CONF_PATH

else 
        echo '###please run backup.sh first!!!###'
fi
