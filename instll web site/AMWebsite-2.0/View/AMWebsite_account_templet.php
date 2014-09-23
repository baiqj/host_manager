<?php include('header.php'); ?>	<!-- 载入面板头部文件 -->
<script>
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
<p>自动安装模式的账号模板管理:</p>
<div id="AMWebsite_account_list">
	<table border="0" cellspacing="1"  id="STable" style="width:800px;">
	<tr>
	<th>ID</th>
	<th>管理员账号</th>
	<th>密码</th>
	<th>管理员Email</th>
	<th>操作</th>
	</tr>
	<?php 
	$add_user_id = 1;
	if(!is_array($account_list) || count($account_list) < 1)
	{
	?>
		<tr><td colspan="5" style="padding:10px;">暂无账号模板。</td></tr>
	<?php	
	}
	else
	{
		foreach ($account_list as $key=>$val)
		{
	?>
			<tr>
			<th class="i"><?php echo $key;?></th>
			<td><?php echo $val['AMWebsite-user'];?> </td>
			<td><?php echo $val['AMWebsite-pass'];?> </td>
			<td><?php echo $val['AMWebsite-email'];?> </td>
			<td>
			<a href="./index.php?c=AMWebsite&a=account_templet&user_id=<?php echo $key;?>" class="button"><span class="pen icon"></span>编辑</a>
			<a href="./index.php?c=AMWebsite&a=account_templet&del=<?php echo $key;?>" class="button" onclick="return confirm('确认删除账号模板ID:<?php echo $key;?> ?');"><span class="cross icon"></span> 删除</a>
			</td>
			</tr>
	<?php
			$add_user_id = $key + 1;	// 新增ID
		}
	}
	?>
</table>

<br /><br /><br />
<form action="./index.php?c=AMWebsite&a=account_templet" method="POST" >
<p><?php echo isset($_GET['user_id']) ? '编辑' : '新增'; ?>管理员账号模板:</p>
<table border="0" cellspacing="1"  id="STable" style="width:660px;">
<tr>
<th>名称</th>
<th>值</th>
<th>说明</th>
</tr>

<tr>
<td>管理员账号</td>
<td>
<?php if (isset($_GET['user_id'])) { ?>
	<!-- 编辑保存 -->
	<input type="text" id="AMWebsite-user" name="AMWebsite-user" value="<?php echo $_POST['AMWebsite-user'];?>" class="input_text"  />
	<input type="hidden" name="user_id" value="<?php echo $_GET['user_id'];?>" />
<?php } else {?>
	<input type="text" class="input_text" id="AMWebsite-user" name="AMWebsite-user" value="<?php echo isset($_POST['AMWebsite-user']) ?  $_POST['AMWebsite-user'] : '';?>" />
	<input type="hidden" name="user_id" value="<?php echo $add_user_id;?>" />
<?php } ?>
<font class="red">*</font></td>
<td>安装程序使用的管理员账号
</td>
</tr>
<tr>
<td>密码</td>
<td><input name="AMWebsite-pass" class="input_text"  id="AMWebsite-pass"  value="<?php echo isset($_POST['AMWebsite-pass']) ? $_POST['AMWebsite-pass'] : '';?>" /> <font class="red">*</font></td>
<td>设置管理员的密码
</td>
</tr>
<tr>
<td>Email</td>
<td><input name="AMWebsite-email" class="input_text"  id="AMWebsite-email" value="<?php echo isset($_POST['AMWebsite-email']) ? $_POST['AMWebsite-email'] : '';?>" /> <font class="red">*</font></td>
<td>设置管理员的Email地址
</td>
</tr>
<tr><th colspan="3" style="padding:10px;text-align:left;">
<button type="submit" class="primary button" name="<?php echo isset($_GET['user_id']) ? 'save' : 'add';?>"><span class="check icon"></span><?php echo isset($_GET['user_id']) ? '保存' : '新增';?></button> 
</th></tr>
</table>
</form>

<br />
<br />
<button type="button" class="primary button" onclick="WindowLocation('./index.php?c=AMWebsite&a=account_templet')"><span class="home icon"></span> 返回</button>
</div>

</div>
<?php include('footer.php'); ?>	<!-- 载入面板底部文件 -->
