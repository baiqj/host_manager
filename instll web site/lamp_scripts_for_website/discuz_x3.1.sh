#!/bin/bash
#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#备注：当前的脚本近使用与rpm安装的LAMP环境，如果是编译安装的LAMP则需要对脚本进行修改

# 验证当前的用户是否为root账号，不是的话退出当前脚本
[ `id  -u`  == 0 ]  ||  echo "Error: You must be root to run this script, please use root to install lnmp"  ||  exit  1

cur_dir=$(pwd)

HOSTNAME="localhost"

#当没有额外的数据磁盘时，是不会有/tmp/.mount.list文件的   可以使用/var目录或另外指定目录
[ -f  /tmp/.mount.list  ] &&  DATA_DISK=`cat   /tmp/.mount.list`  ||  DATA_DISK="/var" 

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
		wget  -O  Discuz_X3.1_SC_GBK.zip    http://bcs.duapp.com/linux2host2manager/%2Fshell_packages%2FDiscuz_X3.1_SC_GBK.zip?sign=MBO:E64167e555322cbfb5997582b43a551b:slsFpFE4TDOM1ERCapaqTbYpcKU%3D
		unzip  Discuz_X3.1_SC_GBK.zip
		\cp  -rpv  upload/*  $VHOST_DIR
		rm  -rf  upload/
	else
		wget  -O  Discuz_X3.1_SC_UTF8.zip  http://bcs.duapp.com/linux2host2manager/%2Fshell_packages%2FDiscuz_X3.1_SC_UTF8.zip?sign=MBO:E64167e555322cbfb5997582b43a551b:g1m3LRdze1jmH44i5sV3N7ek7mk%3D
		unzip    Discuz_X3.1_SC_UTF8.zip
		\cp  -rpv   upload/*    $VHOST_DIR
		rm  -rf   upload/
	fi
else
	continue
fi

	chown -R apache:apache  $VHOST_DIR

done
	


