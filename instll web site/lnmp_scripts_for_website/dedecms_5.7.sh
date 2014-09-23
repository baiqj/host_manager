#!/bin/bash
#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#备注：当前的脚本近使用与rpm安装的LAMP环境，如果是编译安装的LAMP则需要对脚本进行修改

# 验证当前的用户是否为root账号，不是的话退出当前脚本
[ `id  -u`  == 0 ]  ||  echo "Error: You must be root to run this script, please use root to install lnmp"  ||  exit  1

cur_dir=$(pwd)

HOSTNAME="localhost"

#当没有额外的数据磁盘时，是不会有/tmp/.mount.list文件的   可以使用/usr/share/nginx/html目录或另外指定目录
[ -f  /tmp/.mount.list  ] &&  DATA_DISK=`cat   /tmp/.mount.list`  ||  DATA_DISK="/usr/share/nginx/html" 

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
		wget  -O  DedeCMS-v5.7-20140313-GBK-SP1.zip   http://bcs.duapp.com/linux2host2manager/%2Fshell_packages%2FDedeCMS-v5.7-20140313-GBK-SP1.zip?sign=MBO:E64167e555322cbfb5997582b43a551b:Ql%2ByZlS8fjJKP0eumWXKJVEKsuc%3D下载地址
		unzip  packages/DedeCMS-v5.7-20140313-GBK-SP1.zip
		\cp  -rpv  DedeCMS-V5.7-GBK-SP1/upload/*  $VHOST_DIR
		rm  -rf  DedeCMS-V5.7-GBK-SP1
	else
		wget  -O   DedeCMS-v5.7-20130607-UTF8-SP1.tar.gz   http://bcs.duapp.com/linux2host2manager/%2Fshell_packages%2FDedeCMS-v5.7-20130607-UTF8-SP1.tar.gz?sign=MBO:E64167e555322cbfb5997582b43a551b:8jfaCaYUOMgjOlm%2FAwaeDzIgpBQ%3D
		tar  -zxvf  DedeCMS-v5.7-20130607-UTF8-SP1.tar.gz
		\cp   -rpv  DedeCMS-V5.7-UTF8-SP1/uploads/*    $VHOST_DIR
		rm  -rf   DedeCMS-V5.7-UTF8-SP1
	fi
else
	continue
fi

	chown -R apache:apache  $VHOST_DIR

done




