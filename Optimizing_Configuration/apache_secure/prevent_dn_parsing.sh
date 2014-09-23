#!/bin/bash

#Prevent DN malicious parsing

CONF_PATH=`find / -name 'httpd.conf'  -a  -type f`

NVH_PATH=`find  /  -name  "*.conf"  -a  -type f  -exec  grep -l  "^NameVirtualHost"  {}  \;`

[ -d  /usr/local/resault ] ||  mkdir  -p  /usr/local/resault
[ -d  /usr/local/backup ]  ||  mkdir  -p  /usr/local/backup

##edit the configuration file


if [ -f  /usr/local/backup/httpd.conf.old ]

then

       sed  -ie  '/NameVirtualHost /{h;s/.*/cat   virtualhost_null.txt/e;}'   $NVH_PATH

else
        echo '###please run backup.sh first!!!###'
fi


