脚本说明：

第一、支持的系统

CentOS  (在CentOS6.3 x86_64上测试)
RedHat  (未测试)
Ubuntu  (在Ubuntu12.04 上测试)
Debian  (未测试)

第二、支持的网站程序

1、Apache (httpd)
2、Nginx  
3、Tomcat

第三、脚本入口

执行 ： WebSite-Info/ROOT.sh

第四、脚本执行流程

1、手动执行"ROOT.sh"：切换到root角色

2、Main.sh脚本		：根据系统的不同进入不同的目录（CentOS、Ubuntu），并检查当前系统的web网站程序的类型及安装方式，以选则执行不同的脚本

	
第五、结果生成目录
/root/

第六、生成结果文件

conf.list    		--配置文件中的有效内容，变简单的排版
Include.list 		--配置文件中包含的路径（相对、绝对、文件、目录）
absolute.list		--Include包含的相对路径转换成绝对路径（文件、目录）
Include_file.list	--Include包含的所有的文件（绝对路径）
vhost.list		--vhost的域名以及网站目录（此时的网站目录格式不严谨）
Domain.list		--vhost的域名以及网站目录（此时的网站目录为绝对路径，且格式严谨）
Summary.list		--多种网站程序（apache、nginx、tomcat）包含的vhost的汇总




第七、执行过程中会自动切换到root账号

需要输入账号密码


第八、不足

Nginx类型：要求Include包含的vhost文件，每个文件只能存放一个vhost；
