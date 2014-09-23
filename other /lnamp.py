#!/usr/bin/env python
#coding:utf-8

import os
import sys
from random import choice
import string
from os import system
import socket
import re
import platform
from urlparse import urlparse
import shutil
import getopt
import urllib
import urllib2
from urlparse import urlparse
from string import Template
from optparse import OptionParser 
import crypt
import time
from glob import glob

urllib2.socket.setdefaulttimeout(10)

# 可用的PHP子版本号
all_php_vers = ('5.2', '5.3', '5.4', '5.5')

# 安装的Apache子版本号
apache_ver = '2.2'

# 安装的MySQL子版本号
mysql_ver = '5.5'

# 文件下载保存目录
file_dir = '/tmp/dir/'

# 文件下载站点(结尾必须有/)
download_site = 'http://down.lnamp.server110.com/'

# 安装失败bug报告地址
bug_report_url = 'http://bug.lnamp.server110.com/post.php'

# 检查端口
check_ports = ('20', '21', '80', '8080', '3306', '11211', '1000')

# 颜色值
BLUE  = '\033[34m'
GREEN = '\033[32m'
CYAN  = '\033[36m'
RED   = '\033[31m'
PURPLE= '\033[35m'
YELLOW= '\033[33m'
WHITE = '\033[37m'
GREY  = '\033[38m'
BLACK = '\033[0m'


####################### 文件下载列表 #######################

mysql_file = (
    'my-big.cnf',
    'my-large.cnf',
    'my-mini.cnf',
    'my-small.cnf',
    'my-huge.cnf',
    'my-medium.cnf',
    'my-monster.cnf'
)

nginx_file = (
    'nginx_proxy.conf',
    'nginx.init',
    'proxy.conf',
    'proxy2.conf'
)

apache_file = (
    'mod_rpaf-0.6.tar.gz',
    'httpd.conf',
    'httpd.init',
    'httpd-default.conf',
    'httpd-vhosts.conf',
    'httpd-rpaf.conf',
    'httpd-mpm-big.conf',
    'httpd-mpm-large.conf',
    'httpd-mpm-mini.conf',
    'httpd-mpm-small.conf',
    'httpd-mpm-huge.conf',
    'httpd-mpm-medium.conf',
    'httpd-mpm-monster.conf'
)

pma_file = (
    'phpMyAdmin-3.3.10.5-all-languages.tar.gz',
    'pma_apache.conf',
    'pma_nginx.conf'
)

xcache_file = 'xcache-3.1.0.tar.gz'
imagick_file = 'imagick-3.1.2.tgz'
libmcrypt_file = 'libmcrypt-2.5.8.tar.gz'
mhash_file = 'mhash-0.9.9.9.tar.gz'
memcache_file = 'memcache-2.2.7.tgz'
memcached_file = ('memcached-1.4.15.tar.gz', 'memcached.init')
proftpd_file = 'proftpd-1.3.4d.tar.gz'
opcache_file = 'zendopcache-7.0.3.tgz'
php_max_input_vars_patch = 'php-5.2.17-max-input-vars.patch'
php_dom_patch = 'php_dom.patch'
php_debian_sslv2_patch = 'debian_patches_disable_SSLv2_for_openssl_1_0_0.patch'
proftpd_file = ('proftpd-1.3.4d.tar.gz', 'proftpd.init')
axel_file = 'axel-2.4.tar.gz'

debian_functions = (
    'functions.init'
)

zend_file_i386 = {
    '5.2':'ZendOptimizer-3.3.9-linux-glibc23-i386.tar.gz',
    '5.3':'ZendGuardLoader-php-5.3-linux-glibc23-i386.tar.gz',
    '5.4':'ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz'
}

zend_file_x86_64 = {
    '5.2':'ZendOptimizer-3.3.9-linux-glibc23-x86_64.tar.gz',
    '5.3':'ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz',
    '5.4':'ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz'
}

zend_file = {
    '32bit' : zend_file_i386,
    '64bit' : zend_file_x86_64
}

zend_file_333 = {
    '32bit' : 'ZendOptimizer-3.3.3-linux-glibc23-i386.tar.gz',
    '64bit' : 'ZendOptimizer-3.3.3-linux-glibc23-x86_64.tar.gz'
}

site_file = 'site.py'

nginx_bak_url = 'nginx-1.4.4.tar.gz'
mysql_bak_url = 'mysql-5.5.35.tar.gz'
apache_bak_url = 'httpd-2.2.26.tar.gz'

php52_bak_url = 'php-5.2.17.tar.gz'
php53_bak_url = 'php-5.3.28.tar.gz'
php54_bak_url = 'php-5.4.24.tar.gz'
php55_bak_url = 'php-5.5.8.tar.gz'


####################### 下载列表结束 #######################

# php.ini: xcache
php_ini_xcache = '''
[xcache-common]
extension = xcache.so

[xcache.admin]
xcache.admin.enable_auth = On
xcache.admin.user = "admin"
xcache.admin.pass = "unknowpass"

[xcache]
xcache.shm_scheme =        "mmap"
xcache.size  =               64M
xcache.count =                 1
xcache.slots =                8K
xcache.ttl   =                 0
xcache.gc_interval =           0
xcache.var_size  =            4M
xcache.var_count =             1
xcache.var_slots =            8K
xcache.var_ttl   =             0
xcache.var_maxttl   =          0
xcache.var_gc_interval =     300
xcache.var_namespace_mode =    0
xcache.var_namespace =        ""
xcache.readonly_protection = Off
xcache.mmap_path =    "/dev/zero"
xcache.coredump_directory =   ""
xcache.coredump_type =         0
xcache.disable_on_crash =    Off
xcache.experimental =        Off
xcache.cacher =               On
xcache.stat   =               On
xcache.optimizer =           Off

[xcache.coverager]
xcache.coverager =           Off
xcache.coverager_autostart =  On
xcache.coveragedump_directory = ""
'''

