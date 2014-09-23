<?php
class AMWebsite extends AmysqlController
{
	public $indexs = null;
	public $hosts = null;
	public $AccountTemplets = null;
	public $notice = null;
	public $dirs = array();

	// Model
	function AmysqlModelBase()
	{
		if($this -> indexs) return;
		$this -> _class('Functions');
		$this -> indexs = $this ->  _model('indexs');
		$this -> hosts = $this ->  _model('hosts');
		$this -> AccountTemplets = $this ->  _model('AccountTemplets');
	}

	
	function GetDirs($dir = NULL)
	{
		if(empty($dir)) exit;
		$this -> dirs[] = $dir;
		$dirs_data = scandir($dir);
		foreach ($dirs_data as $key=>$val)
		{
			$small_dir = "{$dir}/{$val}";
			if (!in_array($val, array('.', '..')) && is_dir($small_dir))
				$this -> GetDirs($small_dir);
		}
	}


	function IndexAction()
	{
		$this -> title = 'AMH - AMWebsite';	// 面板模板标题
		$this -> AmysqlModelBase();
		Functions::CheckLogin();			// 面板登录检查函数
	
		$host_domain = isset($_GET['host_domain']) ? $_GET['host_domain'] : (isset($_POST['host_domain']) ? $_POST['host_domain'] : '');
		$product_name = isset($_GET['product_name']) ? $_GET['product_name'] : (isset($_POST['product_name']) ? $_POST['product_name'] : '');

		$host_list = $this -> hosts -> host_list();
		$product_list = array(
			array(
				'product_id' => '1', 
				'product_sort' => '论坛', 
				'product_name' => 'Discuz-3.0.8.2', 
				'product_description' => 'Crossday Discuz! Board（简称 Discuz!）是北京康盛新创科技有限责任公司推出的一套通用的社区论坛软件系统。自2001年6月面世以来，Discuz!已拥有11年以上的应用历史和200多万网站用户案例，是全球成熟度最高、覆盖率最大的论坛软件系统之一。', 
				'product_website' => 'http://www.comsenz.com', 
				'logo' => 'View/images/AMWebsite/discuz.gif',
			),
			array(
				'product_id' => '2', 
				'product_sort' => '论坛', 
				'product_name' => 'phpwind-9.0.7.2', 
				'product_description' => 'phpwind（简称 PW）是一个基于PHP和MySQL的开源社区程序，是国内最受欢迎的通用型论坛程序之一。phpwind第一个版本ofstar发布于2004年。目前phpwind项目品牌由阿里云计算有限公司拥有，软件全面开源免费。现已有累积超过100万的网站采用phpwind产品，其中活跃网站近10万。自2011年发布PHPWind8.x系列版本以来，phpwind围绕着提升社区内容价值和推进社区电子商务两个大方向，开发单核心多模式的产品，实现新型的社区形态。', 
				'product_website' => 'http://www.phpwind.com',
				'logo' => 'View/images/AMWebsite/phpwind.gif',
				'base_module' => 'PDO_MYSQL-1.0.2',
			),
			array(
				'product_id' => '3', 
				'product_sort' => '问答', 
				'product_name' => 'WeCenter-2.1', 
				'product_description' => 'Wecenter（微中心系统软件）是一款由深圳市微客互动有限公司开发的具有完全自主知识产权的开源软件，是一个类似知乎以问答为基础的完全开源的社交网络建站程序，基于 PHP + MYSQL 应用架构，它集合了问答，digg，wiki 等多个程序的优点，帮助用户轻松搭建专业的知识库和在线问答社区。', 
				'product_website' => 'http://www.wecenter.com/',
				'logo' => 'View/images/AMWebsite/wecenter.jpg',
				'base_module' => 'PDO_MYSQL-1.0.2',
				'partner' => true,
			),
			array(
				'product_id' => '4', 
				'product_sort' => '博客', 
				'product_name' => 'WordPress-3.6', 
				'product_description' => 'WordPress是一种使用PHP语言开发的博客平台，同时也可以把 WordPress 当作一个内容管理系统（CMS）来使用，WordPress起初是一款个人博客系统，并逐步演化成一款内容管理系统软件。WordPress功能比较强大，插件众多，易于扩充功能。安装使用都非常方便。', 
				'product_website' => 'http://cn.wordpress.org/',
				'logo' => 'View/images/AMWebsite/wp.jpg',
			),
			array(
				'product_id' => '5', 
				'product_sort' => '博客', 
				'product_name' => 'Typecho-0.8', 
				'product_description' => 'Typecho是一个简单，轻巧的博客程序。基于PHP，使用多种数据库(Mysql,PostgreSQL,SQLite)储存数据。在GPL Version 2许可证下发行，是一个开源的程序，目前使用SVN来做版本管理。', 
				'product_website' => 'http://www.typecho.org/',
				'logo' => 'View/images/AMWebsite/typecho.gif',
				'base_module' => 'AMPathinfo-1.0',
			),
			array(
				'product_id' => '6', 
				'product_sort' => '商城', 
				'product_name' => 'ECShop-2.7.3.7.8', 
				'product_description' => 'ECShop是上海商派网络科技有限公司（ShopEx）旗下——B2C独立网店系统，适合企业及个人快速构建个性化网上商店。系统是基于PHP语言及MYSQL数据库构架开发的跨平台开源程序。(此安装版本为AMH改进版，改进官方源码包存在的多次错误。20130531)', 
				'product_website' => 'http://www.ecshop.com/',
				'logo' => 'View/images/AMWebsite/ecshop.gif',
			),
			array(
				'product_id' => '7', 
				'product_sort' => '博客', 
				'product_name' => 'emlog-5.1.2', 
				'product_description' => 'emlog 是 every memory log 的简称，意即：点滴记忆。是一款基于PHP和MySQL的功能强大的博客及CMS建站系统。致力于为您提供快速、稳定，且在使用上又极其简单、舒适的内容创作及站点搭建服务。', 
				'product_website' => 'http://www.emlog.net/',
				'logo' => 'View/images/AMWebsite/emlog.gif',
				'CloseAuto' => true
			),
			array(
				'product_id' => '8', 
				'product_sort' => 'CMS', 
				'product_name' => 'EmpireCMS-7.0', 
				'product_description' => '《帝国网站管理系统》英文译为"Empire CMS"，简称"Ecms"，它是基于B/S结构，且功能强大而帝国CMS-logo易用的网站管理系统。本系统由帝国开发工作组独立开发，是一个经过完善设计的适用于Linux/windows引/Unix等环境下高效的网站解决方案。', 
				'product_website' => 'http://www.phome.net/',
				'logo' => 'View/images/AMWebsite/EmpireCMS.gif',
			)
		);
		$account_list = $this -> AccountTemplets -> get_account_list();


		// 选择程序安装目录位置与安装模式
		if (!empty($host_domain) && !empty($product_name))
		{
			$host_root = null;
			foreach ($host_list as $key=>$val)
			{
				if($val['host_domain'] == $host_domain)
				{
					$host_root = $val['host_root'];
					break;
				}
			}
			if (!empty($host_root))
			{
				$this -> GetDirs($host_root);
			}
		}

		// 安装
		if (isset($_POST['submit_install_y']))
		{
			$cn_txt = array('manual' => '手动', 'automatic' => '自动');
			$cmd = "amh module AMWebsite-2.0 admin install,{$_POST['host_domain']},{$this->dirs[$_POST['dir_id']]},{$_POST['install_model']},{$_POST['product_name']},{$_POST['account_list']}";
			$cmd = Functions::trim_cmd($cmd);
			exec($cmd, $tmp, $status);
			if(!$status)
			{
				$this -> status = 'success';
				$this -> notice = "{$_POST['host_domain']}域名：一键{$cn_txt[$_POST['install_model']]}安装{$_POST['product_name']}成功。({$this->dirs[$_POST['dir_id']]})";
				if ($_POST['install_model'] == 'automatic')
				{
					// 自动安装完成后管理员相关资料
					include("{$this->dirs[$_POST['dir_id']]}/AMWebsite_DB.php");
					$this -> install_db_info = array('DBName' => $AMWebsite_DBName, 'DBUser' => $AMWebsite_DBUser, 'DBPass' => $AMWebsite_DBPass,
							'AdminUser' => $AMWebsite_AdminUser, 'AdminPass' => $AMWebsite_AdminPass, 'AdminEmail' => $AMWebsite_AdminEmail
					);
				}
			}
			else
			{
			    $this -> status = 'error';
				$this -> notice = "{$_POST['host_domain']}域名：一键{$cn_txt[$_POST['install_model']]}安装{$_POST['product_name']}失败。({$this->dirs[$_POST['dir_id']]})";
			}
			$this -> host_root = $this->dirs[$_POST['dir_id']];
			unset($this->dirs);
		}
		
		$this -> indexs -> log_insert($this -> notice);
		$this -> host_list = $host_list;
		$this -> product_list = $product_list;
		$this -> account_list = $account_list;
		$this -> _view('AMWebsite');	// 加载模板文件
	}


