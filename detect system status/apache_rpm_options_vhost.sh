#!/bin/bash

##############################
#判断RPM安装的apache是否启用的vhost功能
##############################
updatedb

ENV_PATH="../env_config"

CONF="/etc/httpd/conf/httpd.conf"

#定位安装目录
ServerRoot=`grep   -iw  "serverroot"   $CONF |  grep  -v  "^#"  |  awk  '{print $2}'  |  awk  -F  '"'  '{print  $2}'`

grep -v  "^#"  $CONF  | grep  -iw  "NameVirtualHost"  |  grep  -v  "^#"

#判断httpd.conf中是否包含 "NameVirtualHost"
if [ `echo  $?` == 0 ]

then
	#查看"Rpm_Vhost"所在的行号

	LINE_NUM=`grep  -n  "Rpm_Vhost"   $ENV_PATH  |  awk -F:  '{print $1}'`

	#在"Rpm_Vhost"行之后添加一行

	sed  -ie  "/Rpm_Vhost/a \'Rpm_Vhost\':\'On\'" $ENV_PATH

	#删除原来的"Rpm_Vhost"行

	sed -i  ''$LINE_NUM'd'   $ENV_PATH
	
	#如果包含了有效的NameVirtualHost，退出当前脚本
	exit  0
fi


#如果httpd.conf中不包含"NameVirtualHost",查看Include文件中是否包含"NameVirtualHost"
#之后判断Include包含的文件中是否有NameVirtualHost虚拟主机配置
#将http.conf中Include包含的目录列表放到当前目录的include.tmp文件中
grep  -v  "^#"   $CONF  |  grep  -iw "^include"  | awk  '{print  $2}' >>  ./include.tmp

COUNT=`wc -l  include.tmp | awk  '{print $1}'`
	
#依次将include中的相对路径转换成绝对路径

for  ((i=1;i<=COUNT;i++))
do
	DIR=`sed  -n  ''$i',1p'   ./include.tmp  | grep  "^/"`
#根据返回值判断是绝对路径还是相对路径。返回值为0为绝对路径
	if [  `echo  $?` != 0 ]  
	then
			echo  $ServerRoot/$DIR   >>   include.tmp
	fi
done


#判断并删除cache.tmp中包含"*"号的行

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

#将包含关键字NameVirtualHost的文件路径存放到cache.tmp文件中

COUNT=`wc -l  include.tmp | awk  '{print $1}'`

for  ((i=1;i<=COUNT;i++))
do
	sed  ''$i',1p'  include.tmp  |  grep  -i  "NameVirtualHost"  |  grep  -v  "^#"
	if  [ `echo  $?` == 0 ]
	then
	#查看"Apache_Rpm_Vhost"所在的行号

	LINE_NUM=`grep  -n  "Apache_Rpm_Vhost"   $ENV_PATH  |  awk -F:  '{print $1}'`

	#在"Apache_Rpm_Vhost"行之后添加一行

	sed  -ie  "/Apache_Rpm_Vhost/a \'Apache_Rpm_Vhost\':\'On\'" $ENV_PATH

	#删除原来的"Apache_Rpm_Vhost"行

	sed -i  ''$LINE_NUM'd'   $ENV_PATH
	
	#如果包含了有效的NameVirtualHost，退出当前脚本
	rm  -rf   ./cache.tmp
	rm  -rf   ./include.tmp
	exit  0
	fi
done

#当所有的文件中都不包含"NameVirtualHost"时，表示不启用虚拟主机功能
sed  -ie  "/Apache_Rpm_Vhost/a \'Apache_Rpm_Vhost\':\'Off\'" $ENV_PATH
rm  -rf   ./cache.tmp
rm  -rf   ./include.tmp