# php.ini: ZendOptimizer For PHP5.2
php_ini_zend52 = '''
[Zend Optimizer] 
zend_optimizer.optimization_level=1 
zend_extension="/usr/local/php/extensions/ZendOptimizer.so" 
'''

# php.ini: ZendOptimizer For PHP5.3+
php_ini_zend53 = '''
[Zend Optimizer] 
zend_optimizer.optimization_level=1 
zend_extension="/usr/local/php/extensions/ZendGuardLoader.so" 
zend_loader.enable=On
'''

# php.ini: memcache
php_ini_memcache = "extension = memcache.so"

# php.ini: imagick
php_ini_imagick = "extension = imagick.so"

# php.ini: opcache
php_ini_opcache = '''
zend_extension=/usr/local/php/extensions/opcache.so 
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=60
opcache.fast_shutdown=1
opcache.enable_cli=1
'''

# /etc/proftpd.conf
proftpd_conf = '''
ServerName                      "Server 110 ProFTPD"
ServerType                      standalone
DefaultServer                   on
Port                            21
UseIPv6                         off
Umask                           022
MaxInstances                    30
User                            proftpd
Group                           proftpd
AllowOverwrite                  on
UseReverseDNS                   off
DefaultRoot                     ~
RequireValidShell               off 
'''

# finishing output
op_info = Template('''
Congratulations! Your Installation Is Complete.

Please Save Your Server Infomation.

phpMyAdmin
--------------------------
HTTP://${ip}:1000
USER    : root
PASSWORD: ${dbrootpwd}

FTP
--------------------------
USER    : www
PASSWORD: ${ftpwwwpwd}
HOME    : /home/www/
''')

def color(str, color):
    return color + str + BLACK

# 安装axel
def install_axel():
    if not os.path.exists(file_dir):
        download_file(axel_file)

        os.chdir(file_dir)
        os.chdir(get_dir('axel-'))

        run_cmd('./configure --bindir=/usr/bin --etcdir=/etc')
        run_cmd("make -j %s && make install" % cpu_num)

# 文件下载函数
def download_file(down):
    if isinstance(down, tuple):
        for url in down:
            download_file(url)
    else:
        if down[0:7] != 'http://':
            url = download_site + down
        else:
            url = down

            # 备用下载链接
            bak_url = ''
            if 'nginx-' in down:
                bak_url = download_site + nginx_bak_url
            elif 'mysql-' in down:
                bak_url = download_site + mysql_bak_url
            elif 'httpd-' in down:
                bak_url = download_site + apache_bak_url
            elif 'php-5.3' in down:
                bak_url = download_site + php53_bak_url
            elif 'php-5.4' in down:
                bak_url = download_site + php54_bak_url
            elif 'php-5.5' in down:
                bak_url = download_site + php55_bak_url

        print color('Downloading URL: ' + url, GREEN)
        if 'bak_url' in dir():
            print 'Backup URL: ' + bak_url

        # 下载目录
        if not os.path.exists(file_dir):
            os.mkdir(file_dir)

        # 下载保存绝对路径
        file_path = file_dir + url.split('/')[-1]

        # 下载并解压缩
        if url[-2:] == 'gz':
            retry = 0
            while True:
                if 'bak_url' in dir() and retry != 0:
                    url = bak_url
                if os.path.exists(file_path):
                    os.remove(file_path)

                if 'axel' in url:
                    cmd = 'wget -c -O %s -T 5 -t 5 %s' % (file_path, url)
                else:
                    cmd = 'axel -a -n 10 -o %s %s' % (file_path, url)
                system(cmd)

                res = system("gunzip -q -c %s | tar xvf - -C %s" % (file_path, file_dir))

                if res == 0:
                    os.remove(file_path)
                    break
                else:
                    retry += 1

        else:
            while True:
                if os.path.exists(file_path):
                    os.remove(file_path)
                cmd = 'wget -c -O %s -T 5 -t 5 %s' % (file_path, url)
                res = system(cmd)
                if res == 0:
                    break

def file_get_contents(file):
    return open(file).read()

def file_put_contents(file, content):
    fh = open(file, 'w')
    fh.write(content)
    fh.close

def file_append(file, content):
    fh = open(file, 'a')
    fh.write("\n" + content + '\n')
    fh.close

def force_copy(src, dst):
    if os.path.exists(dst):
        os.remove(dst)
    if not os.path.exists(src):
        print 'File %s Not Exists!' % os.getcwd + '/' + src
        sys.exit()
    shutil.copyfile(src, dst)

def force_del(file):
    if os.path.exists(file):
        os.remove(file)

def gen_password(length=8,chars=string.ascii_letters+string.digits):
    return ''.join([choice(chars) for i in range(length)])

def disable_selinux():
    system('setenforce 0 &> /dev/null')
    if os.path.exists('/etc/selinux/config'):
        fh_selinux = open('/etc/selinux/config', 'w')
        fh_selinux.write('SELINUX=disabled')
        fh_selinux.close()

def add_ld_path():
    add_path = ''
    ld_list = list()
    fh_ld = open('/etc/ld.so.conf')
    for line in fh_ld.readlines():
        ld_list.append(line.strip('\n'))
    fh_ld.close()

    for dir in ('/lib', '/usr/lib', '/usr/lib64', '/usr/local/lib', '/usr/local/mysql/lib/'):
        if dir not in ld_list:
            add_path += ('%s\n' % dir)

    fh_ld = open('/etc/ld.so.conf', 'a')
    fh_ld.write(add_path)
    fh_ld.close()

    run_cmd('ldconfig')

