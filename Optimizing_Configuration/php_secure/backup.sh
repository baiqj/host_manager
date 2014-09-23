#!/bin/bash

##backup configuration file

CONF_PATH=`find  /  -name  "php.ini"`

[ -d  /usr/local/backup ] ||  mkdir  -p  /usr/local/backup
[ -d  /usr/local/resault ] ||  mkdir  -p  /usr/local/resault

[ -f /usr/local/backup/php.ini.old ] || \cp  $CONF_PATH  /usr/local/backup/php.ini.old 


grep   -v  "^;"   /usr/local/backup/php.ini.old  >  $CONF_PATH 

sed  -i  '/^ *$/d'    $CONF_PATH
