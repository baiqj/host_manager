#!/bin/bash

##############################
#检测Rpm安装方式Apache主配置文件的路径
##############################
updatedb

ENV_PATH=../env_config

LINE_NUM=`grep  -n  "Apache_Rpm_Conf_Path"   $ENV_PATH  |  awk -F:  '{print $1}'`

#在"Apache_Rpm_Conf_Path"行之后添加一行

sed  -ie  "/Apache_Rpm_Conf_Path/a \'Apache_Rpm_Conf_Path\':\'"/etc/httpd/conf/httpd.conf"\'"   $ENV_PATH

#删除原来的"Apache_Rpm_Conf_Path"行

sed -i  ''$LINE_NUM'd'   $ENV_PATH