def add_hosts():
    hostname = socket.gethostname()
    add_hosts = ('127.0.0.1 %s' % hostname)

    fh = open('/etc/hosts')
    for line in fh.readlines():
        if '127.0.0.1' in line.split() and hostname in line.split():
            del add_hosts
    fh.close

    if 'add_hosts' in dir():
        file_append('/etc/hosts', add_hosts)

def sys_op():
    fh = open('/etc/security/limits.conf', 'a')
    fh.write("* soft nofile 65535\n* hard nofile 65535\n")
    fh.close()

def get_mem(): 
    res = file_get_contents("/proc/meminfo")  
    m = re.findall('MemTotal:\s+(\d*)', res)
    return int(m[0])/1024

def get_html(url):
    fails = 0
    urllib2.socket.setdefaulttimeout(10)
    while True:
        try:
            if fails >= 5:
                return False
            req = urllib2.Request(url)
            response = urllib2.urlopen(req)
            page = response.read()
            return page
        except:
            fails += 1
            print 'Error %s/5: %s ' % (fails, url)

def get_dir(name):
    for dir in os.listdir('./'):
        if dir[0:len(name)] == name and os.path.isdir(dir):
            return str(dir)
    print "Error: NO dir start with %s" % name
    sys.exit()

def run_cmd(cmd):
    print 'CMD: ' + cmd
    status_code = system(cmd.strip() + ' 2>/tmp/error.log')
    if status_code != 0:
        error = file_get_contents('/tmp/error.log')
        print
        print "Error Occured!"
        print
        print "Current Work Dir:"
        print os.getcwd()
        print "Command:"
        print cmd
        print "Error:"
        print error

        # 发送错误报告
        process = shell_exec('ps auxf')
        port = shell_exec('netstat -ntpl')
        service = shell_exec('ls /etc/init.d/')

        values = {
            'os_dist':os_dist,
            'os_ver':os_ver,
            'arch':arch,
            'cwd':os.getcwd(),
            'cmd':cmd,
            'error':error,
            'process':process,
            'port':port,
            'service':service,
        }

        data = urllib.urlencode(values)
        req = urllib2.Request(bug_report_url, data)
        response = urllib2.urlopen(req)
        res = response.read()
        print res
        sys.exit()


def shell_exec(cmd):
    return os.popen(cmd).read()

def uninstall():

    system("rm -rf %s" % file_dir)

    for service in ('mysql', 'mysqld', 'nginx', 'httpd', 'memcached', 'proftpd'):
        system('/etc/init.d/%s stop' % service)

    if os_dist in('redhat', 'centos'):
        system('yum remove -y mysql* httpd* php* libmcrypt* proftpd vsftpd axel')
    else:
        system('apt-get remove -y mysql* apache* httpd* php* libmcrypt* proftpd vsftpd axel')

    all_ports_closed = True
    res = shell_exec('netstat -ntpl')
    lines = res.split("\n")

    for line in lines:
        fragments = re.split('\s+', line)
        if len(fragments) > 1:
            port_m = re.search(':(\d+)', fragments[3])
            if port_m:
                port = port_m.group(1)
                if port in check_ports:
                    pid_m = re.search('\d+', fragments[6])
                    pid = pid_m.group()
                    pro_path = os.path.realpath('/proc/%s/exe' % pid)

                    print "found %s run on port %s" % (pro_path, port)
                    all_ports_closed = False

    if not all_ports_closed:
        print "\nPlease remove the server software found above OR reinstall the OS.\nQuit!\n"
        sys.exit()

    if os.path.exists('/var/lib/mysql'):
        new_mysql_dir = "/var/lib/mysql_bak_" + time.strftime('%Y%m%d_%H%M%S')
        os.rename('/var/lib/mysql/', new_mysql_dir)
        

def install_dependence():
    if os_dist in('redhat', 'centos'):
        cmd = 'yum update -y'
        system(cmd)

        pkgs = ['gcc', 'gcc-c++', 'cmake', 'make', 'bison', 'file', 'redhat-lsb', 'sendmail']
        pkgs.extend(['libtool', 'libtool-ltdl', 'libtool-ltdl-devel', 'glibc-devel', 'glib2-devel'])
        pkgs.extend(['libevent-devel', 'readline-devel', 'ncurses-devel', 'zlib-devel', 'libc-client-devel'])
        pkgs.extend(['libxml2-devel', 'openssl-devel', 'curl-devel', 'bzip2-devel', 'libjpeg-devel'])
        pkgs.extend(['libpng-devel', 'freetype-devel', 'pcre-devel', 'mhash-devel', 'ImageMagick-devel'])
        pkgs.extend(['libtidy-devel', 'patch', ])

        for pkg in pkgs:
            print color('[*] Installing: %s' % pkg, GREEN)
            time.sleep(0.1)
            system('yum install -y %s' % pkg)

    else:
        cmd = """
            apt-get update -y
            apt-get upgrade -y
        """
        system(cmd)

        pkgs = ['gcc', 'g++', 'make', 'cmake', 'autoconf', 'automake', 're2c', 'wget', 'sendmail', 'chkconfig']
        pkgs.extend(['cron', 'bzip2', 'libzip-dev', 'libc6-dev', 'file', 'rcconf', 'flex', 'vim', 'nano', 'bison'])
        pkgs.extend(['m4', 'gawk', 'less', 'make', 'cpp', 'binutils', 'diffutils', 'unzip', 'tar', 'bzip2'])
        pkgs.extend(['libbz2-dev', 'libncurses5', 'libncurses5-dev', 'libtool', 'libevent-dev', 'libpcre3'])
        pkgs.extend(['libpcre3-dev', 'libpcrecpp0', 'libssl-dev', 'zlibc', 'openssl', 'libsasl2-dev', 'libxml2'])
        pkgs.extend(['libxml2-dev', 'libltdl3-dev', 'libltdl-dev', 'libmcrypt-dev', 'zlib1g', 'zlib1g-dev'])
        pkgs.extend(['libbz2-1.0', 'libbz2-dev', 'libglib2.0-0', 'libglib2.0-dev', 'libpng3', 'libfreetype6'])
        pkgs.extend(['libfreetype6-dev', 'libjpeg-dev', 'libpng-dev', 'libpng12-0', 'libpng12-dev', 'curl'])
        pkgs.extend(['libcurl3', 'libmhash2', 'libmhash-dev', 'libpq-dev', 'libpq5', 'gettext', 'libncurses5-dev'])
        pkgs.extend(['libjpeg-dev', 'libpng12-dev', 'libxml2-dev', 'zlib1g-dev', 'libfreetype6', 'libfreetype6-dev'])
        pkgs.extend(['libssl-dev', 'libcurl3', 'mcrypt', 'libcap-dev', 'sysv-rc-conf', 'libcurl4-openssl-dev'])
        pkgs.extend(['libreadline-dev', 'libtidy-dev', 'libmagick++-dev', 'sysvinit-utils', 'patch', 'axel'])
    
        for pkg in pkgs:
            print color('[*] Installing: %s' % pkg, GREEN)
            time.sleep(0.1)
            system('apt-get install -y %s' % pkg)

