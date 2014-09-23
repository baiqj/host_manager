#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 验证当前的用户是否为root账号，不是的话退出当前脚本
[ `id  -u`  == 0 ]  ||  echo "Error: You must be root to run this script, please use root to install lnmp"  ||  exit  1

cur_dir=$(pwd)


rm  -rf  /home/wwwroot/default;

############################
#启动mysql数据库
############################
service mysqld   restart

############################
#启动apache服务
############################
service  apache   restart


DATA_DISK=`cat   /tmp/.mount.list`

updatedb
CONFIG_PATH=`locate   config.list`

sed  -i   '/^ *$/d'    $CONFIG_PATH

NUM=`grep  -i  "domain="   $CONFIG_PATH  | wc  -l `

MYSQL_ADMIN="root"
MYSQL_PASSWORD=`grep  -i  "mysqlrootpwd"  $CONFIG_PATH | awk -F  ":" '{print  $2}'`
HOSTNAME="localhost"
MYSQL_PORT="3306"

for  ((i=1;i<=NUM;i++))
do

{
	DOMAIN=`grep  -i  "domain="  $CONFIG_PATH  | sed  -n  ''$i',1p'  | awk  -F  "DOMAIN="   '{print  $2}'  |  awk   '{print  $1}'`
	DB_NAME=`grep  -i  "domain="  $CONFIG_PATH  | sed  -n  ''$i',1p'  | awk  -F  "DB_NAME="   '{print  $2}'  |  awk   '{print  $1}'`
	DB_USER_NAME=`grep  -i  "domain="  $CONFIG_PATH  | sed  -n  ''$i',1p'  | awk  -F  "DB_USER_NAME="   '{print  $2}'  |  awk   '{print  $1}'`
	DB_PASSWORD=`grep  -i  "domain="  $CONFIG_PATH  | sed  -n  ''$i',1p'  | awk  -F  "DB_PASSWORD="   '{print  $2}'  |  awk   '{print  $1}'`
	PROGRAM_TYPE=`grep  -i  "domain="  $CONFIG_PATH  | sed  -n  ''$i',1p'  | awk  -F  "PROGRAM_TYPE="   '{print  $2}'  |  awk   '{print  $1}'`
	DB_CHARACTER=`grep  -i  "domain="  $CONFIG_PATH  | sed  -n  ''$i',1p'  | awk  -F  "DB_CHARACTER="   '{print  $2}'  |  awk   '{print  $1}'`

#创建虚拟主机vhost的网站目录	
VHOST_DIR="$DATA_DISK/www/$DOMAIN"

echo "Create Virtul Host directory......"
mkdir  -p   $VHOST_DIR
touch $VHOST_DIR/error.log
touch $VHOST_DIR/access.log

echo "set permissions of Virtual Host directory......"
chmod -R 755 $VHOST_DIR
chmod  644   $VHOST_DIR/error.log
chmod  644   $VHOST_DIR/access.log
chown -R     www:www   $VHOST_DIR


#判断是否有vhost的配置文件存放目录

[ -d  /usr/local/apache/conf/vhost ]  ||  mkdir  /usr/local/apache/conf/vhost

#生成虚拟主机vhost的配置文件
cd    /usr/local/apache/conf/vhost
cat  >$DOMAIN\.conf<<eof
<VirtualHost *:80>
ServerAdmin webmaster@example.com
DocumentRoot $VHOST_DIR
ServerName $DOMAIN
ErrorLog "$VHOST_DIR/error.log"
CustomLog "$VHOST_DIR/access.log" common
</VirtualHost>
eof
	
#返回到之前的目录中
cd  -

#为每一个vhost创建相应的数据库和对应的数据库管理账户

create_db_mysql="create  database  ${DB_NAME}"

#根据config.list中数据库的编码类型创建对应的数据库

[ "$DB_CHARACTER"  ==  "GBK" ]  &&  mysql  -h${HOSTNAME}  -P${MYSQL_PORT}   -u${MYSQL_ADMIN}   -p${MYSQL_PASSWORD}  -e  "${create_db_mysql}"  --default-character-set=GBK -s

[ "$DB_CHARACTER"  ==  "utf8" ]  &&   mysql  -h${HOSTNAME}  -P${MYSQL_PORT}   -u${MYSQL_ADMIN}   -p${MYSQL_PASSWORD}  -e  "${create_db_mysql}"  --default-character-set=utf8 -s


cat > /tmp/mysql_user_script<<EOF
create user  ${DB_USER_NAME}@${HOSTNAME};
grant all privileges on ${DB_NAME}.* to  ${DB_USER_NAME}@${HOSTNAME}  identified by  '$DB_PASSWORD';
flush privileges;
EOF

/usr/local/mysql/bin/mysql -u root -p${MYSQL_PASSWORD} -h  ${HOSTNAME} < /tmp/mysql_user_script


rm -f /tmp/mysql_sec_script

#根据config.list不同的程序类型执行不同的安装脚本


[ "$PROGRAM_TYPE"  ==  "dedecms" ]  &&   ./lamp_scripts_for_website/dedecms_5.7.sh
[ "$PROGRAM_TYPE"  ==  "discuz" ]  &&    ./lamp_scripts_for_website/discuz_x3.1.sh
[ "$PROGRAM_TYPE"  ==  "phpwind" ]  &&    ./lamp_scripts_for_website/phpwind_8.7.sh
[ "$PROGRAM_TYPE"  ==  "wordpress" ]  &&   ./lamp_scripts_for_website/wordpress_3.6.sh

}

done

echo   "default-character-set = utf8"    >>   /etc/my.cnf

echo  "Restart Mysql....."
service  mysqld  restart
echo "Restart Apache......"
service  apache  restart
