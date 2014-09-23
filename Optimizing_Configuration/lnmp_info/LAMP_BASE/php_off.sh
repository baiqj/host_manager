#!/bin/bash
#############################
#将原有的php-fpm服务设置开机不启动
#############################

updatedb
ENV_PATH=../../env_config

#查看php的启动脚本

locate  php-fpm  |  grep  "\/etc\/rc.d\/init\.d\/php-fpm$"
[ `echo  $?`  == 0 ]  &&  chkconfig  php-fpm  off  &&  service  php-fpm  stop

#删除rc.local中的php-fpm启动项

sed   -i   '/php-fpm/d'   /etc/rc.d/rc.local

CMD=`locate  php-fpm  |  grep  "\/php\/sbin\/php-fpm$"`
[  `echo  $?` == 0  ]  &&   $CMD   stop


 

