#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, use sudo sh $0"
    exit 1
fi

rm  -rf  /home/wwwroot/default;

############################
#msyql  starting....
############################
/etc/init.d/mysqld   start

############################
#nginx  starting....
############################
nginx

############################
#php-fpm  starting....
############################
/etc/init.d/php-fpm   start


DATA_DISK=`cat   /tmp/.mount.list`

CONFIG_PATH=`find   ./  -name  "config\.list"`

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

	
	VHOST_DIR="$DATA_DISK/www/$DOMAIN"
	
	access_log="y";
	
	al_name="$DOMAIN"
	  
	alf="log_format  $al_name  '\$remote_addr - \$remote_user [\$time_local] \"\$request\" '
             '\$status \$body_bytes_sent \"\$http_referer\" '
             '\"\$http_user_agent\" \$http_x_forwarded_for';"
	al="access_log  /home/wwwlogs/$al_name.log  $al_name;"
	
	echo "==========================="
	echo You access log file="$al_name.log"
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

		$al
	}
eof



cur_php_version=`/usr/local/php/bin/php -r 'echo PHP_VERSION;'`


if echo "$cur_php_version" | grep -q "5.3."
then
cat >>/usr/local/php/etc/php.ini<<eof
[HOST=$DOMAIN]
open_basedir=$VHOST_DIR/:/tmp/
[PATH=$VHOST_DIR]
open_basedir=$VHOST_DIR/:/tmp/
eof
/etc/init.d/php-fpm restart
fi




echo "Test Nginx configure file......"
/usr/local/nginx/sbin/nginx -t
echo ""

############
#MYSQL
############

create_db_mysql="create  database  ${DB_NAME}"

mysql  -h${HOSTNAME}  -P${MYSQL_PORT}   -u${MYSQL_ADMIN}   -p${MYSQL_PASSWORD}  -e  "${create_db_mysql}"  --default-character-set=utf8 -s

cat > /tmp/mysql_user_script<<EOF
create user  ${DB_USER_NAME}@${HOSTNAME};
grant all privileges on ${DB_NAME}.* to  ${DB_USER_NAME}@${HOSTNAME}  identified by  '$DB_PASSWORD';
flush privileges;
EOF

/usr/local/mysql/bin/mysql -u root -p${MYSQL_PASSWORD} -h  ${HOSTNAME} < /tmp/mysql_user_script


rm -f /tmp/mysql_sec_script

}

done

chown   www.www   -R   $DATA_DISK/www

echo   "default-character-set = utf8"    >>   /etc/my.cnf

echo  "Restart Mysql....."
/etc/init.d/mysql  restart
echo "Restart Nginx......"
/usr/local/nginx/sbin/nginx -s reload