def get_mysql_url(mysql_ver):
    html = get_html('http://dev.mysql.com/downloads/mysql/%s.html?tpl=files&os=src&version=%s' % (mysql_ver, mysql_ver))
    if html != False:
        m = re.search('mysql-%s\.\d+\.tar\.gz' % mysql_ver, html)
        if m:
            url = 'http://cdn.mysql.com/Downloads/MySQL-%s/%s' % (mysql_ver, m.group())
        else:
            print 'Can\'t find MySQL download URL.'
    else:
        print 'Can\'t fetch MySQL website page.'
    if 'url' not in dir():
        url = mysql_bak_url
    return url


def get_apache_url(apache_ver):
    html = get_html('http://www.apache.org/dist/httpd/')
    if html != False:
        m = re.findall('<a href="(httpd-%s.\d+.tar.gz)">' % apache_ver, html)
        if m:
            url = 'http://www.apache.org/dist/httpd/' + m[0]
        else:
            print 'Can\'t find Apache download URL.'
    else:
        print 'Can\'t fetch Apache website page.'
    if 'url' not in dir():
        url = apache_bak_url
    return url

def get_nginx_url():
    html = get_html('http://nginx.org/en/download.html')
    if html != False:
        m = re.search('Stable version.*?/(download/nginx-[\d\.]+.tar.gz)', html)
        if m:
            url = 'http://nginx.org/' + m.group(1)
        else:
            print 'Can\'t find Nginx download URL.'
    else:
        print 'Can\'t fetch Nginx website page.'
    if 'url' not in dir():
        url = nginx_bak_url
    return url

def get_php_url(ver):
    if ver == '5.2':
        return php52_bak_url

    else:
        html = get_html('http://cn2.php.net/downloads')
        if html != False:
            m = re.search('<base href="http://(.*?\.php\.net)/downloads\.php">', html)
            if m:
                domain = m.group(1)

                m = re.search('php-%s\.\d+\.tar.gz' % ver, html)
                if m:
                    filename = m.group()
                    url = "http://%s/distributions/%s" % (domain, filename)
                else:
                    print 'Can\'t find PHP %s\'s download URL.' % ver
            else:
                print 'Can\'t find PHP %s\'s download site URL.' % ver

        if 'url' not in dir():
            if php_ver == '5.3':
                url = php53_bak_url
            elif php_ver == '5.4':
                url = php54_bak_url
            elif php_ver == '5.5':
                url = php55_bak_url

        return url

def install_mysql():

    download_file(mysql_file)
    download_file(get_mysql_url(mysql_ver))

    system('groupadd mysql')
    system('useradd -s /sbin/nologin -M -g mysql mysql')

    os.chdir(file_dir)
    os.chdir(get_dir('mysql-'))

    cmd = '''
            cmake . -LAH \
            -DCMAKE_INSTALL_PREFIX=/usr/local/mysql/           \
            -DMYSQL_DATADIR=/var/lib/mysql                     \
            -DMYSQL_UNIX_ADDR=/tmp/mysqld.sock                 \
            -DCURSES_INCLUDE_PATH=/usr/include                 \
            -DMYSQL_TCP_PORT=3306                              \
            -DEXTRA_CHARSETS=all                               \
            -DSYSCONFDIR=/etc/                                 \
            -DWITH_ZLIB=bundled                                \
            -DWITH_READLINE=TRUE                                
          '''
    run_cmd(cmd)

    run_cmd("make -j %s && make install" % cpu_num)
    run_cmd('ldconfig')

    force_copy('support-files/mysql.server', '/etc/init.d/mysqld')
    os.chmod('/etc/init.d/mysqld', 0755)

    run_cmd("/bin/bash scripts/mysql_install_db  --basedir=/usr/local/mysql --datadir=/var/lib/mysql --user=mysql")


    os.chdir(file_dir)
    force_copy('my-%s.cnf' % server_size, '/etc/my.cnf')
    os.chmod('/etc/my.cnf', 0755)

    run_cmd('/etc/init.d/mysqld start')

    system('ln -s /usr/local/mysql/bin/* /usr/bin/')

    run_cmd('/usr/local/mysql/bin/mysqladmin -u root password %s' % dbrootpwd)

    cmd = """
        mysql -u root -p%s -h localhost << QUERY_INPUT
        use mysql;
        delete from user where not (user='root') ;
        delete from user where user='root' and password=''; 
        drop database test;
        DROP USER ''@'%%';
        flush privileges;
        \nQUERY_INPUT
        """ % dbrootpwd
    system(cmd)
    
    run_cmd('/etc/init.d/mysqld stop')

def install_nginx():

    download_file(nginx_file)
    download_file(get_nginx_url())

    system('groupadd www')
    system('useradd -s /sbin/nologin -g www www')
    system('echo "www:%s" | chpasswd' % ftpwwwpwd)

    os.chdir(file_dir)
    os.chdir(get_dir('nginx-'))

    run_cmd("sed -i 's#Server: nginx#Server: Server110#' src/http/ngx_http_header_filter_module.c")
    run_cmd("sed -i 's#\"nginx/\"#\"Server110/\"#' src/core/nginx.h")
    run_cmd("sed -i 's#\"NGINX\"#\"Server110\"#' src/core/nginx.h")


    cmd = '''
            ./configure                            \
            --user=www                             \
            --group=www                            \
            --prefix=/usr/local/nginx              \
            --with-http_stub_status_module         \
            --with-http_ssl_module
          '''

    run_cmd(cmd)
    run_cmd("make -j %s && make install" % cpu_num)

    os.chdir(file_dir)
    force_copy('nginx.init', '/etc/init.d/nginx')
    os.chmod('/etc/init.d/nginx', 0755)

    system('mkdir -p /usr/local/nginx/conf/vhost/')
    system('mkdir -p /usr/local/nginx/conf/extra/')
    system('mkdir -p /home/www/logs/')
    system('mkdir -p /home/www/default/')
    system('chown -R www:www /home/www/')
    force_copy('proxy.conf', '/usr/local/nginx/conf/proxy.conf')
    force_copy('proxy2.conf', '/usr/local/nginx/conf/proxy2.conf')
    force_copy('nginx_proxy.conf', '/usr/local/nginx/conf/nginx.conf')

    # 128M以下内存只使用1个工作进程
    if server_size == 'mini':
        run_cmd("sed -i 's#worker_processes 2;#worker_processes 1;#' /usr/local/nginx/conf/nginx.conf")

def install_apache():

    download_file(get_apache_url(apache_ver))
    download_file(apache_file)

    os.chdir(file_dir)
    os.chdir(get_dir('httpd-%s' % apache_ver))

    cmd = '''
            ./configure                 \
            --prefix=/usr/local/httpd/  \
            --enable-headers            \
            --enable-mime-magic         \
            --enable-proxy              \
            --enable-so                 \
            --enable-rewrite            \
            --enable-ssl                \
            --enable-deflate            \
            --enable-suexec             \
            --disable-userdir           \
            --with-included-apr         \
            --with-mpm=prefork          \
            --with-ssl=/usr             \
            --disable-userdir           \
            --disable-cgid              \
            --disable-cgi               \
            --with-expat=builtin    
          '''
    run_cmd(cmd)

    run_cmd("make -j %s && make install" % cpu_num)

    os.chdir(file_dir)
    force_copy('httpd.init', '/etc/init.d/httpd')
    os.chmod('/etc/init.d/httpd', 0755)

    os.chdir(file_dir)
    force_copy('httpd-mpm-%s.conf' % server_size, '/usr/local/httpd/conf/extra/httpd-mpm.conf')
    force_copy('httpd.conf', '/usr/local/httpd/conf/httpd.conf')
    force_copy('httpd-default.conf', '/usr/local/httpd/conf/extra/httpd-default.conf')
    force_copy('httpd-vhosts.conf', '/usr/local/httpd/conf/extra/httpd-vhosts.conf')
    force_copy('httpd-rpaf.conf', '/usr/local/httpd/conf/extra/httpd-rpaf.conf')

    if not os.path.isdir('/usr/local/httpd/conf/vhost'):
        os.mkdir('/usr/local/httpd/conf/vhost')

    os.chdir(get_dir('mod_rpaf-'))
    run_cmd("/usr/local/httpd/bin/apxs -i -c -n mod_rpaf-2.0.so mod_rpaf-2.0.c")

def install_php():

    # 安装libmcrypt
    download_file(libmcrypt_file)
    os.chdir(file_dir)
    os.chdir(get_dir('libmcrypt-'))
    run_cmd("./configure --exec-prefix=/usr")
    run_cmd("make -j %s && make install" % cpu_num)

    os.chdir('libltdl')
    run_cmd("./configure --enable-ltdl-install")
    run_cmd("make -j %s && make install" % cpu_num)

    # CentOS 6.x 安装mhash
    if os_dist == 'centos' and os_ver == '6':
        download_file(mhash_file)
        os.chdir(file_dir)
        os.chdir(get_dir('mhash-'))
        run_cmd("./configure")
        run_cmd("make -j %s && make install" % cpu_num)

    # debian 7系统和ubuntu 10之后的系统libjpeg, libpng路径不对
    if os_dist == 'debian' and os_ver == '7' or os_dist == 'Ubuntu' and os_ver != '10':
        if arch == '32bit':
            force_copy('/usr/lib/i386-linux-gnu/libpng.so', '/usr/lib/libpng.so')
            force_copy('/usr/lib/i386-linux-gnu/libjpeg.so', '/usr/lib/libjpeg.so')
        else:
            force_copy('/usr/lib/x86_64-linux-gnu/libpng.so', '/usr/lib/libpng.so')
            force_copy('/usr/lib/x86_64-linux-gnu/libjpeg.so', '/usr/lib/libjpeg.so')

    # 个别发行版这两个包只装到了/usr/lib64/但PHP5.2不在这个目录找
    if php_ver == '5.2':
        if not os.path.exists('/usr/lib/libpng.so'):
            lib_path = glob('/usr/lib*/libpng*.so*')
            if lib_path:
                force_copy(lib_path[0], '/usr/lib/libpng.so')

        if not os.path.exists('/usr/lib/libjpeg.so'):
            lib_path = glob('/usr/lib*/libjpeg*.so*')
            if lib_path:
                force_copy(lib_path[0], '/usr/lib/libjpeg.so')

    run_cmd("ldconfig")

    download_file(get_php_url(php_ver))

    # PHP 5.2.x版本防止Hash冲突拒绝服务攻击的补丁
    if php_ver == '5.2':
        os.chdir(file_dir)
        download_file(php_max_input_vars_patch)
        run_cmd("patch -d %s -p1 < %s" % (get_dir('php-%s' % php_ver), php_max_input_vars_patch))

        download_file(php_debian_sslv2_patch)
        run_cmd("patch -d %s/ext/openssl/ -p3 < %s" % (get_dir('php-%s' % php_ver), php_debian_sslv2_patch))
    
        # Ubuntu 13系统中安装PHP5.2会出现'make: *** [ext/dom/node.lo] Error 1'的错误
        if os_dist == 'Ubuntu' and os_ver == '13':
            download_file(php_dom_patch)
            run_cmd("patch -d %s -p0 < %s" % (get_dir('php-%s' % php_ver), php_dom_patch))

    os.chdir(file_dir)
    os.chdir(get_dir('php-%s' % php_ver))

    os.environ['EXTENSION_DIR'] = '/usr/local/php/extensions'
    cmd = '''
            ./configure \
            --prefix=/usr/local/php/                        \
            --with-config-file-path=/etc/                   \
            --sysconfdir=/etc/                              \
            --with-apxs2=/usr/local/httpd/bin/apxs          \
            --with-mysql=/usr/local/mysql/                  \
            --with-mysqli=/usr/local/mysql/bin/mysql_config \
            --with-pdo-mysql=/usr/local/mysql               \
            --with-iconv-dir                                \
            --with-freetype-dir                             \
            --with-jpeg-dir                                 \
            --with-png-dir                                  \
            --with-zlib                                     \
            --with-libxml-dir=/usr/                         \
            --enable-xml                                    \
            --disable-rpath                                 \
            --enable-discard-path                           \
            --enable-magic-quotes                           \
            --enable-bcmath                                 \
            --enable-shmop                                  \
            --enable-sysvsem                                \
            --enable-inline-optimization                    \
            --with-curl                                     \
            --with-curlwrappers                             \
            --enable-mbregex                                \
            --enable-mbstring                               \
            --with-mcrypt                                   \
            --enable-ftp                                    \
            --with-gd                                       \
            --enable-gd-native-ttf                          \
            --with-openssl                                  \
            --with-mhash                                    \
            --enable-pcntl                                  \
            --enable-sockets                                \
            --with-xmlrpc                                   \
            --enable-zip                                    \
            --enable-soap                                   \
            --without-pear                                  \
            --with-gettext                                  \
            --with-tidy                                     \
            --with-mime-magic                               \
            --with-bz2                                      \
            --enable-exif                                   \
            --with-readline                                 \
          '''

    # 为PHP5.5版本启用Opcache
    if php_ver == '5.5' and php_module == 'o':
        cmd += ' --enable-opcache '

    # 小内存无法编译fileinfo，并且5.2不支持这个选项
    if php_ver != '5.2':
        # 500M内存以上
        if mem > 500:
            cmd += ' --enable-fileinfo '
        else:
            cmd += ' --disable-fileinfo '

    run_cmd(cmd)
    run_cmd("make -j %s && make install" % cpu_num)

    system('ln -s /usr/local/php/bin/* /usr/bin/')

    # 拷贝php.ini
    if php_ver == '5.2':
        force_copy('php.ini-recommended', '/etc/php.ini')
    else:
        force_copy('php.ini-production', '/etc/php.ini')

    # 补充Opcache的php.ini内容
    if php_ver == '5.5' and php_module == 'o':
        file_append('/etc/php.ini', php_ini_opcache)

    system('sed -i "s#disable_functions =#disable_functions = pcntl_alarm,pcntl_fork,pcntl_waitpid,pcntl_wait,pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,pcntl_getpriority,pcntl_setpriority,eval,popen,passthru,exec,system,shell_exec,proc_open,proc_get_status,chroot,chgrp,chown,,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru#g" /etc/php.ini')
    system('sed -i "s#;date.timezone =#date.timezone = Asia/Shanghai#" /etc/php.ini')
    system('sed -i "s#short_open_tag = Off#short_open_tag = On#" /etc/php.ini')
    system('sed -i "s#;cgi.fix_pathinfo=1#cgi.fix_pathinfo=0#g" /etc/php.ini')
    system('sed -i "s#;cgi.fix_pathinfo=0#cgi.fix_pathinfo=0#g" /etc/php.ini')
    system('sed -i "s#upload_max_filesize = 2M#upload_max_filesize = 64M#g" /etc/php.ini')
    system('sed -i "s#post_max_size = 8M#post_max_size = 64M#g" /etc/php.ini')
    system('sed -i "s#session.gc_maxlifetime = 1440#session.gc_maxlifetime = 604800#g" /etc/php.ini')
    system('sed -i "s#;sendmail_path =#sendmail_path = /usr/sbin/sendmail -t -i#g" /etc/php.ini')
    # for 5.3+
    system('sed -i \'s#; extension_dir = "./"#extension_dir = "/usr/local/php/extensions"#\' /etc/php.ini')
    # for 5.2
    system('sed -i \'s#extension_dir = "./"#extension_dir = "/usr/local/php/extensions"#\' /etc/php.ini')

    # 非5.5版本安装opcache过程存档
    '''
    download_file(opcache_file)
    os.chdir(file_dir)
    os.chdir(get_dir('zendopcache-'))
    run_cmd('/usr/bin/phpize')
    run_cmd('./configure --with-php-config=/usr/bin/php-config')
    run_cmd("make -j %s && make install" % cpu_num)
    file_append('/etc/php.ini', php_ini_opcache)
    '''

    # 安装xcache(只有PHP5.5并且安装opcache时不安装)
    if not (php_ver == '5.5' and php_module == 'o'):
        download_file(xcache_file)
        os.chdir(file_dir)
        os.chdir(get_dir('xcache-'))
        run_cmd('/usr/bin/phpize')
        run_cmd('./configure --enable-xcache --with-php-config=/usr/bin/php-config')
        run_cmd("make clean ; make -j %s && make install" % cpu_num)
        file_append('/etc/php.ini', php_ini_xcache)
    
    # 除5.5版本外，全部安装Zend
    if php_ver in ('5.2', '5.3', '5.4'):
        system('rm -rf %s/Zend*' % file_dir)

        # 下载zend文件
        if php_ver == '5.2' and zend_ver == '3.3.3':
            download_file(zend_file_333[arch])
        else:
            download_file(zend_file[arch][php_ver])

        os.chdir(file_dir)
        os.chdir(get_dir('Zend'))

        if php_ver == '5.2':
            os.chdir(get_dir('data'))
            os.chdir(get_dir('5_2'))
            force_copy('ZendOptimizer.so', '/usr/local/php/extensions/ZendOptimizer.so')
            file_append('/etc/php.ini', php_ini_zend52)

        else:
            os.chdir(get_dir('php'))
            force_copy('ZendGuardLoader.so', '/usr/local/php/extensions/ZendGuardLoader.so')
            file_append('/etc/php.ini', php_ini_zend53)

    # 安装memcache驱动
    download_file(memcache_file)
    os.chdir(file_dir)
    os.chdir(get_dir('memcache-'))
    run_cmd('/usr/bin/phpize')
    run_cmd('./configure --with-php-config=/usr/bin/php-config')
    run_cmd("make clean ; make -j %s && make install" % cpu_num)
    file_append('/etc/php.ini', php_ini_memcache)


    # 安装imagick
    download_file(imagick_file)
    os.chdir(file_dir)
    os.chdir(get_dir('imagick-'))
    run_cmd('/usr/bin/phpize')
    run_cmd('./configure --with-php-config=/usr/bin/php-config  --with-imagick=/usr/local/imagick')
    run_cmd("make clean ; make -j %s && make install" % cpu_num)
    file_append('/etc/php.ini', php_ini_imagick)