	// 账号模块
	function account_templet()
	{
		$this -> title = 'AMH - AMWebsite - 账号模板';	// 面板模板标题
		$this -> AmysqlModelBase();
		Functions::CheckLogin();						// 面板登录检查函数

		// 删除
		if (isset($_GET['del']))
		{
			$id = (int)$_GET['del'];
			if($this -> AccountTemplets -> del_account($id))
			{
				$this -> status = 'success';
				$this -> notice = "AMWebsite:删除账号模板({$id})成功。";
			}
			else
			{
			    $this -> status = 'error';
				$this -> notice = "AMWebsite:删除账号模板({$id})失败。";
			}
		}

		// 编辑
		if (isset($_GET['user_id']))
		{
			$user_id = (int)$_GET['user_id'];
			$_POST = $this -> AccountTemplets -> get_account_list($user_id);
		}
		// 保存编辑
		if (isset($_POST['save']))
		{
			if($this -> AccountTemplets -> save_account($_POST))
			{
				$this -> status = 'success';
				$this -> notice = "AMWebsite:保存账号模板({$_POST['user_id']})成功。";
				$_POST = null;
			}
			else
			{
			    $this -> status = 'error';
				$this -> notice = "AMWebsite:保存账号模板({$_POST['user_id']})失败。";
			}
		}
		// 新增
		if (isset($_POST['add']))
		{
			if($this -> AccountTemplets -> add_account($_POST))
			{
				$this -> status = 'success';
				$this -> notice = "AMWebsite:新增账号模板({$_POST['user_id']})成功。";
				$_POST = null;
			}
			else
			{
			    $this -> status = 'error';
				$this -> notice = "AMWebsite:新增账号模板({$_POST['user_id']})失败。";
			}
		}


		$this -> indexs -> log_insert($this -> notice);
		$this -> account_list = $this -> AccountTemplets -> get_account_list();
		$this -> _view('AMWebsite_account_templet');	// 加载模板文件
	}


}
?>
