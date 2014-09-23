#!/bin/bash

#判断系统的类型

SYSTEM_TYPE=`head  -n  1   /etc/issue  |  awk  '{print  $1}'`

#切换当前用户为root账号，不确定当root没有密码时能否切换？？？

case   $SYSTEM_TYPE   in

"CentOS")
	su    	root  -c  "./MAIN.sh" ;;
"Debian")
	sudo  su    root  -c  "./MAIN.sh";;
"Ubuntu")	
	sudo  su    root -c  "./MAIN.sh";;
"RedHat")
	su	root   -c  "./MAIN.sh";;
* 	)
	echo  'This  Script  Only  Support “RedHat”|“CentOS”|”Debian“|“Ubuntu” !!!'
esac

