#!/bin/bash


CMD_PATH=`find /  -name "php"  -a -type  f  -a   -perm +111  | head -n 1`

$CMD_PATH  -m  >  /usr/local/resault/php_modules.txt

