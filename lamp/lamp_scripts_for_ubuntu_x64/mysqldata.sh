#!/bin/bash

#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi

DATA_DISK=`cat   /tmp/.mount.list`

##############################
#MySql  Is Stopping.....
##############################
/etc/init.d/mysqld    stop

#############################
#Create MySql Data DIR
############################

mkdir   -p   $DATA_DISK/mysqldata
cp  -rp   /usr/local/mysql/var/*   $DATA_DISK/mysqldata

mv   /usr/local/mysql/var /usr/local/mysql/var-bak

############################
#Change The /etc/my.cnf
############################     

ln  -s   $DATA_DISK/mysqldata     /usr/local/mysql/data

chown   mysql:mysql     $DATA_DISK/mysqldata
#############################
#Mysql  Is  Starting..........
#############################
/etc/init.d/mysqld   start

