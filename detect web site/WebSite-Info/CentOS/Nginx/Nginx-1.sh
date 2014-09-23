#!/bin/bash

declare  -i   CONF_LINE=0  VHOST_NUM=0   ZERO=0  ONE=1  FILE_LINE=0

RESULT_PATH=/root

rm  -rf   $RESULT_PATH/*.list*

#为COUNT_*变量附初始值

for  ((i=1;i<=20;i++))
do
	declare   -i   COUNT_$i=0
done


CONF_PATH=`rpm  -qc  nginx  |  grep  'nginx\.conf'`

#提取Apache主配置文件中的有效内容到conf.list文件中

grep  -Ev  "#|^$"   $CONF_PATH  >>  $RESULT_PATH/conf.list

#删除行首的空格

sed   -i  's/^[[:space:]]*//g'   $RESULT_PATH/conf.list

#删除conf.list文件中的""双引号

sed  -i   's/"//g'     $RESULT_PATH/conf.list

#删除conf.list文件中的空行

sed   -i  '/^ *$/d'    $RESULT_PATH/conf.list


#删除conf.list文件中的；分号

sed   -i   's/;//g'     $RESULT_PATH/conf.list

#之后用到的‘CONF_PATH’都是指conf.list文件，即有效的配置内容

updatedb
CONF_PATH=`locate   $RESULT_PATH/conf.list`

#统计配置文件有效内容的行数

CONF_LINE=`wc  -l   $CONF_PATH |  awk   '{print  $1}'`

#手动创建结果文件

WORK_DIR="/etc/nginx"

echo   "***********"    >>   $RESULT_PATH/Domain.list
echo   "WORK_DIR=$WORK_DIR"     >>   $RESULT_PATH/Domain.list
echo   "***********"    >>   $RESULT_PATH/Domain.list
touch   $RESULT_PATH/vhost.list
touch   $RESULT_PATH/absolute.list
touch   $RESULT_PATH/Include.list
touch   $RESULT_PATH/Include_file.list
touch   $RESULT_PATH/vhost_num.list



#将有效的主配置文件（conf.list）中的Include包含的内容（绝对目录、绝对文件、相对目录、相对文件）生成到“Include.list”文件中
  

for   ((i=1;i<=CONF_LINE;i++))
do
	COUNT_2=`sed  -n  ''$i',1p'   $CONF_PATH   |  grep  -i   "^Include "  |  wc  -l   |  awk   '{print  $1}'`
	if  [ $COUNT_2 -eq  $ONE ]
	then
		
		sed   -n  ''$i',1p'   $CONF_PATH   | awk  '{print  $2}'  >> $RESULT_PATH/Include.list
			
	fi
done


#将Include.list文件中的路径（相对路径、绝对路径），都生成绝对路径并存放到absolute.list文件中

FILE_LINE=`wc  -l   $RESULT_PATH/Include.list |  awk   '{print  $1}'`

for  ((i=1;i<=FILE_LINE;i++))
do
	COUNT_3=`sed  -n  ''$i',1p'    $RESULT_PATH/Include.list  |  grep   "^/" | wc  -l  |  awk   '{print  $1}'`

	if  [  $COUNT_3  -eq  $ONE ]
	then
		
		sed  -n  ''$i',1p'    $RESULT_PATH/Include.list   >>  $RESULT_PATH/absolute.list
		
	elif  [ $COUNT_3  -eq  $ZERO ]
	then
		NAME=`sed  -n  ''$i',1p'  $RESULT_PATH/Include.list`
		echo   "$WORK_DIR/conf/$NAME"   >>    $RESULT_PATH/absolute.list  
		
	fi
done

#将absolute.list文件中的路径（目录或文件）包含的所有的文件到存放到Include_file.list文件中

FILE_LINE=`wc  -l  $RESULT_PATH/absolute.list  |  awk   '{print  $1}'`

for   ((i=1;i<=FILE_LINE;i++))
do
	NAME=`sed  -n   ''$i',1p'   $RESULT_PATH/absolute.list `
	updatedb
	locate   "$NAME" >>   $RESULT_PATH/Include_file.list
done



#有效的主配置文件conf.list中包含的vhost

DOCUMENT=null;
DOMAIN=null;

