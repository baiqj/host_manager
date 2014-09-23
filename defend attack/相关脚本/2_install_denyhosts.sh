#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

##########################
#用于安装DenyHosts脚本
#备注：Denyhosts是一个Linux系统下阻止暴力破解SSH密码的软件，需要设置不能或只能SSH登录的IP。这个是需要从用户处获取的
#/etc/目录中存在hosts.allow和hosts.deny文件，两个文件是控制远程访问设置的，通过他可以允许或者拒绝某个ip或者ip段的客户访问linux的某项服务
#/etc/hosts.allow控制可以访问本机的IP地址，
#/etc/hosts.deny控制禁止访问本机的IP。如果两个文件的配置有冲突，以/etc/hosts.deny为准。
#比如SSH服务，我们通常只对管理员开放，那我们就可以禁用不必要的IP，而只开放管理员可能使用到的IP段。
#文件配置格式：
#sshd:210.13.218.*    
#ALL:218.24.129.110 
#httpd:ALL
#
#优先级为先检查hosts.deny，再检查hosts.allow，
#后者设定可越过前者限制
##########################



# 验证当前的用户是否为root账号，不是的话退出当前脚本
[ `id  -u`  == 0 ]  ||  echo "Error: You must be root to run this script, please use root to install lnmp"  ||  exit  1

#检测系统是不是CentOS，如果不是，提醒用户暂时不支持

cat  /etc/issue  |  grep  -iw  "CENTOS"

[ `echo  $?` != 0 ]  &&  exit  1

#安装wget
yum  install  -y   wget

#安装了locate
yum  install  -y  mlocate 

#下载DenyHosts脚本
#是否需要将脚本下载到指定位置data/packages
#wget  http://ncu.dl.sourceforge.net/sourceforge/denyhosts/DenyHosts-2.6.tar.gz
wget   -O   DenyHosts-2.6.tar.gz   http://bcs.duapp.com/linux2host2manager/%2Fpackages2%2FDenyHosts-2.6.tar.gz?sign=MBO:E64167e555322cbfb5997582b43a551b:czvbovEwQ0lbNXze3%2FkzMmX%2BzWY%3D

#判断是否安装了xinetd服务
rpm  -q  xinetd

[ `echo  $?` != 0 ] &&   yum  install  xinetd  -y

 service  xinetd  start
 chkconfig  xinetd  on

#判断是否安装了python，默认CentOS 6.3系统已经安装了2.6.6版本
python  -V

if  [  `echo  $?`  != 0 ]
then
#如果系统没有python,则yum安装pathon
	yum  install   -y  python
#编译安装DenyHosts工具
else
	updatedb
	PACKAGE_PATH=`locate  DenyHosts-2.6.tar.gz`
	tar  -zxvf   $PACKAGE_PATH
	cd   ./DenyHosts-2.6
	python   ./setup.py    install
fi
#程序默认的安装目录" /usr/share/denyhosts/"
#创建服务启动脚本文件
	 \cp  /usr/share/denyhosts/daemon-control-dist   /etc/rc.d/init.d/denyhostsd
#赋予脚本可执行权限
	chown root /etc/rc.d/init.d/denyhostsd
	chmod 700 /etc/rc.d/init.d/denyhostsd
#设置开机自动执行	
	chkconfig --add denyhostsd
	chkconfig --level 345 denyhostsd on
#设置配置文件,使用了默认的选项。
	cd    /usr/share/denyhosts/
	grep -v "^#" denyhosts.cfg-dist > denyhosts.cfg
	
#设置SSH访问本机的规则,此处只是示例  需要客户提供ip地址
#设置只允许IP 192.168.3.207 SSH访问本机，其它IP均不允许SSH访问本机
#echo  "sshd:ALL"     >>  /etc/hosts.deny
#echo  "sshd:192.168.3.207"  >>   /etc/hosts.allow

service   xinetd  restart

#启动服务
service denyhostsd start

	