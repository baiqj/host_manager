#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 验证当前的用户是否为root账号，不是的话退出当前脚本
[ `id  -u`  == 0 ]  ||  echo "Error: You must be root to run this script, please use root to install lnmp"  ||  exit  1

ping  -c1  www.baidu.com  ||  exit  1 


cur_dir=$(pwd)

tar  -zcvf  /etc/yum.repos.d/repo.tar.gz   /etc/yum.repos.d/*
rm  -rf   /etc/yum.repos.d/CentOS-*

cat   <<EOF>>  /etc/yum.repos.d/lnmp.repo
[lnmp_base]
name=lnmp_base
baseurl=http://mirrors.163.com/centos/6.5/os/x86_64/
gpgcheck=0
enabled=1

[lnmp_txtras]
name=lnmp_extras
baseurl=http://mirrors.163.com/centos/6.5/extras/x86_64/
gpgcheck=0
enabled=1

[lnmp_updates]
name=lnmp_updates
baseurl=http://mirrors.163.com/centos/6.5/updates/x86_64/
gpgcheck=0
enabled=1
EOF


#安装REDHAT附加软件包EPEL
rpm -ivh http://mirrors.sohu.com/fedora-epel/6/x86_64/epel-release-6-8.noarch.rpm


type -p screen >/dev/null || yum -y install screen

###################
#Set TimeZone
###################

mv /etc/localtime /etc/localtime.bak
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

yum install -y ntp
ntpdate -u pool.ntp.org

#yum -y remove httpd*
#yum -y remove php*
#yum -y remove mysql-server mysql
#yum -y remove php-mysql

yum -y install yum-fastestmirror




#Disable SeLinux
if [ -s /etc/selinux/config ]; then
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
fi

cp /etc/yum.conf /etc/yum.conf.lnmp
sed -i 's:exclude=.*:exclude=:g' /etc/yum.conf


for packages in patch wget make mlocate cmake gcc gcc-c++ gcc-g77 flex bison file libtool libtool-libs  kernel-devel libjpeg libjpeg-devel libpng libpng-devel libpng10 libpng10-devel gd gd-devel freetype freetype-devel libxml2  autoconf libxml2-devel zlib zlib-devel glib2 glib2-devel bzip2 bzip2-devel libevent libevent-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel vim-minimal nano fonts-chinese gettext gettext-devel ncurses-devel gmp-devel pspell-devel unzip libcap pcre-devel openssl-devel libxml2-devel  mysql-devel bzip2-devel libmcrypt-devel libpng-devel libjpeg-turbo-devel  net-snmp-devel openldap-devel libcurl-devel libc-client-devel libtidy-devel;
do yum  install $packages  -y ; done



updatedb

mv -f /etc/yum.conf.lnmp /etc/yum.conf


############################
#Install Depend Package
#############################





echo "=========================install depend package end===================="


