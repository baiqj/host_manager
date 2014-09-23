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
if  [ "$PROGRAM_TYPE" == "discuz" ]
then
	if  [ "DB_CHARACTER" == "GBK" ]
	then
		unzip  packages/Discuz_X3.1_SC_GBK.zip
		\cp  -rpv  upload/*  $VHOST_DIR
		rm  -rf  upload/
	else
		unzip    packages/Discuz_X3.1_SC_UTF8.zip
		\cp  -rpv   upload/*    $VHOST_DIR
		rm  -rf   upload/
	fi
else
	continue
fi

	chown -R www:www  $VHOST_DIR

done
	


