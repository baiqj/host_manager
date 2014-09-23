<?php include('header.php'); ?>	<!-- 载入面板头部文件 -->
<style>
.li {
	font-size:16px;
	font-weight:bold;
	color:rgb(168, 168, 168);
	font-style:italic;
}
#STable td.product_description {
	line-height:21px;
	text-align:left;
	padding-left:10px;
	padding-bottom:15px;
}
#STable img{
	opacity: 0.8;
	filter: alpha(opacity=80);
	margin-bottom:5px;
}
#admin_info {
	border: 1px solid #D1F1BA;
	background:#F9FFF4;
	margin:15px 0px;
	padding: 15px;
	width: 500px;
	color: rgb(105, 129, 123);
	line-height: 19px;
}
</style>
<script>
var dir_id, product_name, install, submit_install, radio_value, radio_click, account_list, account_list_div;
window.onload = function ()
{
	dir_id = G('dir_id');				// 安装目录ID
	product_name = G('product_name');	// 产品名称
	install = G('install');				// 安装按钮

	account_list = G('account_list');			// 账号模板列表
	account_list_div = G('account_list_div');	// 账号模板DIV

	// 提交安装
	submit_install = function ()
	{
		// 自动安装需要选择账号模板
		if (radio_value == 'automatic' && account_list.value == '')
		{
			alert('您使用自动安装模式，请选择使用管理员账号模板。');
			account_list.focus();
			return false;
		}

		if(confirm('确定清空目录：' + dir_id.options[dir_id.options.selectedIndex].text + '，一键安装' + product_name.value + '程序吗?'))
		{
			install.innerHTML = '安装中…';
			install.disabled = true;
			return true;
		}
		return false;
	}

	// 安装模式单选框
	radio_click = function (obj)
	{
		account_list_div.style.display = (obj.value == 'manual') ? 'none' : 'inline';
		radio_value = obj.value;
	}
	if(G('install_model_manual')) radio_click(G('install_model_manual'));
}

if(!WindowLocation)
{
	var WindowLocation = function (url)
	{
		window.location = url;
	}
	var WindowOpen = function (url)
	{
		window.open(url);
	}
}
</script>
<div id="body">
	<h2>AMH » AMWebsite</h2>

<div id="category">
<a href="index.php?c=AMWebsite" id="index" >一键建站</a>
<a href="index.php?c=AMWebsite&a=account_templet" id="account_templet">账号模板</a>
<script>
var action = '<?php echo $_GET['a'];?>';
var action_dom = G(action) ? G(action) : G('index');
action_dom.className = 'activ';
</script>
</div>

<?php
	if (!empty($notice)) echo '<div style="margin:5px 2px;width:500px;"><p style="display:inline-block" id="' . $status . '">' . $notice . '</p></div>';
?>
<p><font class="li">01,</font> 选择虚拟主机一键建站:</p>
<div id="AMWebsite_list">
<table border="0" cellspacing="1"  id="STable" style="width:auto;">
	<tr>
	<th width="18">ID</th>
	<th>主标识域名</th>
	<th>绑定域名</th>
	<th>网站根目录</th>
	<th width="120">选择</th>
	</tr>
	<?php 
	if(!is_array($host_list) || count($host_list) < 1)
	{
	?>
		<tr><td colspan="5" style="padding:10px;">暂无虚拟主机。</td></tr>
	<?php	
	}
	else
	{
		foreach ($host_list as $key=>$val)
		{
	?>
			<tr>
			<th class="i"><?php echo $val['host_id'];?></th>
			<td style="padding:10px"><?php echo $val['host_domain'];?></td>
			<td style="padding:10px">
			<?php  
				$server_name_arr = explode(',', $val['host_server_name']);
				foreach ($server_name_arr as $v)
				{?>
					<a href="http://<?php echo $v;?>" target="_blank"><?php echo $v;?></a><br />
			<?php		
				}
			?></td>
			<td style="padding:10px"><?php echo $val['host_root'];?></td>
			<td><button type="button" class="primary button" onclick="WindowLocation('./index.php?c=AMWebsite&host_domain=<?php echo $val['host_domain'];?>')" <?php echo (isset($_GET['host_domain']) && $_GET['host_domain'] == $val['host_domain']) ? 'disabled' : '';?> ><span class="check icon"></span> <?php echo (isset($_GET['host_domain']) && $_GET['host_domain'] == $val['host_domain']) ? '已选择' : '选择';?></button></td>
			</tr>
	<?php
		}
	}
	?>
</table>

