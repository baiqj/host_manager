#!/bin/bash

declare  -i  ONE=1   ZERO=0  FILE_LINE=0  CONF_LINE=0  

#定义结果文件存放目录

RESULT_PATH=/root

rm  -rf    $RESULT_PATH/*.list*

#为COUNT_*变量附初始值

for  ((i=1;i<=20;i++))
do
	declare   -i   COUNT_$i=0
done


#定位Tomcat主程序目录

WORK_DIR=`ps   aux  |  grep  -i  "tomcat"  |  grep  -i  "Dcatalina.base="  |  awk  -F  'Dcatalina.base='   '{print  $2}'  |  awk   '{print  $1}'`

#手动创建结果文件,并将安装目录输出

echo   "***********"    >>   $RESULT_PATH/Domain.list
echo   "WORK_DIR=$WORK_DIR"     >>   $RESULT_PATH/Domain.list
echo   "***********"    >>   $RESULT_PATH/Domain.list
touch   $RESULT_PATH/vhost.list
touch   $RESULT_PATH/absolute.list
touch   $RESULT_PATH/Include.list
touch   $RESULT_PATH/Include_file.list
touch   $RESULT_PATH/vhost_num.list


#提取Apache主配置文件中的有效内容到conf.list文件中

updatedb

CONF_PATH=`locate    server.xml  |   grep   $WORK_DIR`

CONF_LINE=`wc  -l   $CONF_PATH |  awk   '{print  $1}'`

#取出server.xml主配置文件中的有效内容

for  ((i=1;i<=CONF_LINE;i++))
do
	COUNT_1=`sed  -n   ''$i',1p'   $CONF_PATH  |  grep    '<!--'   |  wc  -l  | awk  '{print  $1}'`
	
	if  [ $COUNT_1  -ne  $ONE ]
	then
		sed  -n   ''$i',1p'   $CONF_PATH  >>  $RESULT_PATH/conf.list
	else
		for  ((j=i;j<=CONF_LINE;j++))
		do

			COUNT_2=`sed  -n   ''$j',1p'   $CONF_PATH  |  grep    '\-->'   |  wc  -l  | awk  '{print  $1}'`
		
		if  [ $COUNT_2 -eq  $ONE ]
		then
			i=$j
			break
		fi
		done
	fi
done


#删除行首的空格

sed   -i  's/^[[:space:]]*//g'   $RESULT_PATH/conf.list


#删除conf.list文件中的""双引号

sed  -i   's/"//g'     $RESULT_PATH/conf.list

#删除conf.list文件中的空行

sed   -i  '/^ *$/d'    $RESULT_PATH/conf.list


updatedb

CONF_PATH=`locate   $RESULT_PATH/conf.list `

CONF_LINE=`wc  -l   $CONF_PATH  |  awk   '{print    $1}'`

#统计有效的主配置文件中的vhost

#统计有效的主配置文件中的vhost

for   ((i=1;i<=CONF_LINE;i++))
do

	COUNT_3=`sed  -n   ''$i',1p'   $CONF_PATH  |  awk  '{print  $1}'  |  grep  '<Host'  |  wc  -l  |  awk   '{print  $1}'`

	if  [  $COUNT_3  -eq  $ONE ]
	then
		for  ((j=i;j<=CONF_LINE;j++))
		do
			COUNT_4=`sed  -n   ''$j',1p'   $CONF_PATH  |   grep  '</Host>' |  wc  -l  |  awk   '{print  $1}'`
				
			if  [  $COUNT_4  -eq  $ONE ]
			then
				DOMAIN=`sed  -n   ''$i','$j'p'   $CONF_PATH   |  grep  -i 'name='  |   awk   -F  "name="   '{print  $2}'  |  awk   '{print  $1}'  ` 

				echo  "DOMAIN=$DOMAIN"  >>  $RESULT_PATH/vhost.list
				
				DOCUMENT=`sed   -n   ''$i','$j'p'    $CONF_PATH |grep   -i  "docBase="   | awk  -F  "docBase="  '{print  $2}'  |  awk  '{print $1}'`
				
				echo  "DOCUMENT=$DOCUMENT"  >>  $RESULT_PATH/vhost.list
				
				echo  "####"   >>  $RESULT_PATH/vhost.list 
				i=$j;
				break
			fi
		done
	fi
	
done


#将vhost.list中的相对路径使用WORK_DIR补全，并输出到Domain.list

FILE_LINE=`wc  -l  $RESULT_PATH/vhost.list   |  awk  '{print  $1}' `

for  ((i=1;i<=FILE_LINE;i++))
do
	COUNT_13=`sed   -n  ''$i',1p'   $RESULT_PATH/vhost.list   | grep  "DOCUMENT=" |  wc  -l  |  awk   '{print  $1}'`

	if  [  $COUNT_13 -eq  $ZERO ]
	then
		sed   -n  ''$i',1p'   $RESULT_PATH/vhost.list   >>  $RESULT_PATH/Domain.list
		
	else
		COUNT_14=`sed   -n  ''$i',1p'   $RESULT_PATH/vhost.list  |   grep  "=/"   |  wc  -l   |  awk  '{print  $1}'`
		
		if  [ $COUNT_14  -eq   $ONE  ]
		then
			sed   -n  ''$i',1p'   $RESULT_PATH/vhost.list   >>  $RESULT_PATH/Domain.list
		else
			NAME=`sed   -n  ''$i',1p'   $RESULT_PATH/vhost.list  |   awk   -F   "="   '{print  $2}'`

			echo  "DOCUMENT=$WORK_DIR/webapps/$NAME"  >>  $RESULT_PATH/Domain.list

		fi
	fi
done
	
cat  $RESULT_PATH/Domain.list   >> $RESULT_PATH/Summary.list 
