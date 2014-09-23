#!/bin/bash
#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 验证当前的用户是否为root账号，不是的话退出当前脚本
[ `id  -u`  == 0 ]  ||  echo "Error: You must be root to run this script, please use root to install lnmp"  ||  exit  1

cur_dir=$(pwd)

HOSTNAME="localhost"

DATA_DISK=`cat   /tmp/.mount.list`

CONFIG_PATH=`locate  config.list`

sed  -i   '/^ *$/d'    $CONFIG_PATH

NUM=`grep  -i  "domain="   $CONFIG_PATH  | wc  -l `



for  ((i=1;i<=NUM;i++))
do

	DOMAIN=`grep  -i  "domain="  $CONFIG_PATH  | sed  -n  ''$i',1p'  | awk  -F  "DOMAIN="   '{print  $2}'  |  awk   '{print  $1}'`
	DB_NAME=`grep  -i  "domain="  $CONFIG_PATH  | sed  -n  ''$i',1p'  | awk  -F  "DB_NAME="   '{print  $2}'  |  awk   '{print  $1}'`
	DB_USER_NAME=`grep  -i  "domain="  $CONFIG_PATH  | sed  -n  ''$i',1p'  | awk  -F  "DB_USER_NAME="   '{print  $2}'  |  awk   '{print  $1}'`
	DB_PASSWORD=`grep  -i  "domain="  $CONFIG_PATH  | sed  -n  ''$i',1p'  | awk  -F  "DB_PASSWORD="   '{print  $2}'  |  awk   '{print  $1}'`
	PROGRAM_TYPE=`grep  -i  "domain="  $CONFIG_PATH  | sed  -n  ''$i',1p'  | awk  -F  "PROGRAM_TYPE="   '{print  $2}'  |  awk   '{print  $1}'`
	DB_CHARACTER=`grep  -i  "domain="  $CONFIG_PATH  | sed  -n  ''$i',1p'  | awk  -F  "DB_CHARACTER="   '{print  $2}'  |  awk   '{print  $1}'`

		
	VHOST_DIR="$DATA_DISK/www/$DOMAIN"
if  [ "$PROGRAM_TYPE" == "dedecms" ]
then
	if  [ "DB_CHARACTER" == "GBK" ]
	then
		unzip  packages/DedeCMS-v5.7-20140313-GBK-SP1.zip
		\cp  -rpv  DedeCMS-V5.7-GBK-SP1/upload/*  $VHOST_DIR
		rm  -rf  DedeCMS-V5.7-GBK-SP1
	else
		tar  -zxvf  packages/DedeCMS-v5.7-20130607-UTF8-SP1.tar.gz
		\cp   -rpv  DedeCMS-V5.7-UTF8-SP1/uploads/*    $VHOST_DIR
		rm  -rf   DedeCMS-V5.7-UTF8-SP1
	fi
else
	continue
fi

	chown -R www:www  $VHOST_DIR

done




