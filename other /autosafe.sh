#!/bin/bash
#########################################################################
#
# File:         autosafe.sh
# Description:  
# Language:     GNU Bourne-Again SHell
# Version:	1.1
# Date:		2010-6-23
# Corp.:	c1gstudio.com
# Author:	c1g
# WWW:		http://blog.c1gstudio.com
### END INIT INFO
###############################################################################

V_DELUSER="adm lp sync shutdown halt mail news uucp operator games gopher ftp"
V_DELGROUP="adm lp mail news uucp games gopher mailnull floppy dip pppusers popusers slipusers daemon"
V_PASSMINLEN=8
V_HISTSIZE=30
V_TMOUT=300
V_GROUPNAME=suadmin
V_SERVICE="acpid anacron apmd atd auditd autofs avahi-daemon avahi-dnsconfd bluetooth cpuspeed cups dhcpd firstboot gpm haldaemon hidd ip6tables ipsec isdn kudzu lpd mcstrans messagebus microcode_ctl netfs nfs nfslock nscd pcscd portmap readahead_early restorecond rpcgssd rpcidmapd rstatd sendmail setroubleshoot snmpd sysstat xfs xinetd yppasswdd ypserv yum-updatesd"
V_TTY="3|4|5|6"
V_SUID=(
	'/usr/bin/chage' 
	'/usr/bin/gpasswd' 
	'/usr/bin/wall' 
	'/usr/bin/chfn' 
	'/usr/bin/chsh' 
	'/usr/bin/newgrp'
	'/usr/bin/write' 
	'/usr/sbin/usernetctl' 
	'/bin/traceroute' 
	'/bin/mount'
	'/bin/umount' 
	'/sbin/netreport' 
)
version=1.0


# we need root to run 
if test "`id -u`" -ne 0
then
	echo "You need to start as root!"
	exit
fi

case $1 in
	"deluser")
		 echo "delete user ..."
		 for i in $V_DELUSER ;do 
		 echo "deleting $i";
		 userdel $i ;
		 done
		;;

	"delgroup")
		 echo "delete group ..."
		 for i in $V_DELGROUP ;do 
		 echo "deleting $i";
		 groupdel $i;
		 done
		;;

	"password")
		 echo "change password limit ..."
		 echo "/etc/login.defs"
		 echo "PASS_MIN_LEN $V_PASSMINLEN"
		 sed -i "/^PASS_MIN_LEN/s/5/$V_PASSMINLEN/" /etc/login.defs 
		;;

	"history")
		 echo "change history limit ..."
		 echo "/etc/profile"
		 echo "HISTSIZE $V_HISTSIZE"
		 sed -i "/^HISTSIZE/s/1000/$V_HISTSIZE/" /etc/profile 
		;;

	"logintimeout")
		 echo "change login timeout ..."
		 echo "/etc/profile"
		 echo "TMOUT=$V_TMOUT"
		 sed -i "/^HISTSIZE/a\TMOUT=$V_TMOUT" /etc/profile 
		;;

	"bashhistory")
		echo "denied bashhistory ..."
		echo "/etc/skel/.bash_logout"
		echo 'rm -f $HOME/.bash_history'
		if egrep "bash_history" /etc/skel/.bash_logout > /dev/null
		then
			echo 'warning:existed'
		else
		 echo 'rm -f $HOME/.bash_history' >> /etc/skel/.bash_logout 
		fi

		;;
	"addgroup")
		echo "groupadd $V_GROUPNAME ..."
		groupadd $V_GROUPNAME
		;;

	"sugroup")
		echo "permit $V_GROUPNAME use su ..."
		echo "/etc/pam.d/su"
		echo "auth sufficient /lib/security/pam_rootok.so debug"
		echo "auth required /lib/security/pam_wheel.so group=$V_GROUPNAME"
		if egrep "auth sufficient /lib/security/pam_rootok.so debug" /etc/pam.d/su > /dev/null
		then
			echo 'warning:existed'
		else
			echo 'auth sufficient /lib/security/pam_rootok.so debug' >> /etc/pam.d/su 
			echo "auth required /lib/security/pam_wheel.so group=${V_GROUPNAME}" >> /etc/pam.d/su 
		fi
		;;

	"denyrootssh")
		echo "denied root login ..."
		echo "/etc/ssh/sshd_config"
		echo "PermitRootLogin no"
		sed -i '/^#PermitRootLogin/s/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config 
		;;

	"stopservice")
		echo "stop services ..."
			for i in $V_SERVICE ;do 
			service $i stop;
			done
		;;

	"closeservice")
		echo "close services autostart ..."
			for i in $V_SERVICE ;do
			chkconfig $i off;
			done
		;;

	"tty")
		echo "close tty ..."
		echo "/etc/inittab"
		echo "#3:2345:respawn:/sbin/mingetty tty3"
		echo "#4:2345:respawn:/sbin/mingetty tty4"
		echo "#5:2345:respawn:/sbin/mingetty tty5"
		echo "#6:2345:respawn:/sbin/mingetty tty6"
		sed -i '/^[$V_TTY]:2345/s/^/#/' /etc/inittab
		;;

	"ctrlaltdel")
		echo "close ctrl+alt+del to restart server ..."
		echo "/etc/inittab"
		echo "#ca::ctrlaltdel:/sbin/shutdown -t3 -r now"
		sed -i '/^ca::/s/^/#/' /etc/inittab
		;;

	"lockfile")
		echo "lock user&services ..."
		echo "chattr +i /etc/passwd /etc/shadow /etc/group /etc/gshadow /etc/services"
		chattr +i /etc/passwd /etc/shadow /etc/group /etc/gshadow /etc/services
		;;

	"unlockfile")
		echo "unlock user&services ..."
		echo "chattr -i /etc/passwd /etc/shadow /etc/group /etc/gshadow /etc/services"
		chattr -i /etc/passwd /etc/shadow /etc/group /etc/gshadow /etc/services
		;;

	"chmodinit")
		echo "init script only for root ..."
		echo "chmod -R 700 /etc/init.d/*"
		echo "chmod 600 /etc/grub.conf"
		echo "chattr +i /etc/grub.conf"
		chmod -R 700 /etc/init.d/*
		chmod 600 /etc/grub.conf 
		chattr +i /etc/grub.conf
		;;

	"chmodcommand")
		echo "remove SUID ..."
		echo "/usr/bin/chage /usr/bin/gpasswd ..."
		for i in ${V_SUID[@]};
		do
			chmod a-s $i
		done
		;;

        "version")
                echo "Version: Autosafe for Linux $version"
                ;;

	*)	
		echo "Usage: $0 <action>"
		echo ""
		echo "	deluser      delete user"
		echo "	delgroup     delete group"
		echo "	password     change password limit"
		echo "	history      change history limit"
		echo "	logintimeout      change login timeout"
		echo "	bashhistory      denied bashhistory"
		echo "	addgroup      groupadd $V_GROUPNAME"
		echo "	sugroup      permit $V_GROUPNAME use su"
		echo "	denyrootssh      denied root login"
		echo "	stopservice     stop services "
		echo "	closeservice      close services"
		echo "	tty      close tty"
		echo "	ctrlaltdel     close ctrl+alt+del"
		echo "	lockfile      lock user&services"
		echo "	unlockfile      unlock user&services"
		echo "	chmodinit      init script only for root"
		echo "	chmodcommand      remove SUID"
		echo "	version      "
		echo ""

		;;
esac
