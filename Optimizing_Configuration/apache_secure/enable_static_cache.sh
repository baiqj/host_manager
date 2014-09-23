#!/bin/bash

#Static file cache enabled

CONF_PATH=`find / -name 'httpd.conf'  -a  -type f`

[ -d  /usr/local/backup ] ||  mkdir  -p  /usr/local/backup
[ -d  /usr/local/resault ] ||  mkdir  -p  /usr/local/resault

##edit the configuration file


[ `find / -name  "mod_expires.so"` ]  || echo "mod_expires.so is not exist"  ||  exit 1

if  [ grep  "mod_expires.so"  $CONF_PATH | grep "^LoadModule"  ]
then
	echo  "mod_expires.so is load"
else
	sed  -e  "/mod_include.so/a  LoadModule expires_module $(find / -name  "mod_expires.so")"  -i   $CONF_PATH
fi

[  `grep  "<ifModule mod_expries.c>"  $CONF_PATH ` ]  &&  echo "Static file cache is configure"  && exit 1  ||  cat  cache_config.txt  >>   $CONF_PATH