<?php
if (isset($_GET['host_domain']))
{
?>
<br />
<br />
<p><font class="li">02,</font> 选择您需要安装的程序:</p>
<table border="0" cellspacing="1"  id="STable" style="width:900px;">
	<tr>
	<th width="18">ID</th>
	<th width="50">类别</th>
	<th width="150">程序名称 & 版本</th>
	<th width="550">程序描述 & 官方网站</th>
	<th width="100">选择</th>
	</tr>
	<?php 
	if(!is_array($product_list) || count($product_list) < 1)
	{
	?>
		<tr><td colspan="6" style="padding:10px;">暂无可选程序安装。</td></tr>
	<?php	
	}
	else
	{
		foreach ($product_list as $key=>$val)
		{
			if($_GET['product_name'] == $val['product_name'])
				$CloseAuto = isset($val['CloseAuto']) ? true : false;
	?>
			<tr>
			<th class="i"><?php echo $val['product_id'];?></th>
			<td><?php echo $val['product_sort'];?></td>
			<td>
			<img src="<?php echo $val['logo'];?>" /><br />
			<?php echo $val['product_name'];?></td>
			<td class="product_description">
			<?php echo isset($val['partner']) ? '<img src="View/images/AMWebsite/good.gif" style="margin-bottom:-3px"/> 特别推荐<br />' : '';?>
			<?php echo $val['product_description'];?>
			<?php echo !empty($val['base_module']) ? "<br />(额外需要安装模块：<b>{$val['base_module']}</b>)" : '';?>
			<br />
			<a href="<?php echo $val['product_website'];?>" target="_blank"><?php echo $val['product_website'];?></a> 
			</td>
			<td><button type="button" class="primary button" onclick="WindowLocation('./index.php?c=AMWebsite&host_domain=<?php echo $_GET['host_domain'];?>&product_name=<?php echo $val['product_name'];?>')" <?php echo (isset($_GET['product_name']) && $_GET['product_name'] == $val['product_name']) ? 'disabled' : '';?> ><span class="check icon"></span> <?php echo (isset($_GET['product_name']) && $_GET['product_name'] == $val['product_name']) ? '已选择' : '选择';?></button></td>
			</tr>
	<?php
		}
	}
	?>
</table>
	
<?php
}
?>

<?php
if (count($dirs) > 0)
{
?>
<br />
<br />
<p><font class="li">03,</font> 选择程序安装目录位置与安装模式:</p>
<form action="/index.php?c=AMWebsite" method="POST" onsubmit="return submit_install();">
<table border="0" cellspacing="1"  id="STable" style="width:880px;">
	<tr>
	<th width="450">安装目录位置</th>
	<th width="320">安装模式</th>
	<th width="100">选择</th>
	</tr>
	<?php 
	if(!is_array($dirs) || count($dirs) < 1)
	{
	?>
		<tr><td colspan="3" style="padding:10px;">无目录可选择安装。</td></tr>
	<?php	
	}
	else
	{
	?>
			<tr>
			<td>
			<select name="dir_id" id="dir_id" style="width:380px">
			<?php foreach ($dirs as $key=>$val)
			{?>
				<option value="<?php echo $key;?>"><?php echo $val;?></option>
			<?php
			}?>
			</select>
			</td>
			<td><input type="radio" name="install_model" value="manual" checked id="install_model_manual" onclick="radio_click(this)" > <label for="install_model_manual">手动模式</label>  &nbsp;
			<?php if(!$CloseAuto) {?>
				<input type="radio" name="install_model" value="automatic" id="install_model_automatic" onclick="radio_click(this)"> <label for="install_model_automatic">自动模式</label> 
				<div id="account_list_div" style="display:none;">
				<select name="account_list" id="account_list" style="width:auto;margin:8px 0px">
				<option value="">自动安装 - 请选择使用管理员账号模板</option>
				<?php foreach ($account_list as $key=>$val)
				{?>
					<option value="<?php echo $key;?>">ID<?php echo $key;?> - <?php echo $val['AMWebsite-user'];?>(<?php echo $val['AMWebsite-email'];?>)</option>
				<?php
				}?>
				</select>
				<input type="button" id="" value="管理" onclick="WindowOpen('/index.php?c=AMWebsite&a=account_templet');">
				</div>
			<?php } ?>
			</td>
			<td>
			<input type="hidden" value="<?php echo $_GET['host_domain'];?>" name="host_domain" />
			<input type="hidden" value="<?php echo $_GET['product_name'];?>" name="product_name" id="product_name"/>
			<input type="hidden" value="y" name="submit_install_y" />
			<button type="submit" name="install" id="install" class="primary button"><span class="check icon"></span> 提交</button>

			</td>
			</tr>
	<?php
	}
	?>
</table>
</form>
<?php
}
?>

