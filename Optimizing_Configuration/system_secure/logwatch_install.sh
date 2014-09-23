#!/bin/bash

[ -d  /usr/local/backup ] ||  mkdir  -p  /usr/local/backup
[ -d  /usr/local/resault ] ||  mkdir  -p  /usr/local/resault

#LogWatch Install 

EMAIL=`cat   /tmp/.mail.txt`

yum  clean  all
yum  repolist

yum  install  logwatch   -y

#Config the logwatch.conf

\cp  /usr/share/logwatch/default.conf/logwatch.conf   /etc/logwatch/conf/logwatch.conf

\cp  /etc/logwatch/conf/logwatch.conf 	 /usr/local/backup/logwatch.conf.old

grep  -v   "#"  /usr/local/backup/logwatch.conf.old     >   /etc/logwatch/conf/logwatch.conf

sed  -i  '/^ *$/d'   /etc/logwatch/conf/logwatch.conf

#set MailTo

sed -i  '/^MailTo =/d'   /etc/logwatch/conf/logwatch.conf

echo  "MailTo = $MAIL"  >>  /etc/logwatch/conf/logwatch.conf

#set Print

sed  -i  's/Print =/Print = no/g'   /etc/logwatch/conf/logwatch.conf

#set Detail

sed  -i  's/Detail = Low/Detail = 10/g'   /etc/logwatch/conf/logwatch.conf

cat  <<EOF>>   /etc/logwatch/conf/logwatch.conf
mailer = "sendmail -t"
Service = "-eximstats"
Service = "-zz-network"
Service = "-zz-sys"
EOF








