#!/bin/bash

##############################
#判断MAKE安装的nginx的虚拟主机的个数
##############################
updatedb

ENV_PATH="../env_config"
VALUE=0
#查看make编译安装的nginx命令路径

CMD=`locate nginx   |  grep  "\/nginx$"    |  grep   -i  "\/*nginx*\/"`

#判断是否存在编译安装生成的nginx命令文件，没有的话退出当前脚本
[  `echo  $?`  ==  0 ]   ||  exit  1


#查看nginx编译时的参数

$CMD  -V  &>   ./cache.tmp

#查看编译安装的主配置文件的路径

DOCUMENT=`cat  ./cache.tmp  |   grep  -i "configure *arguments"  |  awk -F '--prefix='  '{print $2}'  |  awk  '{print  $1}'`

CONF=`locate  "nginx.conf"  |  grep  "$DOCUMENT"  |  | grep  "\/conf\/"  grep  "\/nginx.conf$"`

rm  -rf   ./cache.tmp

#判断nginx.conf中包含"server_name"的个数

grep -v  "^#"  $CONF  | grep  -iw  "server_name" 

if [ `echo  $?` == 0 ]
then
	VALUE=`grep -v  "^#"  $CONF  | grep  -iw  "server_name"  |  wc  -l`
fi


#之后判断Include包含的文件中是否有"server_name"
#将nginx.conf中Include包含的目录列表放到当前目录的include.tmp文件中
grep  -iw "include"  $CONF |grep  -v  "^#"   | awk  '{print  $2}' >>  ./include.tmp

COUNT=`wc -l  include.tmp | awk  '{print $1}'`
	
#依次将include中的相对路径转换成绝对路径

for  ((i=1;i<=COUNT;i++))
do
	DIR=`sed  -n  ''$i',1p'   ./include.tmp  | grep  "^/"`
#根据返回值判断是绝对路径还是相对路径。返回值为0为绝对路径
	if [  `echo  $?` != 0 ]  
	then
			echo  $DOCUMENT/conf/$DIR   >>   include.tmp
	fi
done


#判断并删除include.tmp中包含"*"号的行

COUNT=`wc -l  include.tmp | awk  '{print $1}'`

for  ((i=1;i<=COUNT;i++))
do
	sed  ''$i',1p'  include.tmp  |  grep  '*'
	if  [ `echo  $?` == 0 ]
	then
		ll  `sed  -n  ''$i',1p'  include.tmp`  |  awk  '{print  $9}'  >>  include.tmp
	fi
done

#删除include.tmp中的相对路径和包含"*"号的行
sed  -i  '/*/d'  include.tmp 

#删除include.tmp中的相对路径
sed  -i  '/^\//!d'   include.tmp 

#将包含关键字"server_name"的文件路径存放到cache.tmp文件中

COUNT=`wc -l  include.tmp | awk  '{print $1}'`

for  ((i=1;i<=COUNT;i++))
do
	sed  ''$i',1p'  include.tmp  |  grep  -iw  "server_name"  |  grep  -v  "^#"
	if  [ `echo  $?` == 0 ]
	then
	
		VALUE=`expr $VALUE + 1`
	fi
done


#查看"Nginx_Make_Vhost_Num"所在的行号

LINE_NUM=`grep  -n  "Nginx_Make_Vhost_Num"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Nginx_Make_Vhost_Num"行之后添加一行

	sed  -ie  "/Nginx_Make_Vhost_Num/a \'Nginx_Make_Vhost_Num\':\'$VALUE\'" $ENV_PATH

#删除原来的"Nginx_Make_Vhost_Num"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH
	
rm  -rf   ./cache.tmp
rm  -rf   ./include.tmp
	







			



