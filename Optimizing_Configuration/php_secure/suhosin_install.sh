#!/bin/bash
CONF_PATH=`find  /  -name  "php.ini"`

SUM=`find  /  -name "phpize"  -a -type f  -a  -perm +111 | wc  -l`

if  [ $SUM  -eq  0  ]
then
	yum clean all

	yum repolist

	`rpm -qa | grep "php-devel"`  ||  yum install -y php-devel
else
fi


yum  install  -y  gcc

INSTALL_PATH=`find  /  -name  "suhosin-0.9.35.tgz"`   

tar  -zxvf   $INSTALL_PATH -C   /usr/local/resault/

cd   /usr/local/resault/suhosin-0.9.35


#running  phpize

`find  /  -name "phpize"  -a -type f  -a  -perm +111`

PHP_CONFIG=`find  /  -name "php-config"  -a -type f  -a  -perm +111`

./configure   --with-php-config=$PHP_CONFIG

make   &&  make  install  


if  [ -f /usr/lib64/php/modules/suhosin.so ] 
then
	echo  'extension=suhosion.so'   >>  $CONF_PATH 
	echo  'suhosin.executor.disable_eval = on'  >>  $CONF_PATH
	
	rm  -rf  /usr/local/resault/suhosin-0.9.35
else
	echo 'suhosin module is not exist!!!'
fi