def install_pma():
    download_file(pma_file)

    os.chdir(file_dir)
    os.chdir(get_dir('phpMyAdmin-'))
    run_cmd('rm -rf setup')
    run_cmd("sed -i 's#?>##' libraries/config.default.php")
    file_append('libraries/config.default.php', "$cfg['blowfish_secret'] = '%s';" % pmasecret)
    file_append('libraries/config.default.php', "$cfg['VersionCheck'] = FALSE;")
    file_append('libraries/config.default.php', "$cfg['LoginCookieValidity'] = 60*60*24*7;")
    file_append('libraries/config.default.php', "$cfg['Servers'][$i]['hide_db'] = 'information_schema|mysql|performance_schema';")
    file_append('libraries/config.default.php', "$cfg['MaxTableList'] = 300;")
    os.chdir('lang')
    run_cmd('rm -rf `ls | egrep -v english | egrep -v chinese_simplified`')

    os.chdir(file_dir)
    system('mkdir -p /usr/local/app/phpMyAdmin')
    system('cp -r phpMyAdmin-*-all-languages/* /usr/local/app/phpMyAdmin')
    system('chown -R www:www /usr/local/app/phpMyAdmin')

    os.chdir(file_dir)
    force_copy('pma_apache.conf', '/usr/local/httpd/conf/extra/httpd-pma.conf')
    file_append('/usr/local/httpd/conf/httpd.conf', 'Include conf/extra/httpd-pma.conf')
    force_copy('pma_nginx.conf', '/usr/local/nginx/conf/extra/phpMyAdmin.conf')

def install_memcached():

    download_file(memcached_file)

    os.chdir(file_dir)
    os.chdir(get_dir('memcached-'))

    run_cmd('./configure --prefix=/usr/local/memcached')
    run_cmd("make -j %s && make install" % cpu_num)

    os.chdir(file_dir)
    force_copy('memcached.init', '/etc/init.d/memcached')
    os.chmod('/etc/init.d/memcached', 0755)

def debian_service():
    if os_dist in ('debian', 'Ubuntu'):
        os.chdir(file_dir)
        if not os.path.exists('/var/lock/subsys/'):
            os.mkdir('/var/lock/subsys/')

        # FUCK TMD DASH！
        os.remove('/bin/sh')
        os.symlink('/bin/bash', '/bin/sh')

        download_file(debian_functions)
        force_copy('functions.init', '/etc/init.d/functions')
        os.chmod('/etc/init.d/functions', 0755)
    
        system("sed -i 's#!/bin/sh#!/bin/bash#' /etc/init.d/proftpd")
        system("sed -i 's#/etc/rc.d/init.d/functions#/etc/init.d/functions#' /etc/init.d/proftpd")
        system("sed -i 's#. /etc/sysconfig/network##' /etc/init.d/proftpd")
        system("sed -i 's#\[ ${NETWORKING} = \"no\" \] && exit 1##' /etc/init.d/proftpd")

    # fix bug
    if os_dist == 'Ubuntu':
        system('ln -s /usr/lib/insserv/insserv /sbin/insserv')

def install_site():
    os.chdir(file_dir)
    download_file(site_file)
    force_copy('site.py', '/sbin/site')
    os.chmod('/sbin/site', 0700)

def start_service():
    for service in ('mysqld', 'nginx', 'httpd', 'memcached', 'proftpd'):


        if os_dist in('redhat', 'centos'):
            run_cmd('chkconfig --add %s' % service)
            run_cmd('chkconfig %s on' % service)
        else:
            run_cmd('update-rc.d -f %s defaults' % service)
            run_cmd('update-rc.d %s enable' % service)
        
        run_cmd('/etc/init.d/%s start' % service)


