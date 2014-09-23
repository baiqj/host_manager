#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

################################################
#用于安装rkhunter安全工具
################################################

# 验证当前的用户是否为root账号，不是的话退出当前脚本
[ `id  -u`  == 0 ]  ||  echo "Error: You must be root to run this script, please use root to install rkhunter"  ||  exit  1

#检测系统是不是CentOS，如果不是，提醒用户暂时不支持

cat  /etc/issue  |  grep  -iw  "CENTOS"

[ `echo  $?` != 0 ]  &&  exit  1

#安装了locate工具
yum  install  -y  mlocate 

yum  install  wget   -y   

#wget下载rkhunter安装包,文件统一下载到data/packages目录下

wget  -O  rkhunter-1.4.2.tar.gz  http://bcs.duapp.com/linux2host2manager/%2Fpackages2%2Frkhunter-1.4.2.tar.gz?sign=MBO:E64167e555322cbfb5997582b43a551b:kd5c38%2FY2abjSwaWiXKiQVpfvFw%3D

updatedb

#安装
tar  -zxvf  `locate  rkhunter-1.4.2.tar.gz`
cd  ./rkhunter-1.4.2
./installer.sh  --layout  default  --install

#判断是否安装成功,不成功的话退出脚本  安装成功的话执行下面的操作
[ `echo  $?` != 0 ]  &&  exit 1 

#更新
/usr/local/bin/rkhunter   --update
#创建基准
/usr/local/bin/rkhunter   --propupd

# 设置计划任务和邮件发送。此部分功能不开发
#注意：需要获取用户的邮箱地址
#cat > /etc/cron.daily/rkhunter.sh <<EOF
#!/bin/sh
#(
#/usr/local/bin/rkhunter --versioncheck
#/usr/local/bin/rkhunter --update
#/usr/local/bin/rkhunter --cronjob --report-warnings-only
#) | /bin/mail -s 'rkhunter Daily Run  $(hostname --fqdn)'   wanghaicheng2004@126.com
#EOF

#设置脚本可执行
chmod 700 /etc/cron.daily/rkhunter.sh

#启动crond服务
chkconfig  crond  on
service  crond   restart
