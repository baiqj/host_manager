#!/bin/bash


##mod_evasive install 

CONF_PATH=`find / -name 'httpd.conf'  -a  -type f`

[ -d  /usr/local/backup ] ||  mkdir  -p  /usr/local/backup
[ -d  /usr/local/resault ] ||  mkdir  -p  /usr/local/resault

yum install libxml2 libxml2-devel httpd-devel pcre-devel curl-devel  -y


INSTALL_PATH=`find  /  -name  "mod_evasive_1.10.1.tar.gz"` 

tar  -zxvf  $INSTALL_PATH  -C   /usr/local/resault/
cd      /usr/local/resault/mod_evasive/

apxs   -i  -a  -c  /usr/local/resault/mod_evasive/mod_evasive20.c

cat   <<EOF>>   $CONF_PATH
<IfModule mod_evasive20.c>
    DOSHashTableSize    3097
    DOSPageCount        5
    DOSSiteCount        50
    DOSPageInterval     1
    DOSSiteInterval     1
    DOSBlockingPeriod   360
</IfModule>
EOF