def out_put():
    file_put_contents('/home/www/default/index.php', '<?php phpinfo();')


    external_ip = get_html('http://ip.server110.com')

    ip_list = []
    var = os.popen('ifconfig').read().split("\n\n")
    for item in var:
        #print item
        symble1 = "inet addr:"
        pos1 = item.find(symble1)
        if pos1 >= 0:
            tmp1 = item[pos1+len(symble1):]
            ip_list.append(tmp1[:tmp1.find(" ")])
   
    if external_ip in ip_list:
        ip = external_ip
    else:
        ip = ip_list[0]

    text = op_info.substitute(dbrootpwd=dbrootpwd, ip=ip, ftpwwwpwd=ftpwwwpwd)

    file_append('/root/setup.txt', text)
    
    run_cmd('clear')
    print text
    
def install_proftpd():
    download_file(proftpd_file)

    system('groupadd proftpd')
    system('useradd -s /sbin/nologin -M -g proftpd proftpd')

    os.chdir(file_dir)
    os.chdir(get_dir('proftpd-'))

    run_cmd("./configure --prefix=/usr/local/proftpd --sysconfdir=/etc")
    run_cmd("make -j %s && make install" % cpu_num)

    file_put_contents('/etc/proftpd.conf', proftpd_conf)
    
    os.chdir(file_dir)
    force_copy('proftpd.init', '/etc/init.d/proftpd')
    os.chmod('/etc/init.d/proftpd', 0755)

if __name__ == '__main__':

    # 检查执行用户，必须在root权限下运行
    if os.getuid() != 0:
        print "\nThis script must be run as root.\nQuit!\n"
        sys.exit()

    # 发行版
    os_dist = platform.dist()[0]
    os_ver = platform.dist()[1].split('.')[0]

    # 仅支持RedHat, CentOS, Debian, Ubuntu
    if os_dist not in ('centos', 'redhat', 'debian', 'Ubuntu'):
        print "\nThis script only support RedHat, CentOS, Debian, Ubuntu.\nexit!\n"
        sys.exit()

    # 生成随机密码
    dbrootpwd = gen_password(8)
    ftpwwwpwd = gen_password(8)
    pmasecret = gen_password(8)

    # 内存容量
    mem = get_mem()

    # CPU核心数量，多进程编译
    cpu_num = os.sysconf('SC_NPROCESSORS_ONLN')

    # 防止内存不够用，使用单进程编译
    if mem < 200:
        cpu_num = 1

    # 架构
    arch = platform.architecture()[0]

    # 硬件参数等级
    if mem <= 130:
        server_size = 'mini'
    elif mem >= 131 and mem <= 520:
        server_size = 'small'
    elif mem >= 521 and mem <= 1030:
        server_size = 'medium'
    elif mem >= 1031 and mem <= 2050:
        server_size = 'big'
    elif mem >= 2051 and mem <= 6150:
        server_size = 'large'
    elif mem >= 6151 and mem <= 12290:
        server_size = 'huge'
    elif mem >= 12291:
        server_size = 'monster'

    # 处理命令行参数

    parser = OptionParser()  
    parser.add_option("-p", "--php", dest="php_ver", action="store",
                      help="specify which php version to install", metavar="VERSION")  
    parser.add_option("-z", "--zend", dest="zend_ver", action="store",
                      help="the version of zend to install(only for php5.2)", metavar="VERSION")  
    parser.add_option("-o", action='store_true', dest='opcache',
                      help="install opcache(only for php5.5)")  
    parser.add_option("-x", action='store_true', dest='xcache',
                      help="install xcache(only for php5.5)")  
    parser.add_option("-s", "--size", dest="arg_size", action="store",
                      help="specify server size", metavar="SIZE")  

    (options, args) = parser.parse_args()  

    if options.php_ver in (None, '5.2'):
        php_ver = '5.2'
        if options.zend_ver:
            if options.zend_ver in ('3.3.3', '3.3.9'):
                zend_ver = options.zend_ver
            else:
                print "Argument Error!\nOnly ZendOptimizer 3.3.3 And ZendOptimizer 3.3.9 Are Available For PHP 5.2."
                sys.exit()
        else:
            zend_ver = '3.3.9'

    elif options.php_ver in ('5.3', '5.4'):
        php_ver = options.php_ver

    elif options.php_ver == '5.5':
        php_ver = options.php_ver
        if options.opcache:
            php_module = 'o'
        else:
            php_module = 'x'
    else:
        print "Wrong PHP Version!"
        sys.exit()

    # 如果参数指定server size
    if options.arg_size in ( 'mini', 'small', 'medium', 'big', 'large', 'huge', 'monster'):
        server_size = options.arg_size

    '''
    if 'php_ver' in dir():
        print 'php_ver: %s' % php_ver
    if 'zend_ver' in dir():
        print 'zend_ver: %s' % zend_ver
    if 'php_module' in dir():
        print 'php_module: %s' % php_module
    '''

    # 禁用SELinux
    disable_selinux()

    # 处理动态共享库路径
    add_ld_path()

    # 处理hosts文件，防止影响sendmail启动速度
    add_hosts()

    # 系统优化
    sys_op()

    # 检查并卸载已安装的服务
    uninstall()

    # 安装依赖包
    install_dependence()

    # 安装axel
    install_axel()

    # 安装 MySQL
    install_mysql()

    # 安装 Nginx
    install_nginx()

    # 安装 Apache
    install_apache()

    # 安装 PHP
    install_php()

    # 安装phpMyAdmin
    install_pma()

    # 安装 Memcached
    install_memcached()

    # 安装proftpd
    install_proftpd()
    
    # debian/Ubuntu系统下一些service相关脚本要做处理
    debian_service()

    # 安装site命令
    install_site()

    # 启动服务
    start_service()

    # 输出信息
    out_put()

    # 删除下载的文件
    system('rm -rf %s' % file_dir)