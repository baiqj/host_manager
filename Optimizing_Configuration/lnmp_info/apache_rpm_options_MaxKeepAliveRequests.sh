#!/bin/bash

##############################
#检测RPM安装方式的Apache主配置文件中的MaxKeepAliveRequests配置项信息
##############################

[ `rpm -qa | grep  httpd` ] || exit 1

updatedb

ENV_PATH=../env_config

CONF='/etc/httpd/conf/httpd.conf'

VALUE=`grep  -v  "^#"  $CONF |  grep  -i "MaxKeepAliveRequests " |  awk  '{print  $2}'`

#查看"Apache_Rpm_MaxKeepAliveRequests"所在的行号

LINE_NUM=`grep  -n  "Apache_Rpm_MaxKeepAliveRequests"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Apache_Rpm_MaxKeepAliveRequests"行之后添加一行

sed  -ie  "/Apache_Rpm_MaxKeepAliveRequests/a \'Apache_Rpm_MaxKeepAliveRequests\':\'$VALUE\'" $ENV_PATH

#删除原来的"Apache_Rpm_MaxKeepAliveRequests"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH



