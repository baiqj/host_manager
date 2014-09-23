#!/bin/bash
#对未分区的磁盘进行自动化分区，并将分区挂载在/data目录下
#使用fdisk进行分区，对于分区超过1TB的暂时不支持
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 验证当前的用户是否为root账号，不是的话退出当前脚本
[ `id  -u`  == 0 ]  ||  echo "Error: You must be root to run this script, please use root to install lnmp"  ||  exit  1

#列出当前系统中的已有磁盘
fdisk  -l  |  grep -iw "^Disk"  |  grep  "/dev/"  |  grep  -vi  "\/mapper\/"  |  awk  -F  ":"   '{print  $1}'  |   awk   '{print  $2}'  |  sort   >   /tmp/.disk.list

#统计当前系统中已有磁盘的个数
NUM=`wc  -l    /tmp/.disk.list  |  awk   '{print  $1}'`

for  ((i=1;i<=NUM;i++))
do
DISK_NAME=`sed  -n  ''$i',1p'  /tmp/.disk.list`
#统计磁盘的分区数量
COUNT=`fdisk  -l  |   grep  "$DISK_NAME"  |  grep  "^/dev/"  |  wc  -l`
#如果该磁盘没有进行分区
if  [  $COUNT ==  0  ]
then
fdisk $DISK_NAME  << EOF
n
p
1


wq
EOF

#当找到第一块未分区的磁盘并进行分区后，退出当前for循环，即：只对第一个找到的新磁盘进行分区
break;

else

continue;

fi
done

#判断是否存在/date目录，没有的话则创建

[ -e /data ]  ||  mkdir  -p  /data  


#验证是否有新磁盘被分区，如果已经被挂载了则表示没有新的磁盘

mount  -l  |  grep  $DISK_NAME\1   

#格式化新的磁盘分区，当有新磁盘并分区的话生成/tmp/.moult.list文件保存挂载点。否则不生成该文件

[ `echo  $?`  == 0 ]  || mkfs.ext4   $DISK_NAME\1  || echo  $DISK_NAME\1               /data                   ext4          defaults        1 2  >> /etc/fstab || mount -a || echo   "/data"   >    /tmp/.mount.list

