#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 验证当前的用户是否为root账号，不是的话退出当前脚本
[ `id  -u`  == 0 ]  ||  echo "Error: You must be root to run this script, please use root to install lnmp"  ||  exit  1

#检测系统是不是CentOS，如果不是，提醒用户暂时不支持

cat  /etc/issue  |  grep  -iw  "CENTOS"

[ `echo  $?` != 0 ]  &&  exit  1

#安装wget
yum  install  -y   wget

#安装了locate
yum  install  -y  mlocate 

#下载安装包
wget  -O  falcon-master.zip   http://bcs.duapp.com/linux2host2manager/%2Fpackages2%2Ffalcon-master.zip?sign=MBO:E64167e555322cbfb5997582b43a551b:WXo6hJE2LWS%2FBQ0ClrTKWbYoDDM%3D

##################################################################
#下载inotify.h头文件

wget  -O inotify.tar.gz   下载地址
tar -zxvf   inotify.tar.gz 

mkdir  -p   /usr/include/sys
cp  inotify.h  inotify-syscalls.h  /usr/include/sys/
################################################################
#获取安装包inotify-tools

#wget  http://cloud.github.com/downloads/rvoicilas/inotify-tools/inotify-tools-3.14.tar.gz


#安装编译器
yum  install  gcc  -y  

#编译安装inotify-tools
tar  -zxvf  inotify-tools-3.14.tar.gz 
cd  inotify-tools-3.14
./configure --prefix=/usr/local && make &&  make install

#安装mysql-devel

yum  install  mysql-devel  -y  
#

#解压安装包
yum install  unzip  -y
cd   ../
unzip   falcon-master.zip


#判断检测程序编译环境是否具备
cd  falcon-master/Release/
chmod  +x   check.sh
./check.sh


#第二步，安装Falcon控制中心
updatedb
CONFIG_PATH=`locate   config.list`

MYSQL_ADMIN="root"
MYSQL_PASSWORD=`grep  -i  "mysqlrootpwd"  $CONFIG_PATH | awk -F  ":" '{print  $2}'`
HOSTNAME="localhost"
MYSQL_PORT="3306"


#根据数据库的信息：主机名称、管理员密码等修改 文件./falconconsole/public/config.inc.php
<?php
// 数据库信息
$dbhost = "localhost";                                  // 数据库主机名
$dbuser = "root";                                       // 数据库用户名
$dbpass = "123456";                                             // 数据库密码
$dbname = "falcondb";                                   // 数据库名

// 数据表名
$table1 = "f_user";
$table2 = "f_monitor";

//分页配置
$pagenumber = 10//每页显示监控信息条数，默认每页显示10条
?>
~
#修改配置文件中的数据库连接信息，如果控制中心与监控程序没有安装在同一台主机，请确保被监控主机能够有权访问到控制中心所在主机的Mysql数据库
#备注：此处我们的监控和被监控在同一台主机上

#运行install.php安装控制中心

#怎么运行

 cp  -rpv  falconconsole/  /var/www/html/

第三步，修改监控程序配置文件并编译

这里主要设置数据库连接相关信息，需要监控的Web目录以"/"结尾
vim src/conf/global.conf
make
第四步，后台运行监控程序

nohup ./falcon start >falcon.log 2>&1 &
ps aux|grep "falcon"
root 2981 0.2 0.3 9352 1848 pts/0 S 04:46 0:00 ./falcon start

程序将在当前运行目录下生成日志文件falcon.log
可通过访问控制中心查看监控详情(e.g. http://127.0.0.1/falconconsole/index.php)