<?php if ($status == 'success' && $_POST['install_model'] == 'manual') {?>
<br />
<div id="admin_info">
<p>您使用的是手动安装模式，请继续完成(<?php echo $_POST['product_name'];?>)程序的安装：
<button type="button" class="primary button" onclick="WindowOpen('http://<?php echo $_POST['host_domain'];?><?php echo str_replace("/home/wwwroot/{$_POST['host_domain']}/web", '', $host_root);?>/')"><span class="rightarrow icon"></span> 前往完成安装</button>
</p>
</div>
<?php } elseif ($status == 'success' && $_POST['install_model'] == 'automatic') {?>
<br />
<div id="admin_info">
	<p>您使用的是自动安装模式，当前已全部完成(<?php echo $_POST['product_name'];?>)程序的安装。 <br />
	以下数据库信息有必需请您保存，并请您记住管理员使用的账号模板。
	<button type="button" class="primary button" onclick="WindowOpen('http://<?php echo $_POST['host_domain'];?><?php echo str_replace("/home/wwwroot/{$_POST['host_domain']}/web", '', $host_root);?>/')"><span class="rightarrow icon"></span> 查看网站</button>
	</p>
	<br />
	<div style="font-size:14px;margin:5px 0px;">» 数据库信息</div>
	&nbsp; 数据库名：<?php echo $install_db_info['DBName']; ?><br />
	&nbsp; 数据库用户：<?php echo $install_db_info['DBUser']; ?><br />
	&nbsp; 数据库密码：<?php echo $install_db_info['DBPass']; ?><br />
	<br />
	<div style="font-size:14px;margin:5px 0px;">» 账号模板 (ID <?php echo $_POST['account_list'];?>)</div>
	&nbsp; 网站后台管理员：<?php echo $install_db_info['AdminUser']; ?><br />
	&nbsp; 管理员密码：<?php echo $install_db_info['AdminPass']; ?><br />
	&nbsp; 管理员Email：<?php echo $install_db_info['AdminEmail']; ?><br />
	<br />
</div>
<?php } ?>

<br /><br />
<button type="button" class="primary button" onclick="WindowLocation('./index.php?c=AMWebsite')"><span class="home icon"></span> 返回</button>
</div>

<div id="notice_message" style="width:880px;">
<h3>» AMWebsite 使用说明</h3>
1) 程序首次安装需下载程序安装包，如果服务器带宽较慢，安装时间会稍微长些。<br />
2) 一键安装网站程序，AMWebsite脚本将会清空安装目录的所有文件。<br />
3) AMWebsite 一键建站提供两种安装模式：手动模式，自动模式。 <br />
4) 手动模式：AMWebsite下载网站程序至相应目录，程序的安装步骤需您手动完成。<br />
5) 自动模式：首先您需新建立管理员账号模板使用，选择提交后AMWebsite将自动完成程序所有的安装步骤，并初始化默认一数据库账号。<br />
&nbsp; &nbsp; A) 完成安装后有必要请登录相应程序网站后台清除相关缓存。<br />
&nbsp; &nbsp; B) 另外、默认数据库账号信息与管理员账号信息保存在网站根目录/AMWebsite_DB.php文件，您可查看或删除。<br />
6) 本模块的安装与卸载不会影响已完成安装的站点。<br />
7) 个别程序不支持自动安装模式，请使用手动安装模式。<br />
8) 更多使用帮助与新版本支持或问题反馈，请联系AMH官方网站。<br />

<h3>» SSH AMWebsite</h3>
1) 有步骤提示操作: <br />
ssh执行命令: amh module AMWebsite-2.0<br />
然后选择对应的操作选项进行管理。<br />
<br />

2) AMWebsite admin管理选项：
<br />执行 amh module AMWebsite-2.0 admin 提示输入管理参数 (例如, install,amysql.com,/home/wwwroot/amysql.com/web)
<br />或可以不输入直接回车显示下面选项菜单。
<ul>
<li>install: 进行安装程序。</li>
<li>exit: 退出不做操作。</li>
</ul>

3) admin管理选项 install完整参数：<br />
instll,主标识域名,安装目录,安装模式(manual/automatic),程序名称,模板账号ID(manual手动模式可忽略此参数)。<br />
ssh安装程序使用例子： amh module AMWebsite-2.0 admin install,amysql.com,/home/wwwroot/amysql.com/web,automatic,phpwind-9.0,2 <br />
<br />
</div>

</div>
<?php include('footer.php'); ?>	<!-- 载入面板底部文件 -->
