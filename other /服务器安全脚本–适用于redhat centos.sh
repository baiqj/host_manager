#!/bin/sh

###################################################################################
# Security Script for RedHat Linux
# Author:51iker
# Date:2008/12/23
#
##################################################################################

#—————————–Define Variable————————————-
export LANG=en
DATETIME=`date +%Y%m%d-%M%S`
SERVICES=(autofs firstboot cups gpm nfs nfslock xfs netfs sendmail yum\-updatesd restrorecond mcstrans avahi\-daemon anacron kudzu portmap)
MD5SUM=(ps netstat ls last w ifconfig tcpdump iptraf top swatch nice lastb md5sum name)
IPV6=$(ifconfig | grep “inet6″)
Filename=`ifconfig -a |grep inet |grep -v “127.0.0.1″ |awk ‘{print $2}’| head -1 | awk -F”:” ‘{ print $2}’`-$DATETIME-md5
BKDir=/var/ikerbk

#—————————-Create report/back Directory————————-
mkdir -p $BKDir

#—————————-Modify Default Language——————————
echo -n “modfiy env_LANG”
if [ -f /etc/sysconfig/i18n ]; then
cp /etc/sysconfig/i18n $BKDir/$DATETIME\_i18n
Lang=`grep “^LANG=” /etc/sysconfig/i18n`
Lang1=`grep “^SUPPORTED=”        /etc/sysconfig/i18n`
Lang2=`grep “^SYSFONT=”  /etc/sysconfig/i18n`
        if [ -z "$Lang" ]; then
        sed -i ‘1i\LANG=”en_US.UTF-8″‘ /etc/sysconfig/i18n
        echo ” : insert [OK]”
        else
        sed -i ’s/LANG=.*/LANG=”en_US.UTF-8″/g’ /etc/sysconfig/i18n
        echo ” : modfiy [OK]”
        fi

        if [ -z "$Lang1" ]; then
        sed -i ‘1a\SUPPORTED=”en_US.UTF-8:en_US:en”‘ /etc/sysconfig/i18n
        echo “SUPPORTED insert [OK]”
        else
        sed -i ’s/SUPPORTED=.*/SUPPORTED=”en_US.UTF-8:en_US:en”/g’ /etc/sysconfig/i18n
        echo “SUPPORTED modfiy [OK]”
        fi

        if [ -z "$Lang2" ]; then
        sed -i ‘1a\SYSFONT=”latarcyrheb-sun16″‘ /etc/sysconfig/i18n
        echo “SYSFONT insert [OK]”
        else
        sed -i ’s/SYSFONT=.*/SYSFONT=”latarcyrheb-sun16″/g’ /etc/sysconfig/i18n
        echo “SYSFONT modfiy [OK]”
        fi
else
        echo ” : File /etc/sysconfig/i18n not exist [False]”
fi

#—————————–SSH Protocol 2————————————
echo -n “change sshd <Protocol 2>”
if [ -f /etc/ssh/sshd_config ] ; then
cp /etc/ssh/sshd_config $BKDir/$DATETIME-sshd_config
Proto=`sed -n ‘/^Protocol/p’ /etc/ssh/sshd_config`
Proto1=`sed -n ‘/^Protocol/p’ /etc/ssh/sshd_config | awk ‘{ print $2 }’`
if [ -z "$Proto" ]; then
        sed -i ‘1i\Protocol 2\’ /etc/ssh/sshd_config
        echo “  [OK]”
        elif [ "$Proto1" != "2" ]; then
        sed -i “s/^$Proto/Protocol 2/g” /etc/ssh/sshd_config
        echo “  [OK]”
fi
else
        echo “  :File /etc/ssh/sshd_config not exist [False]”
fi

#—————————–Stop Unuse Services———————————
for x in “${SERVICES[@]}”; do
 state1=`chkconfig –list | grep $x | awk ‘{print substr($5,3,5)}’`
 if [ "$state1" == "on" ]; then
  service $x stop
              chkconfig –level 3 $x off
       else
              echo “$x state is stop [OK]”
       fi
done

for i in `ls /etc/rc3.d/S*`
        do
             CURSRV=`echo $i|cut -c 15-`
