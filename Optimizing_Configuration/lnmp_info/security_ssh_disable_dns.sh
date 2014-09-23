#!/bin/bash

##############################
#检测SSH是否启用了"禁用dns解析"功能
##############################

updatedb

ENV_PATH=../env_config

grep -i  "UseDNS no"  /etc/ssh/sshd_config |  grep -v  "^#"

#On表示启用了"禁用dns解析"功能
if [ `echo  $?` ]  
then 
	VALUE="On"
else
	VALUE="Off"
fi

#查看"Ssh_Disable_Dns"所在的行号

LINE_NUM=`grep  -n  "Ssh_Disable_Dns"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Ssh_Disable_Dns"行之后添加一行

sed  -ie  "/Ssh_Disable_Dns/a \'Ssh_Disable_Dns\':\'$VALUE\'" $ENV_PATH

#删除原来的"Ssh_Disable_Dns"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH