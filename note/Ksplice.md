


## how to install on CentOS 5 6 7

wget https://www.ksplice.com/yum/uptrack/centos/ksplice-uptrack-release.noarch.rpm

rpm -i ksplice-uptrack-release.noarch.rpm

yum -y install uptrack 

Edit /etc/uptrack/uptrack.conf and insert your access key. Please use the same access key for all of your systems. If you would like Uptrack to automatically install rebootless kernel updates as they become available, set autoinstall = yes.

When you are done with your Uptrack configuration, please run the following command as root to bring your kernel up to date:

uptrack-upgrade -y


how to use

https://www.ksplice.com/uptrack/using