echo $CURSRV
case $CURSRV in
    crond | irqbalance | microcode_ctl | lvm2-monitor | network | iptables | sshd |syslog)
        echo “Base services, Skip!”
        ;;
     *)
    echo “change $CURSRV to off”
    chkconfig –level 2345 $CURSRV off
    service $CURSRV stop
    ;;
esac
done
#—————————–Force Password Lenth——————————–
echo -n “change <password> length”
if [ -f /etc/login.defs ]; then
cp /etc/login.defs $BKDir/$DATETIME\_login.defs
        sed -i ’s/PASS_MIN_LEN.*5/PASS_MIN_LEN  8/’ /etc/login.defs
        echo “   [OK]”
else
        echo ” :File /etc/login.defs not exist [False]”
fi

#—————————-Define SSH Session TIMEOUT—————————
echo -n “modfiy Histsize and TMOUT”
if [ -f /etc/profile ]; then
cp /etc/profile $BKDir/$DATETIME\_profile
        sed -i ’s/HISTSIZE=.*/HISTSIZE=128/’ /etc/profile
        echo “  [OK]”

        Timeout=`grep “TMOUT=” /etc/profile`
        if [ -z $Timeout ] ; then
        echo “TMOUT=900″ >> /etc/profile
        else
        sed -i ’s/.*TMOUT=.*/TMOUT=900/g’ /etc/profile
        fi
else
        echo “  :File /etc/profile not exist [False]”
fi

#—————————–Check tmp Directory Stick—————————
if [ -d /tmp/ ]; then
echo -n “modfiy /tmp/ +t”
chmod +t /tmp/
echo  ” [OK]”
else
        mkdir /tmp &&   chmod 777 /tmp && chmod +t /tmp
        echo “  [mkdir /tmp]”
fi

#—————————–Close tty4/5/6————————————–
echo -n “modify Control-Alt-Delete”
if [ -f /etc/inittab ]; then
cp /etc/inittab  $BKDir/$DATETIME\_inittab
sed -i  ’s/\(^ca\:\:ctrlaltdel\:\/sbin\/shutdown.*\)/#\1/g’ /etc/inittab
sed -i  ’s/\(^4:2345:respawn.*\)/#\1/g’ /etc/inittab
sed -i  ’s/\(^5:2345:respawn.*\)/#\1/g’ /etc/inittab
sed -i  ’s/\(^6:2345:respawn.*\)/#\1/g’ /etc/inittab
 echo ” : Control-Alt-Delete AND tty-456 [OK]”
        else
        echo “file /etc/inittab NOT EXIST”
fi

#—————————–Clean Console Information—————————
echo -n “Clean boot infomation”
Check=`sed -n ‘/issue.net/p’ /etc/rc.local`
if [ -f /etc/issue -a -f /etc/issue.net ]; then
 echo “” >  /etc/issue
       echo “” >  /etc/issue.net
 if [ -z "$Check" ]; then
  echo ‘echo “” >  /etc/issue’    >> /etc/rc.local
  echo ‘echo “” >  /etc/issue.net’        >> /etc/rc.local
  echo    “   [OK]”
 fi
else
        echo “  :File /etc/issue or /etc/issue.net not exist [False]”
fi

#—————————-Close IPV6——————————————-
if [ -n "$IPV6" ]; then
        if [ -f /etc/sysconfig/network -a -f /etc/modprobe.conf ]; then
        cp /etc/sysconfig/network $BKDir/$DATETIME\_network
        cp /etc/modprobe.conf   $BKDir/$DATETIME\_modprobe.conf
                Netipv6=`grep “^NETWORKING_IPV6=yes” /etc/sysconfig/network`
                echo -n “modfiy ipv6 clean”
                if [ -z $Netipv6 ]; then
                        echo “  already [OK]”
                else
                        sed -i ’s/^NETWORKING_IPV6=yes/NETWORKING_IPV6=no/g’ /etc/sysconfig/network
                        echo “  [OK]”
                fi
                        Ipv6mod=`sed -n  ‘/^alias.*ipv6.*off/p’ /etc/modprobe.conf`
                        echo -n “modfiy ipv6_mod clean”
                if [ -z "$Ipv6mod" ]; then
                 echo ”
