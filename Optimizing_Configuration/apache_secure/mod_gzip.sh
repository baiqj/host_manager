#!/bin/bash

#Open the gzip compression

CONF_PATH=`find / -name 'httpd.conf'  -a  -type f`

[ -d  /usr/local/backup ] ||  mkdir  -p  /usr/local/backup
[ -d  /usr/local/resault ] ||  mkdir  -p  /usr/local/resault

##edit the configuration file


[ `find / -name  "mod_deflate.so"` ]  || echo "mod_deflate.so is not exist"  ||  exit 1

if  [ grep  "mod_deflate.so"  $CONF_PATH | grep "^LoadModule"  ]
then
        echo  "mod_deflate.so is load"
else
        sed  -e  "/mod_include.so/a  LoadModule deflate_module  $(find / -name  "mod_deflate.so ")"  -i   $CONF_PATH
fi

cat  <<EOF>>  $CONF_PATH
# Insert filter

SetOutputFilter DEFLATE

# Netscape 4.x has some problems...

BrowserMatch ^Mozilla/4 gzip-only-text/html

# Netscape 4.06-4.08 have some more problems

BrowserMatch ^Mozilla/4\.0[678] no-gzip

# MSIE masquerades as Netscape, but it is fine

BrowserMatch \bMSIE !no-gzip !gzip-only-text/html 

# Don't compress images

SetEnvIfNoCase Request_URI \.(?:gif|jpe?g|png)$ no-gzip dont-vary

# Make sure proxies don't deliver the wrong content

# Header append Vary User-Agent env=!dont-vary
EOF

