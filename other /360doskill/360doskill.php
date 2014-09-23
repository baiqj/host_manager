<?php
$username = "360"; //设置用户名
$password = "360"; //设置密码
ob_start();
set_time_limit(0);
error_reporting(E_ALL & ~E_NOTICE);
$md5 = md5(md5($username).md5($password));
$realpath = realpath('./');
$selfpath = $_SERVER['PHP_SELF'];
$selfpath = substr($selfpath, 0, strrpos($selfpath,'/'));
define('REALPATH', str_replace('//','/',str_replace('\\','/',substr($realpath, 0, strlen($realpath) - strlen($selfpath)))));
define('MYFILE', basename(__FILE__));
define('MYPATH', str_replace('\\', '/', dirname(__FILE__)).'/');
define('MYFULLPATH', str_replace('\\', '/', (__FILE__)));
define('HOST', "http://".$_SERVER['HTTP_HOST']);
?>
<html>
<head>
<title>360网站卫士-PHP-DOS攻击脚本专杀工具></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style>
body{margin:0px;}
body,td{font: 12px Arial,Tahoma;line-height: 16px;}
a {color: #00f;text-decoration:underline;}
a:hover{color: #f00;text-decoration:none;}
.alt1 td{border-top:1px solid #fff;border-bottom:1px solid #ddd;background:#f1f1f1;padding:5px 10px 5px 5px;border-right: 1px solid #ddd;}
.alt2 td{border-top:1px solid #fff;border-bottom:1px solid #ddd;background:#f9f9f9;padding:5px 10px 5px 5px;border-right: 1px solid #ddd;}
.focus td{border-top:1px solid #fff;border-bottom:1px solid #ddd;background:#d6e9c6;padding:5px 10px 5px 5px;}
.head td{border-top:1px solid #fff;border-bottom:1px solid #ddd;background:#e9e9e9;padding:5px 10px 5px 5px;font-weight:bold;}
.head td span{font-weight:normal;}
</style>
</head>
<body>
<?php
if(!(isset($_COOKIE['360wzb']) && $_COOKIE['360wzb'] == $md5) && !(isset($_POST['username']) && isset($_POST['password']) && (md5(md5($_POST['username']).md5($_POST['password']))==$md5)))
{
 echo '<center><img src="http://wangzhan.360.cn/statics/img/logo.png?1381994291" title="360网站卫士" border="0"><br/>PHP-DOS攻击脚本专杀工具<br/><br/><br/><br/><form id="frmlogin" name="frmlogin" method="post" action="">用户名: <input type="text" name="username" id="username" /> 密码: <input type="password" name="password" id="password" /> <input type="submit" name="btnLogin" id="btnLogin" value="登陆" /></form></center>';
}
elseif(isset($_POST['username']) && isset($_POST['password']) && (md5(md5($_POST['username']).md5($_POST['password']))==$md5))
{
 setcookie("360wzb", $md5, time()+60*60*24*365,"/");
 echo "登陆成功！";
 header( 'refresh: 1; url='.MYFILE.'?action=scan' );
 exit();
}
else
{
 setcookie("360wzb", $md5, time()+60*60*24*365,"/");
 $action = isset($_GET['action'])?$_GET['action']:"";
 
 if($action=="logout")
 {
  setcookie ("360wzb", "", time() - 3600);
  Header("Location: ".MYFILE);
  exit();
 }
?>
<div style="width:1000px;margin:0px auto;border: 1px solid #ccc;">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
 <tbody>
 <tr class="head">
  <td><img src="http://wangzhan.360.cn/statics/img/logo.png?1381994291" title="360网站卫士" border="0"></td>
 </tr>
 <tr class="head">
 <?php
 $v = file_get_contents('http://data.wangzhan.360.cn/version.php');//检查版本更新
 $v = explode('|',$v);
 ?>
  <td>PHP-DOS攻击脚本专杀工具 <span style="float: right;">您的IP:<?php if($_SERVER['SERVER_ADDR']){echo $_SERVER['SERVER_ADDR'];}else{ echo $_SERVER['LOCAL_ADDR'];}?> | 系统时间:<?php echo date("Y-m-d H:i:s");?></span></td>
  </tr>
  <tr class="head">
  <td align="center"><?php  if($v[2]){ echo "发现新版本，请立即更新到 V2.0 <a href='http://wangzhan.360.cn/statics/360doskill.zip'>点击下载</a>";} else {echo "当前已是最新版本";}?></td>
 </tr>
</tbody></table>
<br>
<?php
  $dir = isset($_POST['path'])?$_POST['path']:MYPATH;
  $dir = substr($dir,-1)!="/"?$dir."/":$dir;
?>
<form name="frmScan" method="post" action="">
<table width="100%%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="45" style="vertical-align:middle; padding-left:5px;">扫描路径:</td>
    <td width="690">
        <input type="text" name="path" id="path" style="width:600px" value="<?php echo $dir?>">
        &nbsp;&nbsp;<input type="submit" name="btnScan" id="btnScan" value="开始扫描"></td>
  </tr>
</table>
</form>
<?php
  if(isset($_POST['btnScan']))
  {
   $start=time();
   $list = "";
   
   if(!is_readable($dir))
    $dir = MYPATH;
   $count=$scanned=0;
   find($dir);
   $end=time();
   $spent = ($end - $start);
?>
<div style="padding:10px; background-color:#ccc">扫描: <?php echo $scanned?> 文件 | 发现: <?php echo $count?> 行恶意代码 | 耗时: <?php echo $spent?> 秒 | 请站长手动删除以下恶意文件</div>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="head">
    <td width="15" align="center">No.</td>
    <td width="350">恶意文件</td>
    <td width="100">所在行号</td>
    <td width="300">详细内容</td>
  </tr>
<?php
echo $list;
?>
</table>
<center><br /><br />此页面是由 <A HREF="http://wangzhan.360.cn" target="_BLANK">360网站卫士</a>提供的PHP-DOS攻击脚本专杀工具页面，使用反馈请联系:<a href="mailto:dongfang-s@360.cn?subject=DOS-feedback">dongfang-s@360.cn</a>.<br /><br />
Copyright©2011-2013 360网站卫士 <br /></center>
<script src="http://data.wangzhan.360.cn/version.php"></script>
<?php
  }
 }
ob_flush();
?>
</div>
</body>
</html>
<?php
$self = basename($_SERVER['PHP_SELF']);
function cut_str($string, $sublen, $start = 0, $code = 'UTF-8') {
	if ($code == 'UTF-8') {
		$pa = "/[\x01-\x7f]|[\xc2-\xdf][\x80-\xbf]|\xe0[\xa0-\xbf][\x80-\xbf]|[\xe1-\xef][\x80-\xbf][\x80-\xbf]|\xf0[\x90-\xbf][\x80-\xbf][\x80-\xbf]|[\xf1-\xf7][\x80-\xbf][\x80-\xbf][\x80-\xbf]/";
		preg_match_all($pa, $string, $t_string);
		if (count($t_string[0]) - $start > $sublen) return join('', array_slice($t_string[0], $start, $sublen)) . "...";
		return join('', array_slice($t_string[0], $start, $sublen));
	} else {
		$start = $start * 2;
		$sublen = $sublen * 2;
		$strlen = strlen($string);
		$tmpstr = '';
		for($i = 0; $i < $strlen; $i++) {
			if ($i >= $start && $i < ($start + $sublen)) {
				if (ord(substr($string, $i, 1)) > 129) {
					$tmpstr .= substr($string, $i, 2);
				} else {
					$tmpstr .= substr($string, $i, 1);
				} 
			} 
			if (ord(substr($string, $i, 1)) > 129) $i++;
		} 
		if (strlen($tmpstr) < $strlen) $tmpstr .= "...";
		return $tmpstr;
	} 
} 

function find($directory) {
	$self = basename($_SERVER['PHP_SELF']);
	global $list,$count,$scanned;
	$mydir = dir($directory);
	while ($file = $mydir -> read()) {
		if ((is_dir("$directory/$file")) && ($file != ".") && ($file != "..")) {
			find("$directory/$file");
		} else {
			if($file != $self){
			if ($file != "." && $file != ".." && preg_match("/.php/i", $file)) {
				$fd = realpath($directory . "/" . $file);
				$fp = fopen($fd, "r");				
				$scanned +=1;
				$i = 0;
				while ($buffer = fgets($fp, 4096)) {
					$i++;
					if ((preg_match('/(pfsockopen|fsockopen)\("(udp|tcp)/i', $buffer)) || (preg_match('/Php 2012 Terminator/i', $buffer)) || (preg_match('/[\$_GET|\$_REQUEST]\[\'rat\']/i', $buffer)) || (preg_match('/Tcp3 CC.center/i', $buffer)) || (preg_match('/xdos.s/i', $buffer)) || (preg_match('/儏摓煁晜泟/i', $buffer))) {
						$count += 1;
						$j = $count % 2 + 1;
						$buffer = htmlspecialchars(cut_str($buffer,80,0));
						$list.= "<tr class='alt$j' onmouseover='this.className=\"focus\";' onmouseout='this.className=\"alt$j\";'>
						  <td>$count</td>
						  <td>$fd</td>
						  <td>第 $i 行</td>
						  <td>$buffer</td>
						  </tr>";
					} 
				} 
				fclose($fp);
			} 
		}
		} 
	} 
	$mydir -> close();
} 
?>