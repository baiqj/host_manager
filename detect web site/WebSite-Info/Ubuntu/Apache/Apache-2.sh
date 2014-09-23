#!/bin/bash


declare  -i    CONF_LINE   FILE_LINE  VHOST_NUM=0    ZERO=0  ONE=1 

#为COUNT_*变量附初始值

for  ((i=1;i<=20;i++))
do
	declare   -i   COUNT_$i=0
done

RESULT_PATH=/root

rm  -rf   $RESULT_PATH/*.list*


#定位Apache的安装目录

NICE_PATH=`find  /   -name  "config.nice"   |  grep  "/build" `

FILE_LINE=`grep   "prefix="   $NICE_PATH   |  wc  -l  |  awk  '{print  $1}'`

if  [ $FILE_LINE  -eq  $ONE  ]
then
	WORK_DIR=`grep  "prefix="  $NICE_PATH |   awk  -F "="   '{print  $2}' | awk  -F'"'  '{print  $1}'`
else
	WORK_DIR="/usr/local/apache2"
fi

#手动创建结果文件

echo   "***********"    >>   $RESULT_PATH/Domain.list
echo   "WORK_DIR=$WORK_DIR"     >>   $RESULT_PATH/Domain.list
echo   "***********"    >>   $RESULT_PATH/Domain.list
touch   $RESULT_PATH/vhost.list
touch   $RESULT_PATH/absolute.list
touch   $RESULT_PATH/Include.list
touch   $RESULT_PATH/Include_file.list
touch   $RESULT_PATH/vhost_num.list


#定位Apache的主配置文件httpd.conf

/usr/bin/updatedb
CONF_PATH=`/usr/bin/locate  $WORK_DIR/conf/httpd.conf`

#将主配置文件httpd.conf中的有效配置导出到conf.list

grep  -Ev  "#|^$"   $CONF_PATH  >>  $RESULT_PATH/conf.list

#删除行首的空格

sed   -i  's/^[[:space:]]*//g'   $RESULT_PATH/conf.list

#删除conf.list文件中的""双引号

sed  -i   's/"//g'     $RESULT_PATH/conf.list

#之后用到的‘CONF_PATH’都是指conf.list文件，即有效的配置内容

updatedb
CONF_PATH=`locate   $RESULT_PATH/conf.list`

#统计配置文件有效内容的行数

CONF_LINE=`wc  -l   $CONF_PATH |  awk   '{print  $1}'`



#统计有效的主配置文件（conf.list）中是否启用了"NameVirtualHost"

COUNT_1=`awk  '{print  $1}'  $CONF_PATH |  grep  "NameVirtualHost" |  wc  -l  |  awk  '{print  $1}'`


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
		echo   "$WORK_DIR/$NAME"   >>    $RESULT_PATH/absolute.list  
		
	fi
done

#将absolute.list文件中的路径（目录或文件）包含的所有的文件到存放到Include_file.list文件中

FILE_LINE=`wc  -l  $RESULT_PATH/absolute.list  |  awk   '{print  $1}'`

for   ((i=1;i<=FILE_LINE;i++))
do
	NAME=`sed  -n   ''$i',1p'   $RESULT_PATH/absolute.list `
	updatedb
	locate  $NAME   >>   $RESULT_PATH/Include_file.list
done


#统计有效的主配置文件conf.list文件中是否有“NameVirtualHost”

COUNT_4=`awk   '{print  $1}'    $RESULT_PATH/conf.list |grep   "NameVirtualHost" | wc  -l  |   awk   '{print  $1}' `


#统计Include包含的所有文件中是否启用了“NameVirtualHost”

FILE_LINE=`wc  -l   $RESULT_PATH/Include_file.list  |  awk   '{print  $1}'`

for  ((i=1;i<=FILE_LINE;i++))
do
	NAME=`sed   -n  ''$i',1p'   $RESULT_PATH/Include_file.list ` 
        COUNT_5=`grep   -Ev  "#|^$"  $NAME |   awk  '{print  $1}'  |   grep  -w   "NameVirtualHost" |  wc   -l  |   awk  '{print  $1}'`
	if   [  $COUNT_5  -eq  $ONE ]
	then
		break;
	fi
done
 

#如果有效的主配置文件conf.list或Include包含的文件中用“NameVirtualHost”，即启用了虚拟主机功能

if   [  $COUNT_4  -eq  $ONE ] ||  [  $COUNT_5  -eq   $ONE  ]
then

