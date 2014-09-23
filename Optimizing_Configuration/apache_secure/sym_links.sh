#!/bin/bash

#Disable apache follow symbolic links

CONF_PATH=`find / -name 'httpd.conf'  -a  -type f`

[ -d  /usr/local/backup ] ||  mkdir  -p  /usr/local/backup
[ -d  /usr/local/resault ] ||  mkdir  -p  /usr/local/resault

if [ -f  /usr/local/backup/httpd.conf.old ]

then
        LINE_SUM=`wc  -l   $CONF_PATH`
        LINE_NUM=`grep  -n  "^#"   /etc/httpd/conf/httpd.conf | awk  -F:  '{print  $1}'`

         sed  -n  ''$LINE_NUM','$LINE_SUM'p'  $CONF_PATH  |  sed  -i  '/ Options /s/$/ -FollowSymLinks /p'  $CONF_PATH

else 
        echo '###please run backup.sh first!!!###'
fi
