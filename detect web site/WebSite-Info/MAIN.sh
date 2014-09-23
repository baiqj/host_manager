#!/bin/bash

declare   -i   ZERO=0  ONE=1

RESULT_PATH=/root

#为COUNT_*变量附初始值

for  ((i=1;i<=20;i++))
do
	declare   -i   COUNT_$i=0
done


rm  -rf   $RESULT_PATH/*.list*


#根据不同的系统类型进入不动的脚本目录

SYSTEM_TYPE=`head  -n  1   /etc/issue  |  awk  '{print  $1}'`



case   $SYSTEM_TYPE   in

"CentOS" )
	cd  		./CentOS;;
"Debian" )
	cd   		./Ubuntu;;
"Ubuntu" )	
	cd		./Ubuntu;;
"RedHat" )
	cd		./CentOS;;
*)
	echo  'This  Script  Only  Support “RedHat”|“CentOS”|”Debian“|“Ubuntu” !!!'
esac


#判断网站程序是否安装并运行

COUNT_1=`ps   aux   |  grep -E  "httpd|apache|tomcat|nginx"  |  grep  -v  "grep"  |   wc  -l`


if  [  $COUNT_1  -eq   $ZERO ]
then
		echo  "##############"
		echo  "This  host  Not Running  on the web site program,or web site application Not Installed !!!" ;
		echo  "##############"
	 	exit  1;
fi



#判断网站程序的类型,当进程数大于1时，运行对应的网站程序

#第一、查看Nginx进程数量

N_PS=`ps  aux  |  grep   -i  "nginx"   |  grep  -v  "grep" |  wc  -l`


#"CentOS"系统中根据不同的安装方式执行不同的脚本

if   [  $N_PS  -ge   $ONE  ]   &&   [  $SYSTEM_TYPE  ==  "CentOS" ] 
then
	COUNT_1=`ps  aux |  grep  -i  "nginx"  |  grep  -v  "grep"  |  grep   -i  " -c " |  wc -l`
	if  [  $COUNT_1  -ge  $ONE ]
	then
		 ./Nginx/Nginx-1.sh; 
	else
		./Nginx/Nginx-2.sh;
		
	fi
fi


#"RedHat"系统中根据不同的安装方式执行不同的脚本

if   [  $N_PS  -ge   $ONE  ]   &&   [  $SYSTEM_TYPE  ==  "RedHat" ] 
then
	COUNT_1=`ps  aux |  grep  -i  "nginx"  |  grep  -v  "grep"  |  grep   -i  " -c " |  wc -l`
	if  [  $COUNT_1  -ge  $ONE ]
	then
		 ./Nginx/Nginx-1.sh; 
	else
		./Nginx/Nginx-2.sh;
		
	fi
fi

#"Ubuntu"系统中根据不同的安装方式执行不同的脚本

if   [  $N_PS  -ge   $ONE  ]   &&   [  $SYSTEM_TYPE  ==  "Ubuntu" ] 
then
	COUNT_1=`ps  aux |  grep  -i  "nginx"  |  grep  -v  "grep"  |  grep   -i  " master " |  grep  "/usr/sbin/nginx"  | wc -l`
	if  [  $COUNT_1  -ge  $ONE ]
	then
		 ./Nginx/Nginx-1.sh; 
	else
		./Nginx/Nginx-2.sh;
		
	fi
fi


#"Debian"系统中根据不同的安装方式执行不同的脚本

if   [  $N_PS  -ge   $ONE  ]   &&   [  $SYSTEM_TYPE  ==  "Debian" ] 
then
	COUNT_1=`ps  aux |  grep  -i  "nginx"  |  grep  -v  "grep"  |  grep   -i  " master " |  grep  "/usr/sbin/nginx"  | wc -l`
	if  [  $COUNT_1  -ge  $ONE ]
	then
		 ./Nginx/Nginx-1.sh; 
	else
		./Nginx/Nginx-2.sh;
		
	fi
fi

#第二、查看Apache的进程数量

A_PS=`ps   aux  | grep  -iE   'httpd|apache'  | grep  -v  "tomcat" |  grep  -v  "grep"  |  wc  -l `  


#"CentOS"系统中根据不同的安装方式执行不同的脚本

if   [  $A_PS  -ge   $ONE  ]   &&   [  $SYSTEM_TYPE  ==  "CentOS" ] 
then

COUNT_1=`ps  aux  |  grep  'httpd'   |  grep   -iw  "start"  |  grep  -v  "grep"  |  wc  -l`

	if   [  $COUNT_1  -eq  $ZERO  ]
	then
		 ./Apache/Apache-1.sh;
	else
		 ./Apache/Apache-2.sh;
	fi
fi


#"RedHat"系统中根据不同的安装方式执行不同的脚本

if   [  $A_PS  -ge   $ONE  ]   &&   [  $SYSTEM_TYPE  ==  "RedHat" ] 
then

COUNT_1=`ps  aux  |  grep  'httpd'   |  grep   -iw  "start"  |  grep  -v  "grep"  |  wc  -l`

	if   [  $COUNT_1  -eq  $ZERO  ]
	then
		 ./Apache/Apache-1.sh;
	else
		 ./Apache/Apache-2.sh;
	fi
fi
#"Ubuntu"系统中根据不同的安装方式执行不同的脚本

if   [  $A_PS  -ge   $ONE  ]   &&   [  $SYSTEM_TYPE  ==  "Ubuntu" ] 
then

COUNT_1=`ps  aux  |  grep  -i 'apache'   |  grep  -i  "/usr/sbin/apache"  |  grep  -v  "grep"  |  wc  -l`

	if   [  $COUNT_1  -ge   $ONE  ]
	then
		 ./Apache/Apache-1.sh;
	else
		 ./Apache/Apache-2.sh;
	fi
fi

#"Debian"系统中根据不同的安装方式执行不同的脚本

if   [  $A_PS  -ge   $ONE  ]   &&   [  $SYSTEM_TYPE  ==  "Ddbian" ] 
then

COUNT_1=`ps  aux  |  grep  -i 'apache'   |  grep  -i  "/usr/sbin/apache"  |  grep  -v  "grep"  |  wc  -l`

	if   [  $COUNT_1  -ge   $ONE  ]
	then
		 ./Apache/Apache-1.sh;
	else
		 ./Apache/Apache-2.sh;
	fi
fi



#查看Tomcat运行进程数量

T_PS=`ps  aux    |  grep -i "tomcat"  |  grep  -v  "grep"  |  wc -l`


#"CentOS"系统中根据不同的安装方式执行不同的脚本

if   [  $T_PS  -ge   $ONE  ]   &&   [  $SYSTEM_TYPE  ==  "CentOS" ] 
then

COUNT_1=` ps  aux  |  grep  "tomcat"  |   grep  -v "grep"  |  awk   -F  "-Dcatalina.base="    '{print  $2}'   |  awk   '{print  $1}'    |   grep  -i   "/usr/share/tomcat"  |  wc  -l`

	if   [  $COUNT_1  -ge   $ONE  ]
	then
		 ./Tomcat/Tomcat-1.sh;
	else
		 ./Tomcat/Tomcat-2.sh;
	fi
fi


#"RedHat"系统中根据不同的安装方式执行不同的脚本

if   [  $T_PS  -ge   $ONE  ]   &&   [  $SYSTEM_TYPE  ==  "RedHat" ] 
then

COUNT_1=` ps  aux  |  grep  "tomcat"  |   grep  -v "grep"  |  awk   -F  "-Dcatalina.base="    '{print  $2}'   |  awk   '{print  $1}'    |   grep  -i   "/usr/share/tomcat"  |  wc  -l`

	if   [  $COUNT_1  -ge   $ONE  ]
	then
		 ./Tomcat/Tomcat-1.sh;
	else
		 ./Tomcat/Tomcat-2.sh;
	fi
fi

#"Ubuntu"系统中根据不同的安装方式执行不同的脚本

if   [  $T_PS  -ge   $ONE  ]   &&   [  $SYSTEM_TYPE  ==  "Ubuntu" ] 
then

COUNT_1=` ps  aux  |  grep  "tomcat"  |   grep  -v "grep"  |  awk   -F  "-Dcatalina.base="    '{print  $2}'   |  awk   '{print  $1}'    |   grep  "/var/lib/tomcat"  |  wc  -l`


	if   [  $COUNT_1  -ge   $ONE  ]
	then
		./Tomcat/Tomcat-1.sh;
	else
		./Tomcat/Tomcat-2.sh;
	fi

fi


#"Debian"系统中根据不同的安装方式执行不同的脚本

if   [  $T_PS  -ge   $ONE  ]   &&   [  $SYSTEM_TYPE  ==  "Debian" ] 
then

COUNT_1=` ps  aux  |  grep  "tomcat"  |   grep  -v "grep"  |  awk   -F  "-Dcatalina.base="    '{print  $2}'   |  awk   '{print  $1}'    |   grep  "/var/lib/tomcat"  |  wc  -l`


	if   [  $COUNT_1  -ge   $ONE  ]
	then
		./Tomcat/Tomcat-1.sh;
	else
		./Tomcat/Tomcat-2.sh;
	fi

fi