for  ((i=1;i<=CONF_LINE;i++))
do	
	
	  TAG_1=`sed   -n   ''$i',1p'   $CONF_PATH  | grep  -iw   "server.{"  |  wc  -l  | awk  '{print  $1}' `
	
 	
	if  [ $TAG_1 -eq  $ONE ]
	then
		for  ((j=i+1;j<=CONF_LINE;j++))
		do
			TAG_2=` sed   -n   ''$j',1p'   $CONF_PATH  | grep  -iw   "server.{"    |   wc  -l  | awk  '{print  $1}'`
			
			if   [  $TAG_2  -eq  $ONE ]
			then
				DOMAIN=`sed   -n  ''$i','$j'p'   $CONF_PATH   | grep  -iw   "^server_name"  |  awk   '{print  $2}'`
				echo  "DOMAIN=$DOMAIN"   >>   $RESULT_PATH/vhost.list	

				RELATIVE_NUM=`sed   -n   ''$i','$j'p'   $CONF_PATH  | grep   -nw   "location./"   |  awk  -F  ":"   '{print  $1}'`;

				ABSOLUTE_NUM=`expr  $RELATIVE_NUM  +  $i  - 1 `

				COUNT_3=`expr  $ABSOLUTE_NUM  +  3`
				
				
				DOCUMENT=`sed  -n  ''$ABSOLUTE_NUM','$COUNT_3'p'   $CONF_PATH  |  grep  -iw  "^root"   |   awk   '{print  $2}'`

				
				
				if   [  -z  $DOCUMENT ]
				then
					DOCUMENT=`sed  -n   ''$i','$ABSOLUTE_NUM'p'  $CONF_PATH  |  grep   -iw  "^root"  |  awk   '{print  $2}'`
					
				fi

				echo   "DOCUMENT=$DOCUMENT"  >>  $RESULT_PATH/vhost.list		
				echo  "####"  >> $RESULT_PATH/vhost.list
				
				LAST_NUM=$j;

				i=`expr  $j  - 1 `;
				
				break
			fi
			

			if   [  $j  -eq  $CONF_LINE ]
			then
				DOMAIN=`sed  -n   ''$LAST_NUM','$CONF_LINE'p'   $CONF_PATH  |   grep  -iw   "^server_name"  |  awk   '{print  $2}'`
				echo  "DOMAIN=$DOMAIN"   >>   $RESULT_PATH/vhost.list

				RELATIVE_NUM=`sed   -n   ''$LAST_NUM','$CONF_LINE'p'   $CONF_PATH  | grep  -nw  "location./"   |  awk  -F  ":"   '{print  $1}'`
				
				ABSOLUTE_NUM=`expr  $RELATIVE_NUM  +  $LAST_NUM  - 1 `

				COUNT_3=`expr   $ABSOLUTE_NUM  +  3`
				
				DOCUMENT=`sed  -n   ''$ABSOLUTE_NUM','$COUNT_3'p'   $CONF_PATH  |   grep  -iw   "^root"  |   awk   '{print  $2}' `

				if   [  -z  $DOCUMENT ]
				then
					DOCUMENT=`sed  -n   '1,'$ABSOLUTE_NUM'p'  $CONF_PATH  |  grep   -iw  "root"  |  awk   '{print  $2}'`
				fi

				echo   "DOCUMENT=$DOCUMENT"  >>  $RESULT_PATH/vhost.list	
				echo   "####"   >> $RESULT_PATH/vhost.list	 					
				DOCUMENT=null
			fi

			

			
		done
	
	fi
done



#Include包含的文件中的vhost


COUNT_4=`wc  -l   $RESULT_PATH/Include_file.list  |  awk  '{print  $1}'`

for  ((i=1;i<=COUNT_4;i++))
do	
	 NAME=`sed  -n  ''$i',1p'  $RESULT_PATH/Include_file.list`
	 FILE_LINE=`wc  -l  $NAME | awk   '{print  $1}'`
	
	 TAG_1=` grep -v  "#"   $NAME    | grep  -iw  "server.{"   |   wc  -l  | awk  '{print  $1}'`
	
	if  [ $TAG_1 -eq  $ONE ]
	then
				
		sed  -n   '1,'$FILE_LINE'p'   $NAME  |  grep  -Ev   "#|^$"    >>   $RESULT_PATH/server.list

		sed   -i  's/^[[:space:]]*//g'   $RESULT_PATH/server.list

		sed  -i   's/"//g'     $RESULT_PATH/server.list
		
		sed   -i   's/;//g'     $RESULT_PATH/server.list
				
		DOMAIN=`grep  -iw   "server_name"  $RESULT_PATH/server.list  |  awk  '{print  $2}'  `
		echo  "DOMAIN=$DOMAIN"   >>   $RESULT_PATH/vhost.list

					
		LINE_NUM=`sed   -n   '1,'$FILE_LINE'p'   $RESULT_PATH/server.list  | grep   -nw  "location./"   |  awk  -F  ":"   '{print  $1}'`

		COUNT_3=`expr   $LINE_NUM  +  3`
				
		DOCUMENT=`sed  -n   ''$LINE_NUM','$COUNT_3'p'   $RESULT_PATH/server.list |  grep  -iw   "root"  |   awk   '{print  $2}' `

		if  [  -z  $DOCUMENT ]
		then
			DOCUMENT=`sed  -n  '1,'$LINE_NUM'p'  $RESULT_PATH/server.list  |  grep  -iw  "root"  |  awk  '{print  $2}'`
		fi
  
			echo   "DOCUMENT=$DOCUMENT"  >>  $RESULT_PATH/vhost.list		
			echo  "####"  >> $RESULT_PATH/vhost.list			
			DOCUMENT=unll		
			
	fi
done
		
			

#删除vhost.list文件中的；分号

sed   -i   's/;//g'     $RESULT_PATH/vhost.list

#删除vhost.list文件中的""双引号

sed  -i   's/"//g'     $RESULT_PATH/vhost.list


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

			echo  "DOCUMENT=$WORK_DIR/$NAME"  >>  $RESULT_PATH/Domain.list

		fi
	fi
done
	





cat  $RESULT_PATH/Domain.list   >> $RESULT_PATH/Summary.list 
