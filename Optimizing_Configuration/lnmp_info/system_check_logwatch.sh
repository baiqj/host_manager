#!/bin/bash

##############################
#检测Logwatch是否安装
##############################

updatedb

ENV_PATH=../env_config

#查看是否存在logwatch的可执行文件
locate  logwatch  |  grep  "\/logwatch$"  |  grep  "bin/"


#查看"Check_LogWatch"所在的行号

LINE_NUM=`grep  -n  "Check_LogWatch"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Check_LogWatch"行之后添加一行

if  [  `echo  $?` == 0 ]
then
	sed  -ie  "/Check_LogWatch/a \'Check_LogWatch\':\'YES\'" $ENV_PATH
else
	sed  -ie  "/Check_LogWatch/a \'Check_LogWatch\':\'NO\'" $ENV_PATH

#删除原来的"Check_LogWatch"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH