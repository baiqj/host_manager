#!/bin/bash

#PHP can only access the directory

CONF_PATH=`find / -name 'httpd.conf'  -a  -type f`

[ -d  /usr/local/resault ] ||  mkdir  -p  /usr/local/resault
[ -d  /usr/local/backup ]  ||  mkdir  -p  /usr/local/backup

##edit the configuration file


if [ -f  /usr/local/backup/httpd.conf.old ]

then
        LINE_SUM=`wc  -l   $CONF_PATH`
        LINE_NUM=`grep  -n  "^#"   /etc/httpd/conf/httpd.conf | awk  -F:  '{print  $1}'`

         sed  -n  ''$LINE_NUM','$LINE_SUM'p'  $CONF_PATH  |  sed  -e  '/ Options /a php_admin_value  open_basedir  .:/tmp/'  -i  $CONF_PATH

else
        echo '###please run backup.sh first!!!###'
fi

