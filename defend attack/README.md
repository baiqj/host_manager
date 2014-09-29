

# linux安全防护

* 对linux系统进行安全增强  
* denyhost
* 安装rkhunter
* Linux Malware Detect

https://www.rfxn.com/projects/linux-malware-detect/


* 安装 DDoS deflate 

DDoS deflate的安装非常简单：

wget http://www.inetbase.com/scripts/ddos/install.sh

chmod +x install.sh

./install.sh
然后会自动进行安装，完成后会有一段版权提示与说明，按q键退出即可。
 
卸载方法
1
wget http://www.inetbase.com/scripts/ddos/uninstall.ddos
2
chmod +x uninstall.ddos
3
./uninstall.ddos
 
主要功能与配置
1、可以设置IP白名单，在 /usr/local/ddos/ignore.ip.list 中设置即可；
2、主要配置文件位于 /usr/local/ddos/ddos.conf ，打开此文件，根据提示进行简单的编辑即可；
3、DDoS deflate可以在阻止某一IP后，隔一段预置的时候自动对其解封；
4、可以在配置文件中设置多长时间检查一次网络连接情况；
5、当阻止IP后，可以设置Email提醒
 
配置示例
DDoS deflate的配置非常简单：

REQ=1 #检测的频率为1分钟

NO_OF_CONNECTIONS=100 #当单个IP超过100个连接请求时判定为DDOS

APF_BAN=0

#如果打算使用APF阻止IP，则设置为1（需要预先安装APF）；如果使用iptables，则设置为0；

KILL=1 #是否阻止

EMAIL_TO="webmaster@bootf.com" #接收邮件

 

BAN_PERIOD=600 #阻止时长，10分钟
相关参考



# php 安全防护

* php的安全配置
* install Suhosin
* php的木马检测
* 安装PHP-Shell-Detector http://www.shelldetector.com/
* install 安装falcon-web https://github.com/secrule/falcon

# nginx 安全防护


* install mod_security 



安装方法


