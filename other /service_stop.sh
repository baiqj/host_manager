#!/bin/bash
# This script is used to del some service is not used on the server
# 
# Date 2010-03-23
# 
service  microcode_ctl stop
chkconfig --level 235 microcode_ctl off
service gpm stop
chkconfig --level 235 gpm off
service kudzu stop
chkconfig --level 235 kudzu off
service netfs stop
chkconfig --level 235 netfs off
service rawdevices stop
chkconfig --level 235 rawdevices off
service saslauthd stop
chkconfig --level 235 saslauthd off
service keytable stop
chkconfig --level 235 keytable off
service mdmonitor stop
chkconfig --level 235 mdmonitor off
service atd stop
chkconfig --level 235 atd off
service irda stop
chkconfig --level 235 irda off
service psacct stop
chkconfig --level 235 psacct off
service apmd stop
chkconfig --level 235 apmd off
service isdn stop
chkconfig --level 235 isdn off
service iptables stop
chkconfig --level 235 iptables off
service ip6tables stop
chkconfig --level 235 ip6tables off
service pcmcia stop
chkconfig --level 235 pcmcia off
service sendmail stop
chkconfig --level 235 sendmail off
service smartd stop
chkconfig --level 235 smartd off
service autofs stop
chkconfig --level 235 autofs off
service netdump stop
chkconfig --level 235 netdump off
service portmap stop
chkconfig --level 235 portmap off
service nfs stop
chkconfig --level 235 nfs off
service nfslock stop
chkconfig --level 235 nfslock off
service snmptrapd stop
chkconfig --level 235 snmptrapd off
service rhnsd stop
chkconfig --level 235 rhnsd off
service xinetd stop
chkconfig --level 235 xinetd off
service cups stop
chkconfig --level 235 cups off
service snmpd stop
chkconfig --level 235 snmpd off
service vncserver stop
chkconfig --level 235 vncserver off
service hpoj stop
chkconfig --level 235 hpoj off
service xfs stop
chkconfig --level 235 xfs off
service ntpd stop
chkconfig --level 235 ntpd off
service winbind stop
chkconfig --level 235 winbind off
service smb stop
chkconfig --level 235 smb off
service dc_client stop
chkconfig --level 235 dc_client off
service dc_server stop
chkconfig --level 235 dc_server off
service httpd stop
chkconfig --level 235 httpd off
service aep1000 stop
chkconfig --level 235 aep1000 off
service bcm5820 stop
chkconfig --level 235 bcm5820 off
service squid stop
chkconfig --level 235 squid off
service named stop
chkconfig --level 235 named off
service tux stop
chkconfig --level 235 tux off
service vsftpd stop
chkconfig --level 235 vsftpd off
service avahi-daemon stop
chkconfig --level 235 avahi-daemon  off
service bluetooth stop
chkconfig --level 235 bluetooth off
service firstboot stop
chkconfig --level 235 firstboot off
service lvm2-monitor stop
chkconfig --level 235 lvm2-monitor off
service mcstrans stop
chkconfig --level 235 mcstrans off
service pcscd stop
chkconfig --level 235 pcscd off
service restorecond stop
chkconfig --level 235 restorecond off
service rpcgssd stop
chkconfig --level 235 rpcgssd off
service rpcidmapd stop
chkconfig --level 235 rpcidmapd off
chmod +x /root/service_stop.sh
