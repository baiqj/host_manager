#!/bin/bash

#Disable the risk function

CONF_PATH=`find  /  -name  "php.ini"`

##edit the configuration file

if [ -f  /usr/local/backup/php.ini.old ]

then

sed  -i  '/^disable_functions =/d'        $CONF_PATH
echo    'disable_functions = phpinfo,com,shell,exec,system,passthru,error_log,stream_socket_server,putenv,ini_alter,ini_restore,ini_set,dl,openlog,syslog,readlink,symlink,link,leak,fsockopen,pfsockopen,proc_open,popepassthru,escapeshellcmd,escapeshellarg,chroot,scandir,chgrp,chown,shell_exec,proc_get_status,popen,shmop_close,shmop_delete,shmop_open,shmop_read,shmop_size,shmop_write,touch'     >>      $CONF_PATH

else 
        echo '###please run backup.sh first!!!###'
fi
