#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

########################################
#用于已有的make安装的mysql数据库的本地备份迁移，让出/usr/local/mysql目录
#执行脚本完成后，手动启动源mysql的命令：/usr/local/mysql3307/bin/mysqld_safe --basedir=/usr/local/mysql3307  --datadir=/usr/local/mysql3307/var  --plugin-dir=/usr/local/mysql3307/lib/plugin --user=mysql --log-error=/usr/local/mysql3307/var/localhost.localdomain.err --pid-file=/usr/local/mysql3307/var/localhost.localdomain.pid  --socket=/tmp/mysql3307.sock   --port=3307  &
#########################################

updatedb

ENV_PATH=../../env_config

#查看mysql是否在运行，正在运行的话退出当前脚本
ps  -ef  |  grep  mysqld  |  grep  -v  "grep" 

[ `echo  $?` == 0 ] &&  exit  1

[ rpm  -q   mysql-server ] &&  exit  1


#创建原有的mysql的备份目录
mkdir -p  /usr/local/mysql3307
chmod +w /usr/local/mysql3307
chown -R mysql:mysql /usr/local/mysql3307

\cp   -rpv  /etc/my.cnf     /etc/my.cnf.bak

#删除所有的注释行
sed  -i   '/#/d'  /etc/my.cnf
#删除所有的空行
sed  -i   '/^$/d'  /etc/my.cnf

#需要查找mysql的安装目录
DOCUMENT=`locate  mysqladmin  |  grep "\/mysqladmin$"   | grep "mysql"  | grep  "\/bin\/"  |  awk -F "/bin"   '{print  $1}'`

#查看原有my.cnf中配置的数据目录
DATADIR=`grep   '\[mysqld\]'  -A4   /etc/my.cnf   |  grep  "datadir" | awk -F "="  '{print $2}'`

#下面的if判断用于设置迁移datadir

if  [ `echo $?` != 0 ]
then
#复制mysql数据库，并添加datadir设置
	\cp  -rpv  $DOCUMENT/*    /usr/local/mysql3307/
	\cp  -rpv /etc/my.cnf    /usr/local/mysql3307/var/my_3307.cnf
	sed -e "/^\[mysqld\]$/a  datadir = /usr/local/mysql3307/var " -i      /usr/local/mysql3307/var/my_3307.cnf
else
	grep   '\[mysqld\]'  -A4   /etc/my.cnf   |  grep  "datadir" | awk -F "="  '{print $2}'  >  ./datadir
	echo `locate  mysqladmin  |  grep "\/mysqladmin$"   | grep "mysql"  | grep  "\/bin\/"  |  awk -F "/bin"   '{print  $1}'`/var >>  ./datadir
#删除行首的空格
	sed -i     's/^[[:space:]]*//g'   ./datadir
#统计删除重复行剩余的行数
	VALUE=`sort -u   ./datadir  |  wc  -l`
	
	if  [ $VALUE == 1 ]
	then
#如果datadir=安装目录/var，则删除该设置并重新添加一行设置新的datadir
		\cp  -rpv  $DOCUMENT/*    /usr/local/mysql3307/
		\cp  -rpv /etc/my.cnf    /usr/local/mysql3307/var/my_3307.cnf
		sed  -i  '/datadir /d'   /usr/local/mysql3307/var/my_3307.cnf
		sed -e "/^\[mysqld\]$/a  datadir = /usr/local/mysql3307/var " -i      /usr/local/mysql3307/var/my_3307.cnf
	else
		exit  0
	fi
rm   -rf   ./datadir
fi

#将端口由3306更改为3307
 sed  -i  's/3306/3307/g'   /usr/local/mysql3307/var/my_3307.cnf
#更改socket路径
 sed -i 's/mysql.sock/mysql3307.sock/g'   /usr/local/mysql3307/var/my_3307.cnf
 
 

 