#统计在有效的主配置文件conf.list中的vhost的域名和网页目录

	for  ((i=1;i<=CONF_LINE;i++))
	do
		COUNT_6=`sed  -n   ''$i',1p'    $CONF_PATH  | awk    '{print  $1}'  |  grep  "<VirtualHost" |  wc  -l   |  awk   '{print  $1}'`
		if  [ $COUNT_6 -eq  $ONE ]
		then 
			for  ((j=i;j<=CONF_LINE;j++))
			do
				COUNT_7=`sed  -n   ''$j',1p'   $CONF_PATH  | awk  '{print  $1}'   |   grep  "</VirtualHost>" | wc  -l  |  awk  '{print  $1}'`				
				if  [  $COUNT_7 -eq  $ONE  ]
				then

					DOMAIN_NAME=`sed  -n   ''$i','$j'p'   $CONF_PATH  |  grep   "ServerName "  |  awk   '{print  $2}' `

					echo "DOMAIN_NAME=$DOMAIN_NAME" >>  $RESULT_PATH/vhost.list
					
					
					
					DOCUMENT=`sed  -n   ''$i','$j'p'   $CONF_PATH  |  grep   "DocumentRoot "  |  awk   '{print  $2}' `

					echo "DOCUMENT=$DOCUMENT"  >>  $RESULT_PATH/vhost.list
					echo   "####"	>>  $RESULT_PATH/vhost.list
				
				i=$j
				break;
				fi
			
			done

		fi
	done
fi

#如果有效的主配置文件conf.list或Include包含的文件中启用“NameVirtualHost”，即启用了虚拟主机功能

if   [ $COUNT_4  -eq  $ONE ]  ||   [ $COUNT_5  -eq   $ONE  ]
then

#统计Include包含的文件中的vhost的域名和网页目录

	COUNT_6=`wc  -l   $RESULT_PATH/Include_file.list  |  awk   '{print  $1}'`
	for  ((i=1;i<=COUNT_6;i++))
	do
		NAME=`sed   -n   ''$i',1p'   $RESULT_PATH/Include_file.list`
		COUNT_7=`wc  -l  $NAME  |  awk   '{print  $1}'`
		
		for   ((j=1;j<=COUNT_7;j++))
		do
			COUNT_8=`sed   -n   ''$j',1p'   $NAME  |   awk   '{print  $1}'|  grep   "<VirtualHost"  |  wc  -l  |   awk   '{print   $1}'`
			if  [  $COUNT_8  -eq  $ONE  ]
			then
				for   ((k=j;k<=COUNT_7;k++))
				do
					COUNT_9=`sed   -n   ''$k',1p'  $NAME |  awk  '{print  $1}'  |  grep   "</VirtualHost>"|  wc  -l   |  awk '{print  $1}'`
					if  [  $COUNT_9  -eq  $ONE ]
					then
						DOMAIN_NAME=`sed  -n   ''$j','$k'p'   $NAME   |   grep   "ServerName " |  awk   '{print  $2}' `

						echo  "DOMAIN_NAME=$DOMAIN_NAME" >>   $RESULT_PATH/vhost.list
			
						DOCUMENT=`sed  -n   ''$j','$k'p'   $NAME  |  grep   "DocumentRoot "  |  awk   '{print  $2}'`

						echo  "DOCUMENT=$DOCUMENT"   >>  $RESULT_PATH/vhost.list
						echo   "####"	>>  $RESULT_PATH/vhost.list
						
					j=$k
					break;
					fi

				done
			fi
		done
	done
fi



#有效的主配置文件conf.list和Include包含的文件中都没有启用 “NameVirtualHost”，即没有启用vhost功能


if   [ $COUNT_4  -eq  $ZERO ]  &&   [ $COUNT_5  -eq   $ZERO  ]
then
	
	sed  -i  '1,$d'     $RESULT_PATH/Include.list
	sed  -i  '1,$d'     $RESULT_PATH/Include_file.list
	sed  -i  '1,$d'     $RESULT_PATH/absolute.list	

#统计有效的主配置文件conf.list中出现“<VirtualHost”的行号，如果主配置文件中没有“<VirtualHost”的话，“LINE_NUM”的值就是conf.list文件的行数

	LINE_NUM=0

	for  ((i=1;i<=CONF_LINE;i++))
	do
		{		
		COUNT_6=`sed  -n   ''$i',1p'   $CONF_PATH   | grep   "<VirtualHost"   |   wc   -l  |    awk  '{print   $1}'`
		
		if   [  $COUNT_6  -eq  $ONE ]
		then
			LINE_NUM=$i
			break
		else
			LINE_NUM=$CONF_LINE
		fi
		}
	done

#统计有效的主配置文件conf.list出现“<VirtualHost”之前的Include包含的路径	

	for   ((i=1;i<=LINE_NUM;i++))
	do
		{
		sed  -n  ''$i',1p'   $CONF_PATH  |  grep  -i  "^Include"  |  awk   '{print  $2}'   >>    $RESULT_PATH/Include.list
		}
	done

