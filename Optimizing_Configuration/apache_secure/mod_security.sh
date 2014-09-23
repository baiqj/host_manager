#!/bin/bash


##mod_security install 

CONF_PATH=`find / -name 'httpd.conf'  -a  -type f`

[ -d  /usr/local/backup ] ||  mkdir  -p  /usr/local/backup
[ -d  /usr/local/resault ] ||  mkdir  -p  /usr/local/resault

yum install libxml2 libxml2-devel httpd-devel pcre-devel curl-devel  -y


INSTALL_PATH=`find  /  -name  "modsecurity-apache_2.7.7.tar.gz"` 

tar  -zxvf  $INSTALL_PATH  -C   /usr/local/resault/
cd	/usr/local/resault/modsecurity-apache_2.7.7/
./configure
make &&  make  install 


CONF_D_PATH=`find  /  -name  "conf\.d"  -a  -type d | grep  'httpd/conf.d'`

\cp  /usr/local/resault/modsecurity-apache_2.7.7/modsecurity.conf-recommended  $CONF_D_PATH/modsecurity.conf

\cp  /usr/local/resault/modsecurity-apache_2.7.7/unicode.mapping   $CONF_D_PATH/

rm  -rf   /usr/local/resault/modsecurity-apache_2.7.7

MOD_PATH=`find  / -name  "modules" -a  -type d |  grep  httpd `
LIBXML_PATH=`find / -name "libxml2.so"`

if [ -f $MOD_PATH/mod_security2.so  -a  -f  $MOD_PATH/mod_unique_id.so ]
then
	echo  "LoadModule security2_module $MOD_PATH/mod_security2.so"  >>   $CONF_PATH
	echo  "LoadModule unique_id_module $MOD_PATH/mod_unique_id.so"  >>   $CONF_PATH
	echo  "LoadFile  $LIBXML_PATH"		>>   $CONF_PATH
else
	echo 'there is not security2.so module!!!'
fi   





