#！/bin/bash
#下载shelldetect.py到/usr/local/shelldetect目录下
mkdir /usr/local/shelldetect
cd /usrl/local/shelldetect
wget https://raw.github.com/emposha/Shell-Detector/master/shelldetect.py
wget http://xxx.com/shelldetect.db
#更新env_config中shelldetect的相关信息

#使用方法 python shelldetect.py -r True -d ./