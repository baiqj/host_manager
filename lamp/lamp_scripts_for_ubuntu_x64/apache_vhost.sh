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
#apache  starting....
############################
/etc/init.d/httpd   start


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

echo "Create Virtul Host directory......"
mkdir  -p   $VHOST_DIR
touch $VHOST_DIR/error.log
touch $VHOST_DIR/access.log

echo "set permissions of Virtual Host directory......"
chmod -R 755 $VHOST_DIR
chmod  644   $VHOST_DIR/error.log
chmod  644   $VHOST_DIR/access.log
chown -R     www:www $VHOST_DIR


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


echo   "default-character-set = utf8"    >>   /etc/my.cnf

echo  "Restart Mysql....."
/etc/init.d/mysqld  restart
echo "Restart Apache......"
/usr/local/apache/bin/apachectl  restart