#将Include.list文件中的路径（相对、绝对）都补全成绝对路径，保存到absolute.list文件

	FILE_LINE=`wc  -l   $RESULT_PATH/Include.list  |  awk   '{print  $1}'`

	for   ((i=1;i<=FILE_LINE;i++))
	do
		{
		COUNT_8=`sed  -n ''$i',1p'   $RESULT_PATH/Include.list   |  grep  "^/"   |   wc  -l   |  awk    '{print  $1}'`
			
		if   [  $COUNT_8  -eq  $ONE ]
		then
				
			sed  -n  ''$i',1p'   $RESULT_PATH/Include.list  >>    $RESULT_PATH/absolute.list
		elif [ $COUNT_8  -eq   $ZERO ]	
		then
			NAME=`sed  -n ''$i',1p'   $RESULT_PATH/Include.list`
			echo   "$WORK_DIR/$NAME"   >>   $RESULT_PATH/absolute.list

		fi
		}
	done
	
#统计Include所有包含的的文件	

	FILE_LINE=`wc  -l   $RESULT_PATH/absolute.list|  awk   '{print  $1}'`
		
	for  ((i=1;i<=FILE_LINE;i++))
	do
		{		
 		NAME=`sed  -n  ''$i',1p'  $RESULT_PATH/absolute.list`
		updatedb
		locate   $NAME  >>   $RESULT_PATH/Include_file.list
		}
	done

#查看Include包含的文件中第一个出现的vhost，如果有的话输出域名和网页目录并退出程序

	FILE_LINE=`wc  -l   $RESULT_PATH/Include_file.list  |  awk '{print  $1}'`

	for   ((i=1;i<=FILE_LINE;i++))
	do
		NAME=`sed   -n  ''$i',1p'  $RESULT_PATH/Include_file.list`
		COUNT_9=`grep   -v  "#"  $NAME  | grep     "<VirtualHost "     | wc  -l  |  awk   '{print  $1}' `  
				
		if  [ $COUNT_9 -gt  $ZERO ]
		then
			COUNT_10=`wc  -l  $NAME  |  awk   '{print  $1}'`
			for  ((j=1;i<=COUNT_10;j++))
			do
				COUNT_11=`sed   -n   ''$j',1p'   $NAME  |  grep  -v   "#"   |   grep   "<VirtualHost"  |  wc  -l   |  awk   '{print  $1}'`
				if  [  $COUNT_11  -eq   $ONE ]
				then
					for   ((k=j;k<=COUNT_10;k++))
					do
						COUNT_12=`sed   -n   ''$k',1p'   $NAME  |   grep   -v  "#"  |  grep   "</VirtualHost>"  |  wc  -l  |  awk   '{print  $1}'`
						if  [  $COUNT_12 -eq  $ONE ]	
						then
							DOMAIN_NAME=`sed  -n   ''$j','$k'p'   $NAME   |   grep   "ServerName " |  awk   '{print  $2}'`

							echo  "DOMAIN_NAME=$DOMAIN_NAME"  >>   $RESULT_PATH/vhost.list
							DOCUMENT=`sed  -n   ''$j','$k'p'   $NAME  |  grep   "DocumentRoot "  |  awk   '{print  $2}' `

							echo  "DOCUMENT=$DOCUMENT"  >>  $RESULT_PATH/vhost.list
							echo   "####"	>>  $RESULT_PATH/vhost.list
								
							
						exit  0;

						fi

					done
				fi
			done
		fi
	done

#以下内容执行的前提是，在Include包含的所有文件中都没有vhost配置
#在有效的主配置文件conf.list查看第一个出现的vhost

	for    ((i=1;i<=CONF_LINE;i++))
	do
		COUNT_6=`sed  -n   ''$i',1p'   $CONF_PATH   |   awk  '{print   $1}'  | grep   "<VirtualHost"   |   wc   -l  |   awk    '{print   $1}'`
		
		if  [ $COUNT_6  -eq  $ONE ]
		then
			for  ((j=i;j<=CONF_LINE;j++))
			do
				COUNT_7=`sed  -n   ''$j',1p'   $CONF_PATH   |   awk  '{print   $1}'  | grep   "</VirtualHost>"   |   wc   -l  |   awk    '{print   $1}'`
				if  [  $COUNT_7  -eq  $ONE ]
				then
					DOMAIN_NAME=`sed  -n   ''$i','$j'p'   $CONF_PATH   |   grep   "ServerName " |  awk   '{print  $2}' `

					echo  "DOMAIN_NAME=$DOMAIN_NAME" >>   $RESULT_PATH/vhost.list
					
					DOCUMENT=`sed  -n   ''$i','$j'p'   $CONF_PATH  |  grep   "DocumentRoot "  |  awk   '{print  $2}'`

					echo  "DOCUMENT=$DOCUMENT"   >>  $RESULT_PATH/vhost.list
					echo   "####"	>>  $RESULT_PATH/vhost.list
								
					
				exit  0;

				fi

			done
		fi
	done  

fi

#将vhost.list中的“”双引号去除

sed  -i  's/"//g'     $RESULT_PATH/vhost.list  

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
