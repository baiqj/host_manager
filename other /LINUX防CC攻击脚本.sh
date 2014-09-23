#!/bin/sh
cd /var/log/httpd/
cat access_log|awk '{print $1}'|sort|uniq -c|sort -n -r|head -n 20 > a
cp /dev/null access_log
cp /dev/null error_log
cp /dev/null limit.sh
cp /dev/null c
#awk '{print $2}' a|awk -F. '{print $1"."$2"."$3}'|sort|uniq > b
cat a|while read num ip
do
if [ "$num" -gt "20" ]
then
echo $ip >> c
fi
done
cat c|awk -F. '{print $1"."$2"."$3}'|sort|uniq > b
#cat c|sort|uniq > b
for i in `cat b`
#cat b|sed 's/\./ /g'|while read i1 i2 i3 i4
do
if `cat ourip |grep $i > /dev/null 2>&1`
then
echo "`date` $i" >> test
else
echo "iptables -I INPUT -p tcp -dport 80 -s $i.0/24 -j DROP" >> limit.sh
fi
done
