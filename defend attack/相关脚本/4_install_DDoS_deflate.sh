#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
###############################################################
#用于防范DDoS攻击
#卸载方法
#1
#wget http://www.inetbase.com/scripts/ddos/uninstall.ddos
#2
#chmod +x uninstall.ddos
#3
#./uninstall.ddos
#
###############################################################

# 验证当前的用户是否为root账号，不是的话退出当前脚本
[ `id  -u`  == 0 ]  ||  echo "Error: You must be root to run this script, please use root to install DDoS deflate"  ||  exit  1

#检测系统是不是CentOS，如果不是，提醒用户暂时不支持

cat  /etc/issue  |  grep  -iw  "CENTOS"

[ `echo  $?` != 0 ]  &&  exit  1

#安装wget
yum  install  -y   wget

#安装了locate
yum  install  -y  mlocate 

#下载安装脚本
#wget http://www.inetbase.com/scripts/ddos/install.sh
#压缩包统一下载到data/packages目录下面
wget  -O  DDoS.tar.gz        http://bcs.duapp.com/linux2host2manager/%2Fpackages2%2FDDoS.tar.gz?sign=MBO:E64167e555322cbfb5997582b43a551b:oNnBTPxuCz0BvPG8o7LnwNfyEL4%3D

updatedb

#安装
tar   -zxvf    `locate DDoS.tar.gz`
chmod +x ./install.sh
chmod +x ./uninstall.ddos

#注释掉版权协议内容的显示"cat /usr/local/ddos/LICENSE | less"
sed  -i  '/\/cat\ \/usr\/local\/ddos\/LICENSE \| less/d'   ./install.sh 

./install.sh  

#卸载方法： 执行./uninstall.ddos脚本
 

#主要功能与配置
#1、可以设置IP白名单，在 /usr/local/ddos/ignore.ip.list 中设置即可；
#2、主要配置文件位于 /usr/local/ddos/ddos.conf ，打开此文件，根据提示进行简单的编辑即可；
#3、DDoS deflate可以在阻止某一IP后，隔一段预置的时候自动对其解封；
#4、可以在配置文件中设置多长时间检查一次网络连接情况；
#5、当阻止IP后，可以设置Email提醒
#默认配置示例
#DDoS deflate的配置非常简单：
#01
#FREQ=1 #检测的频率为1分钟
#02
# 
#03
#NO_OF_CONNECTIONS=100 #当单个IP超过100个连接请求时判定为DDOS
#04
#
#05
#APF_BAN=0
#06
#如果打算使用APF阻止IP，则设置为1（需要预先安装APF）；如果使用iptables，则设置为0；
#07
#
#08
#KILL=1 #是否阻止
#09
#
#10
#EMAIL_TO="webmaster@bootf.com" #接收邮件
#11
#
#12
#BAN_PERIOD=600 #阻止时长，10分钟
#相关参考

#设置完成后重启crond服务

service  crond  restart
chkconfig  crond  on
