#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 验证当前的用户是否为root账号，不是的话退出当前脚本
[ `id  -u`  == 0 ]  ||  echo "Error: You must be root to run this script, please use root to install lnmp"  ||  exit  1

cd ./packages


tar zxvf autoconf-2.13.tar.gz
cd autoconf-2.13/
./configure --prefix=/usr/local/autoconf-2.13
make && make install
cd  ../

tar -zxvf libiconv-1.13.1.tar.gz
cd libiconv-1.13.1
./configure --prefix=/usr/local/libiconv
make  &&  make install
cd  ../



tar zxvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8/
./configure
make && make install

ldconfig

cd libltdl/

./configure --enable-ltdl-install
make && make install
cd ../../




tar zxvf mhash-0.9.9.9.tar.gz
cd mhash-0.9.9.9/
./configure
make && make install

cd ../


 cat  <<EOF>>  /etc/ld.so.conf
[html]
/usr/local/lib
EOF

ldconfig

tar -zxvf mcrypt-2.6.8.tar.gz
cd mcrypt-2.6.8/
./configure
make && make install

echo  "/usr/local/mysql/lib"   >>  /etc/ld.so.conf

ldconfig 

cd  ../

echo  "/usr/local/libiconv/"    >>  /etc/ld.so.conf
ldconfig

tar zxvf php-5.5.7.tar.gz
cd php-5.5.7/

rm  -rf    /usr/lib/mysql
ln -s /usr/lib64/mysql/  /usr/lib/mysql
 

#检测是否安装了nginx，如果存在/usr/local/nginx，则认为是安装lnmp的环境，为nginx编译配置php 
if  [ -d   /usr/local/nginx   ]

#install php-5.5.7 for nginx" 

then

./configure --prefix=/usr/local/php  \
--with-config-file-path=/usr/local/php/etc    \
--with-mysql=/usr/local/mysql  --with-mysqli=/usr/local/mysql/bin/mysql_config   \
--with-mysql-sock=/tmp/mysql.sock --with-iconv-dir=/usr/local/libiconv   \
--with-iconv  --with-freetype-dir --with-jpeg-dir --with-png-dir \
--with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-fpm \
--enable-magic-quotes --enable-safe-mode --enable-bcmath \
--enable-shmop --enable-sysvsem --enable-inline-optimization \
--with-curl --with-curlwrappers --enable-mbregex  --enable-mbstring \
--with-mcrypt --enable-ftp --with-gd --enable-gd-native-ttf \
--with-openssl --with-mhash --enable-pcntl --enable-sockets \
--with-xmlrpc --enable-zip --enable-soap --without-pear --with-gettext  \
 --with-fpm-user=www  --with-fpm-group=www --enable-fastcgi 

make ZEND_EXTRA_LIBS='--liconv'

make install

cd  ../

tar -zxf PDO_MYSQL-1.0.2.tgz
ln -s /usr/local/mysql/include/* /usr/local/include/
cd PDO_MYSQL-1.0.2
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --with-pdo-mysql=/usr/local/mysql
make && make install

cd  ../

\cp   -rpv   ../conf/php*     /usr/local/php/etc/

mkdir  -p    /usr/local/zend
\cp   -rpv    ZendGuardLoader.so    /usr/local/zend/

cd  php-5.5.7/  

#设置php-fpm开机启动
\cp  sapi/fpm/init.d.php-fpm   /etc/init.d/php-fpm
chmod a+x  /etc/init.d/php-fpm  
chkconfig --add php-fpm
chkconfig  php-fpm  on
service  php-fpm   restart

elif   [ -d   /usr/local/apache  ]
# install php-5.5.7 for apache

then
./configure --prefix=/usr/local/php   \
--with-config-file-path=/usr/local/php/etc   \
--with-mysql=/usr/local/mysql \
--with-mysqli=/usr/local/mysql/bin/mysql_config  \
--with-mysql-sock=/tmp/mysql.sock \
--with-iconv-dir=/usr/local/libiconv   \
--with-iconv   --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib \
--with-libxml-dir=/usr --enable-xml --disable-rpath  --enable-magic-quotes \
--enable-safe-mode --enable-bcmath --enable-shmop --enable-sysvsem \
--enable-inline-optimization --with-curl --with-curlwrappers \
--enable-mbregex  --enable-mbstring --with-mcrypt --enable-ftp \
--with-gd --enable-gd-native-ttf --with-openssl --with-mhash \
--enable-pcntl --enable-sockets --with-xmlrpc --enable-zip \
--enable-soap --without-pear --with-gettext   \
--with-apxs2=/usr/local/apache/bin/apxs   --enable-zend-multibyte

make ZEND_EXTRA_LIBS='--liconv'

make install

cd  ../

tar -zxf PDO_MYSQL-1.0.2.tgz
ln -s /usr/local/mysql/include/* /usr/local/include/
cd PDO_MYSQL-1.0.2
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --with-pdo-mysql=/usr/local/mysql
make && make install

cd  ../

cd  php-5.5.7/  

mkdir   -p   /usr/local/php/etc
cp  php.ini-production    /usr/local/php/etc/php.ini

ldconfig

cd ../../

echo  "AddType application/x-httpd-php .php"     >>   /usr/local/apache/conf/httpd.conf

fi


sed -i 's#extension_dir = "./"#extension_dir = "/usr/local/php/lib/php/extensions/no-debug-non-zts-20090626/"\nextension = "pdo_mysql.so"\n#' /usr/local/php/etc/php.ini
sed -i 's#output_buffering = Off#output_buffering = On#' /usr/local/php/etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 50M/g' /usr/local/php/etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 50M/g' /usr/local/php/etc/php.ini
sed -i 's/;date.timezone =/date.timezone = PRC/g' /usr/local/php/etc/php.ini
sed -i 's/short_open_tag = Off/short_open_tag = On/g' /usr/local/php/etc/php.ini
sed -i 's/; cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /usr/local/php/etc/php.ini
sed -i 's/; cgi.fix_pathinfo=0/cgi.fix_pathinfo=0/g' /usr/local/php/etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /usr/local/php/etc/php.ini
sed -i 's/disable_functions =.*/disable_functions = passthru,exec,system,chroot,scandir,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server/g' /usr/local/php/etc/php.ini

chown   -R   www:www    /usr/local/php





