#！/bin/sh

# desc： setup linux system security

# author:coralzd

# powered by www.freebsdsystem.org

# version 0.1.2 written by 2011.05.03

#设置账号

passwd -l xfs

passwd -l news

passwd -l nscd

passwd -l dbus

passwd -l vcsa

passwd -l games

passwd -l nobody

passwd -l avahi

passwd -l haldaemon

passwd -l gopher

passwd -l ftp

passwd -l mailnull

passwd -l pcap

passwd -l mail

passwd -l shutdown

passwd -l halt

passwd -l uucp

passwd -l operator

passwd -l sync

passwd -l adm

passwd -l lp

# 用chattr给用户路径更改属性。chattr命令用法参考文末说明［1］

chattr +i /etc/passwd

chattr +i /etc/shadow

chattr +i /etc/group

chattr +i /etc/gshadow

# 设置密码连续输错3次后锁定5分钟

 

sed -i ‘s#auth required pam_env.so#auth required pam_env.so auth required pam_tally.so onerr=fail deny=3 unlock_time=300 auth required /lib/security/$ISA/pam_tally.so onerr=fail deny=3 unlock_time=300#’ /etc/pam.d/system-auth

# 5分钟后自动登出，原因参考文末说明［2］

echo “TMOUT=300” 》》/etc/profile

# 历史命令记录数设定为10条

sed -i “s/HISTSIZE=1000/HISTSIZE=10/” /etc/profile

# 让以上针对 /etc/profile 的改动立即生效

source /etc/profile

# 在 /etc/sysctl.conf 中启用 syncookie

echo “net.ipv4.tcp_syncookies=1” 》》/etc/sysctl.conf

sysctl -p # exec sysctl.conf enable

# 优化 sshd_config

sed -i “s/#MaxAuthTries 6/MaxAuthTries 6/” /etc/ssh/sshd_config

sed -i “s/#UseDNS yes/UseDNS no/” /etc/ssh/sshd_config

# 限制重要命令的权限

chmod 700 /bin/ping

chmod 700 /usr/bin/finger

chmod 700 /usr/bin/who

chmod 700 /usr/bin/w

chmod 700 /usr/bin/locate

chmod 700 /usr/bin/whereis

chmod 700 /sbin/ifconfig

chmod 700 /usr/bin/pico

chmod 700 /bin/vi

chmod 700 /usr/bin/which

chmod 700 /usr/bin/gcc

chmod 700 /usr/bin/make

chmod 700 /bin/rpm

# 历史安全

chattr +a /root/.bash_history

chattr +i /root/.bash_history

# 给重要命令写 md5

cat 》list 《《“EOF” &&

/bin/ping

/usr/bin/finger

/usr/bin/who

/usr/bin/w

/usr/bin/locate

/usr/bin/whereis

/sbin/ifconfig

/bin/vi

/usr/bin/vim

/usr/bin/which

/usr/bin/gcc

/usr/bin/make

/bin/rpm
EOF

done

rm -f list