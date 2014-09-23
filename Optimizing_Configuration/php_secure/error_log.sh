#!/bin/bash

#Set the error log output to the log file  "/var/log/php_error.log"


CONF_PATH=`find  /  -name  "php.ini"`


##create php error log file


chmod   0002  /var/log/php_error.log 
chattr  +a  /var/log/php_error.log 

##edit the configuration file

if [ -f  /usr/local/backup/php.ini.old ]

then

sed  -i  '/^error_reporting =/d'    	$CONF_PATH
echo  "error_reporting = E_WARNING & E_ERROR"	>>  	$CONF_PATH

sed  -i  '/^display_error =/d'		$CONF_PATH
echo  "display_errors = Off"			>>	$CONF_PATH

sed  -i  '/^log_errors =/d'		$CONF_PATH
echo  "log_errors = On"					$CONF_PATH

sed  -i '/^error_log =/d'		$CONF_PATH
echo  "error_log = /var/log/php_error.log"

else 
      	echo '###please run backup.sh first!!!###'
fi





 


