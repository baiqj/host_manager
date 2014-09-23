#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi



echo "============================Install MySQL 5.5.28=================================="

#检测系统是否有mysql用户，如果没有则添加mysql，若有，则不添加

id   mysql
if  [ `echo  $?` != 0 ]
then
	groupadd mysql
	useradd -s /sbin/nologin -g mysql mysql
fi


CONF_PATH=`find  ./   -name  "config.list"`
mysqlrootpwd=`grep  -i  "mysqlrootpwd"  $CONF_PATH  |  awk  -F ":"  '{print  $2}'`
mv /etc/my.cnf /etc/my.cnf.bak

cd ./packages/
tar zxvf mysql-5.5.28.tar.gz
cd  mysql-5.5.28/
#cmake   --prefix=/usr/local/mysql --with-extra-charsets=complex --enable-thread-safe-client --enable-assembler --with-mysqld-ldflags=-all-static --with-charset=utf8 --enable-thread-safe-client --with-big-tables --with-readline --with-ssl --with-embedded-server --enable-local-infile

cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EXTRA_CHARSETS:STRING=utf8,gbk \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DMYSQL_USER=mysql \
-DMYSQL_TCP_PORT=3306

make && make install

cp /usr/local/mysql/support-files/my-medium.cnf   /etc/my.cnf
sed -i 's/skip-locking/skip-external-locking/g' /etc/my.cnf
/usr/local/mysql/scripts/mysql_install_db --user=mysql   --basedir=/usr/local/mysql  --datadir=/usr/local/mysql/data
chown -R mysql /usr/local/mysql/data
chgrp -R mysql /usr/local/mysql/.
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod 755 /etc/init.d/mysql

cat > /etc/ld.so.conf.d/mysql.conf<<EOF
/usr/local/mysql/lib/mysql
/usr/local/lib
EOF
ldconfig

ln -s /usr/local/mysql/lib/mysql /usr/lib/mysql
ln -s /usr/local/mysql/include/mysql /usr/include/mysql

rm  -rf   /etc/mysql/my.cnf

/etc/init.d/mysqld start

ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
ln -s /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump
ln -s /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk
ln -s /usr/local/mysql/bin/mysqld_safe /usr/bin/mysqld_safe

/usr/local/mysql/bin/mysqladmin -u root password $mysqlrootpwd

cat > /tmp/mysql_sec_script<<EOF
use mysql;
delete from user where not (user='root') ;
delete from user where user='root' and password=''; 
drop database test;
DROP USER ''@'%';
flush privileges;
EOF

/usr/local/mysql/bin/mysql -u root -p$mysqlrootpwd -h localhost < /tmp/mysql_sec_script

rm -f /tmp/mysql_sec_script

/etc/init.d/mysqld restart
/etc/init.d/mysqld stop
cd ..
echo "============================MySQL 5.5.28 install completed========================="
