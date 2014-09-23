#!/bin/bash

##backup apache configuration file

#建议修改下查找httpd.conf的命令，优先从/etc/httpd和/usr/local下查找。
#找不到了在执行全盘查找。
#另外我们的目标不是备份httpd.conf这个文件，我们的目标是备份和用户网站域名配置有关的信息
#建议将整个httpd的配置文件的目录进行打包备份

CONF_PATH=`find / -name 'httpd.conf'  -a  -type f`

[ -d  /usr/local/backup ] ||  mkdir  -p  /usr/local/backup
[ -d  /usr/local/resault ] ||  mkdir  -p  /usr/local/resault

[ -f /usr/local/backup/httpd.conf.old ] || \cp  $CONF_PATH  /usr/local/backup/httpd.conf.old 


grep   -v  "^#"   /usr/local/backup/httpd.conf.old  >  $CONF_PATH 

sed  -i  '/^ *$/d'    $CONF_PATH

find  /  -name  "vhost.list"  -a  -type  f  -exec  \cp  {}  /usr/local/resault  \;

if [ -f  /usr/local/resault/vhost.list ]
then
        if [ -s /usr/local/resault/vhost.list ]
        then
                grep   "^DOCUMENT="  /usr/local/resault/vhost.list |  awk -F "="  '{print  $2}' >  /usr/local/resault/web_document.txt

else
                echo 'this host have not website!!!'
                exit 1
        fi
                
else
                echo 'plsase check website-info!!!'
                exit 1
fi

##edit the configuration file


if [ -f  /usr/local/backup/httpd.conf.old ]

then
	echo  "####################"   >>   $CONF_PATH
	for  i  in  $(cat /usr/local/resault/web_document.txt)
	do
		{  cat  <<EOF>>  $CONF_PATH
<Directory "$i">
    Options FollowSymLinks
    AllowOverride None
    Order allow,deny
    Allow from all
</Directory>
EOF
		}
	done
else 
        echo '###please run backup.sh first!!###'
fi


