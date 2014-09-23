#!/bin/bash

# 验证当前的用户是否为root账号，不是的话退出当前脚本
[ `id  -u`  == 0 ]  ||  echo "Error: You must be root to run this script, please use root to install lnmp"  ||  exit  1

rm  -rf  /home/wwwroot/default;

############################
#msyql  starting....
############################
service  mysqld   restart

############################
#nginx  starting....
############################
nginx

############################
#php-fpm  starting....
############################
service  php-fpm   restart


DATA_DISK=`cat   /tmp/.mount.list`

update
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

	
	VHOST_DIR="$DATA_DISK/www/$DOMAIN"
	
	access_log="y";
	
	al_name="$DOMAIN"
	  
	alf="log_format  $al_name  '\$remote_addr - \$remote_user [\$time_local] \"\$request\" '
             '\$status \$body_bytes_sent \"\$http_referer\" '
             '\"\$http_user_agent\" \$http_x_forwarded_for';"
	
	echo "==========================="
	echo You access log file=$VHOST_DIR/$al_name.log
	echo "==========================="


echo "Create Virtul Host directory......"
mkdir -p $VHOST_DIR
touch $VHOST_DIR/$al_name.log
echo "set permissions of Virtual Host directory......"
chmod -R 755 $VHOST_DIR
chmod  644   $VHOST_DIR/$al_name.log
chown -R www:www $VHOST_DIR


if [ ! -d /usr/local/nginx/conf/vhost ]; then
	mkdir /usr/local/nginx/conf/vhost
fi

cat >/usr/local/nginx/conf/vhost/$DOMAIN.conf<<eof
$alf
server
	{
		listen       80;
		server_name $DOMAIN;
		index index.html index.htm index.php default.html default.htm default.php;
		root  $VHOST_DIR;

		location ~ .*\.(php|php5)?$
			{
				try_files \$uri =404;
				fastcgi_pass  unix:/tmp/php-cgi.sock;
				fastcgi_index index.php;
				include fcgi.conf;
			}

		location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
			{
				expires      30d;
			}

		location ~ .*\.(js|css)?$
			{
				expires      12h;
			}

		access_log  $VHOST_DIR/$al_name.log  $al_name;
	}
eof


############
#MYSQL
############

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


[ "$PROGRAM_TYPE"  ==  "dedecms" ]  &&   ./lnmp_scripts_for_website/dedecms_5.7.sh
[ "$PROGRAM_TYPE"  ==  "discuz" ]  &&    ./lnmp_scripts_for_website/discuz_x3.1.sh
[ "$PROGRAM_TYPE"  ==  "phpwind" ]  &&    ./lnmp_scripts_for_website/phpwind_8.7.sh
[ "$PROGRAM_TYPE"  ==  "wordpress" ]  &&   ./lnmp_scripts_for_website/wordpress_3.6.sh

}

done

chown   www.www   -R   $DATA_DISK/www

echo   "default-character-set = utf8"    >>   /etc/my.cnf

echo  "Restart Mysql....."
/etc/init.d/mysqld  restart
echo "Restart Nginx......"
nginx  -s  reload
echo  "Restart php-fpm...."
service  php-fpm  restart