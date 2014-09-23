#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
###################################
#安装PHP的Suhosin保护模块作为PHP的扩展，并不会对PHP打补丁并进行重新编译
###################################

# 验证当前的用户是否为root账号，不是的话退出当前脚本
[ `id  -u`  == 0 ]  ||  echo "Error: You must be root to run this script, please use root to install lnmp"  ||  exit  1

#检测系统是不是CentOS，如果不是，提醒用户暂时不支持

cat  /etc/issue  |  grep  -iw  "CENTOS"

[ `echo  $?` != 0 ]  &&  exit  1

#安装wget
yum  install  -y   wget

#安装了locate
yum  install  -y  mlocate 
updatedb

#定位PHP的执行命令的位置
COMMAND_PATH=`locate  php  |  grep  "bin/php$"`

#查看PHP的配置文件的路径
CONF_PATH=`$COMMAND_PATH  --ini  |  grep  "^Loaded"  |  awk  -F  ':'  '{print  $2}'`


SUM=`find  /  -name "phpize"  -a -type f  -a  -perm +111 | wc  -l`

if  [ $SUM  ==  0  ]
then
	yum clean all

	yum repolist

	`rpm -qa | grep "php-devel"`  ||  yum install -y php-devel
else
fi


yum  install  -y  gcc

#下载suhosin软件包

wget  -O   suhosin-0.9.35.tgz   http://bcs.duapp.com/linux2host2manager/%2Fpackages2%2Fsuhosin-0.9.35.tgz?sign=MBO:E64167e555322cbfb5997582b43a551b:00vdSngm9btjNSgAGBePRAwD0Og%3D
  

tar  -zxvf   suhosin-0.9.35.tgz  -C   /usr/local/

cd   /usr/local/suhosin-0.9.35


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










