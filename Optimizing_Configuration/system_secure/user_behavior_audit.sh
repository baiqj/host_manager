#!/bin/bash

[ -d  /usr/local/backup ] ||  mkdir  -p  /usr/local/backup
[ -d  /usr/local/resault ] ||  mkdir  -p  /usr/local/resault

#User Behavior Audit

touch   /var/log/Command_history.log

chmod   002   /var/log/Command_history.log

chown nobody.nobody /var/log/Command_history.log

chattr +a /var/log/Command_history.log


cat   `find  /  -name  "audit.txt"`  >>   /etc/profile

source   /etc/profile