alias net-pf-10 off
alias ipv6 off”  >> /etc/modprobe.conf
                echo “  [OK]”
                else
                echo “  IPV6 mod already [OK]”
                fi
        else “File /etc/sysconfig/network or /etc/modprobe.conf not exist [False]”
        fi
else
        echo “IPV6 not support [OK]”
fi

#—————–Protect File passwd/shadow/group/gshadow/services—————
echo -n “modfiy passwd_file +i ”
#chattr +i /etc/passwd
#chattr +i /etc/shadow
#chattr +i /etc/group
#chattr +i /etc/gshadow
#chattr +i /etc/services
echo    “  [OK]”

#——————————Clean Command History——————————
echo -n “modify bash_history”
if [ -f /root/.bash_logout ]; then
        LOGOUT=`grep “rm -f” /root/.bash_logout`
        if  [ -z "$LOGOUT" ] ; then
        sed -i ‘/clear/i \rm -f  $HOME/.bash_history’ /root/.bash_logout
        echo “    [OK]”
        else
        echo “  Already [OK]”
        fi
else
        echo “  :File /root/.bash_logout not exist [False]”
fi

#—————————–Group wheel su root———————————
echo -n “modify su root”
if [ -f /etc/pam.d/su ]; then
cp /etc/pam.d/su $BKDir/$DATETIME\_su
        sed -i ’s/.*pam_wheel.so use_uid$/auth           required        pam_wheel.so use_uid/’ /etc/pam.d/su
        echo “  [OK]”
else
        echo “  :File /etc/pam.d/su not exist [False]”
fi

#————————-Log Important Command’s MD5 Information—————–
echo  “MD5 check files ”
for xx in “${MD5SUM[@]}”; do
NAME=`whereis $xx | awk ‘{print $2}’`
        if [ -z $NAME ]; then
        continue
        else
        md5sum $NAME >> $BKDir/$Filename
        echo    “$NAME       [OK]”
        fi
done

#————————Modify Kernel Parameters About Security——————
#–net.ipv4.conf.all.rp_filter 双网卡有问题，不使用
echo -n “modfiy /etc/sysctl.conf”
if [ -f /etc/sysctl.conf ]; then
cp /etc/sysctl.conf $BKDir/$DATETIME\_sysctl.conf
Net=(net.ipv4.ip_forward
net.ipv4.conf.all.accept_source_route
net.ipv4.conf.all.accept_redirects
net.ipv4.tcp_syncookies
net.ipv4.conf.all.log_martians
net.ipv4.icmp_echo_ignore_broadcasts
net.ipv4.icmp_ignore_bogus_error_responses)
for i in “${Net[@]::3}”; do
Zero=`sed  -n “/^$i/p” /etc/sysctl.conf | awk -F”=”  ‘{ print $2 }’ | sed ’s/ //g’`
Zero1=`sed  -n “/^$i/p” /etc/sysctl.conf`
                if [ -z "$Zero" ]; then
                        if [ -z "$Zero1" ];then
                        echo “$i = 0″ >> /etc/sysctl.conf
                        echo “$i is [OK]”
                        else
                        sed -i “s/$i.*/$i = 0/g” /etc/sysctl.conf
                        echo “$i is [OK]”
                        fi
                fi
        if [ "$Zero" == "0" ]; then
        echo “$i is [OK]”
        else
        sed -i “s/$i.*/$i = 0/g” /etc/sysctl.conf
        fi
done

for i in “${Net[@]:3}”; do
One=`sed  -n “/^$i/p” /etc/sysctl.conf | awk -F”=”  ‘{ print $2 }’ | sed ’s/ //g’`
One1=`sed  -n “/^$i/p” /etc/sysctl.conf`
                if [ -z "$One" ]; then
                        if [ -z "$One1" ];then
                        echo “$i = 1″ >> /etc/sysctl.conf
                        echo “$i is [OK]”
                        else
                        sed -i “s/$i.*/$i = 1/g” /etc/sysctl.conf
                        echo “$i is [OK]”
                        fi
                fi
        if [ "$One" == "1" ]; then
        echo “$i is [OK]”
        else
        sed -i “s/$i.*/$i = 1/g” /etc/sysctl.conf
        fi
done

else
        echo “:File /etc/sysctl.conf not exist [Flase]”
fi

sysctl -p >> $BKDir/$Filename
init q
