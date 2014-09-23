<?php
require_once('scan_conf.php');
error_reporting(0);
class scan{
	private $directory = '../';
	private $extension = '*';
	private $_files = array();
	private $filelimit = 5000;
	private $scan_hidden = true;
	private $_self = '';
	private $_regex='';
	private $_regex_easy ='KHByZWdfcmVwbGFjZS4qXC9lfGAuKj9cJC4qP2B8XGJjcmVhdGVfZnVuY3Rpb25cYnxcYnBhc3N0aHJ1XGJ8XGJzaGVsbF9leGVjXGJ8XGJleGVjXGJ8XGJiYXNlNjRfZGVjb2RlXGJ8XGJlZG9jZWRfNDZlc2FiXGJ8XGJldmFsXGJ8XGJzeXN0ZW1cYnxcYnByb2Nfb3BlblxifFxicG9wZW5cYnxcYmN1cmxfZXhlY1xifFxiY3VybF9tdWx0aV9leGVjXGJ8XGJwYXJzZV9pbmlfZmlsZVxifFxic2hvd19zb3VyY2VcYnxjbWRcLmV4ZXxLQWRvdEBuZ3NcLnJ1fundefinedundefinedENaNundefinednundefinedHundefinedQundefined3undefinedoundefinedHxQSFBcczundefinedNundefinedXxzaGVsbFxzPundefinedundefined6undefinedHxXU2NyaXB0XC5zaGVsbHxQSFBccz9TaGVsbHxFdmFsXHNQSFBcc0NvZGV8VWRwMS1mc29ja29wZW58eHhkZG9zfFNlbmRcc0Zsb3d8ZnNvY2tvcGVuXCgiKHVkcHx0Y3ApfFNZTlxzRmxvb2Qp';
	private $_regex_complex='KFwkXyhHRVR8UE9TVHxDT09LSUV8UkVRVUVTVCkp';
	private $_shellcode='';
	private $_shellcode_line=array();
	private $_log_array= array();
	private $_log_count=0;
	private $webscan_url="http://safe.webscan.360.cn/webshell/upload";
	private $webscan_upload="http://upload.webscan.360.cn/index.php";
	private $action='';
	private $taskid=0;
	private $_tmp='';
	private $_server_staust='';
	private $_endfile='';

	function __construct(){
		if (isset($_POST['action'])&&isset($_POST['key'])&&$_POST['key']==WEBSCAN_KEY&&isset($_POST['task'])) {
			$this->action = $_POST['action'];
			$this->taskid = $_POST['task'];
			$this->_regex = isset($_POST['scan_d'])&&$_POST['scan_d']=='1' ? $this->_regex_complex : $this->_regex_easy;
		}
		if (is_writable('./')) {
			$this->_tmp='./';
		}
		elseif (is_writable(sys_get_temp_dir())) {
			$this->_tmp=substr(sys_get_temp_dir(), -1)=='/'||substr(sys_get_temp_dir(), -1)=='\\' ? sys_get_temp_dir() : sys_get_temp_dir().'/';
		}

	}

	private function is__writable($path) {

		if ($path{strlen($path)-1}=='/')
		return is__writable($path.uniqid(mt_rand()).'.tmp');

		if (file_exists($path)) {
			if (!($f = @fopen($path, 'r+')))
			return false;
			fclose($f);
			return true;
		}

		if (!($f = @fopen($path, 'w')))
		return false;
		fclose($f);
		@unlink($path);
		return true;
	}


	private  function json_encode_($arg, $force = true)
	{
		static $_force;
		if (is_null($_force))
		{
			$_force = $force;
		}

		if ($_force && function_exists('json_encode'))
		{
			return json_encode($arg);
		}

		$returnValue = '';
		$c           = '';
		$i           = '';
		$l           = '';
		$s           = '';
		$v           = '';
		$numeric     = true;

		switch (gettype($arg))
		{
			case 'array':
				foreach ($arg AS $i => $v)
				{
					if (!is_numeric($i))
					{
						$numeric = false;
						break;
					}
				}

				if ($numeric)
				{
					foreach ($arg AS $i => $v)
					{
						if (strlen($s) > 0)
						{
							$s .= ',';
						}
						$s .= $this->json_encode_($arg[$i]);
					}

					$returnValue = '[' . $s . ']';
				}
				else
				{
					foreach ($arg AS $i => $v)
					{
						if (strlen($s) > 0)
						{
							$s .= ',';
						}
						$s .= $this->json_encode_($i) . ':' . $this->json_encode_($arg[$i]);
					}

					$returnValue = '{' . $s . '}';
				}
				break;

			case 'object':
				foreach (get_object_vars($arg) AS $i => $v)
				{
					$v = $this->json_encode_($v);

					if (strlen($s) > 0)
					{
						$s .= ',';
					}
					$s .= $this->json_encode_($i) . ':' . $v;
				}

				$returnValue = '{' . $s . '}';
				break;

			case 'integer':
			case 'double':
				$returnValue = is_numeric($arg) ? (string) $arg : 'null';
				break;

			case 'string':
				$returnValue = '"' . strtr($arg, array(
                    "\r"   => '\\r',    "\n"   => '\\n',    "\t"   => '\\t',     "\b"   => '\\b',
                    "\f"   => '\\f',    '\\'   => '\\\\',   '"'    => '\"',
                    "\x00" => '\u0000', "\x01" => '\u0001', "\x02" => '\u0002', "\x03" => '\u0003',
                    "\x04" => '\u0004', "\x05" => '\u0005', "\x06" => '\u0006', "\x07" => '\u0007',
                    "\x08" => '\b',     "\x0b" => '\u000b', "\x0c" => '\f',     "\x0e" => '\u000e',
                    "\x0f" => '\u000f', "\x10" => '\u0010', "\x11" => '\u0011', "\x12" => '\u0012',
                    "\x13" => '\u0013', "\x14" => '\u0014', "\x15" => '\u0015', "\x16" => '\u0016',
                    "\x17" => '\u0017', "\x18" => '\u0018', "\x19" => '\u0019', "\x1a" => '\u001a',
                    "\x1b" => '\u001b', "\x1c" => '\u001c', "\x1d" => '\u001d', "\x1e" => '\u001e',
                    "\x1f" => '\u001f'
                    )) . '"';
                    break;

			case 'boolean':
				$returnValue = $arg?'true':'false';
				break;

			default:
				$returnValue = 'null';
		}

		return $returnValue;
	}



	private  function checkBOM ($contents)
	{
		$charset[1]=substr($contents, 0, 1);
		$charset[2]=substr($contents, 1, 1);
		$charset[3]=substr($contents, 2, 1);
		if (ord($charset[1])==239 && ord($charset[2])==187 && ord($charset[3])==191) {
			$contents=substr($contents, 3);
			return $contents;
		}
		return $contents;
	}


	private function ck_state(){
		$a=fopen($this->_tmp.'scan_lock.tmp', 'w+');
		fwrite($a, "scannig");
		fclose($a);

	}

	public function del_state(){
		$a=fopen($this->_tmp.'scan_lock.tmp', 'w+');
		fwrite($a, '');
		fclose($a);
		@unlink($this->_tmp.'scan_lock.tmp');
		$this->post($this->webscan_url,array('state'=>'1','key'=>WEBSCAN_KEY,'task'=>$this->taskid));
	}

	private function is_utf8($word)
	{
		if (preg_match("/^([".chr(228)."-".chr(233)."]{1}[".chr(128)."-".chr(191)."]{1}[".chr(128)."-".chr(191)."]{1}){1}/",$word) == true || preg_match("/([".chr(228)."-".chr(233)."]{1}[".chr(128)."-".chr(191)."]{1}[".chr(128)."-".chr(191)."]{1}){1}$/",$word) == true || preg_match("/([".chr(228)."-".chr(233)."]{1}[".chr(128)."-".chr(191)."]{1}[".chr(128)."-".chr(191)."]{1}){2,}/",$word) == true)
		{
			return true;
		}
		else
		{

			return false;
		}
	}



	private	function check_environment()
	{

		$r = array("status"=>1,"allow_url_fopen"=>0,"writeable"=>0,"httpcode"=>0,"gzcompress"=>0);
		$this->post($this->webscan_url,array("test" => "test"));
		if (ini_get('allow_url_fopen')||function_exists('curl_init')) {
			$r["allow_url_fopen"] = 1;
		}

		if (function_exists('gzcompress')) {
			$r["gzcompress"] = 1;
		}

		if ($this->is__writable($this->_tmp.'test.tmp'))
		{
			$r["writeable"] = 1;
		}

		if($r["allow_url_fopen"] && $r["writeable"])
		{
			$r["status"] = 1;
		}
		$r["httpcode"]=$this->_server_staust;
		echo $this->json_encode_($r);
		exit;
	}


	private function webscan_curl($url , $postdata = array()){
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_HEADER, 0);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
		curl_setopt($ch, CURLOPT_TIMEOUT, 15);
		curl_setopt($ch, CURLOPT_POST, 1);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $postdata);
		$response = curl_exec($ch);
		$httpcode = curl_getinfo($ch,CURLINFO_HTTP_CODE);
		curl_close($ch);
		return array('httpcode'=>$httpcode,'response'=>$response);
	}

	private function post($url,$log=array()){
		if(! function_exists('curl_init')) {
		$postdata = http_build_query($log);
	 	$context = stream_context_create(array('http' => array('method' => 'POST', 'header' => "Content-type: application/x-www-form-urlencoded\r\n",'content' => $postdata)));
	 	@file_get_contents($url, 0, $context);
	 	preg_match_all("/(?<=\s)\d{3}(?=\s)/i",$http_response_header[0],$matches);
	 	$this->_server_staust = intval($matches[0][0]);
		}
		else{
			$server_staust=$this->webscan_curl($url,$log);
			$this->_server_staust=$server_staust['httpcode'];
		}


	}

	private function findstr($filepath,$shellstr){
		$a=false;
		$text=@file_get_contents($filepath);
		if(!$this->is_utf8($text)){
			$text=$this->checkBOM($text);
			$text=@iconv("GBK","UTF-8",$text);
		}
		$_content = explode("\n", $text);
		for ($line = 0; $line < count($_content); $line++)
		{
			$date = preg_match_all("/".$shellstr."/i", $_content[$line],$matches);
			if($date){
				$this->_shellcode[$line+1]=$_content[$line];
				$a=true;
			}
		}
		return $a;
	}
	private function upload_log($a = array()) {
		if($this->_log_count==50){
			$this->post($this->webscan_url,array('log' => $this->json_encode_($this->_log_array),'key'=>WEBSCAN_KEY,'task'=>$this->taskid,'version'=>WEBSCAN_VERSION));
			$this->_log_count=0;
			$this->_log_array=array();
		}
		else{
			$this->_log_array[]=$a;
			$this->_log_count++;
		}

	}
	private function listdir($dir) {
		$handle = @opendir($dir);
		if ($this->filelimit > 0) {
			if (count($this->_files) > $this->filelimit) {
				return true;
			}
		}
		while (($file = @readdir($handle)) !== false) {
			if ($file == '.' || $file == '..') {
				continue;
			}
			$filepath = $dir == '.' ? $file : $dir . '/' . $file;

			if (is_link($filepath)) {
				continue;
			}
			if (is_file($filepath)) {
				if (substr(basename($filepath), 0, 1) != "." || $this->scan_hidden) {
					$extension = pathinfo($filepath);
					if (is_string($this->extension) && $this->extension == '*') {
						if ($this->filelimit > 0) {
							$this->_files[] = $filepath;
						}
					} else {
						if (isset($extension['extension']) && in_array($extension['extension'], $this->extension)) {
							if ($this->_self != basename($filepath)) {
								if ($this->filelimit > 0) {
									$this->_files[] = $filepath;
								}
							}

						}
					}
				}
			} else if (is_dir($filepath)) {
				if (substr(basename($filepath), 0, 1) != "." || $this->scan_hidden) {
					if (is_readable($filepath)) {
						$this->listdir($filepath);
					}
				}
			}
		}
		closedir($handle);
	}



	private function anaylize() {
		$endfile=end($this->_files);
		foreach ($this->_files as $file) {
			if ($endfile==$file) {
				$this->_endfile=$file;
			}


			if(!$this->is_utf8($file)){
				$filename=@iconv("GBK","UTF-8",$file);
			}
			if($this->findstr($file,base64_decode($this->_regex)))
			{
					
				self::upload_log( array(array('Trojan' => 1,'time' => date("Y-m-d H:i:s",filemtime($file)),'path'=>$filename,'size'=>filesize($file),'shellcode'=>$this->_shellcode,'md5'=>md5_file($file),'e'=>$this->_endfile)) );
				$this->_shellcode=array();
			}
			else{
				self::upload_log( array(array('Trojan' => 0,'time' => date("Y-m-d H:i:s",filemtime($file)),'path'=>$filename,'md5'=>md5_file($file),'e'=>$this->_endfile)) );
			}

		}
		if ($this->_log_count>0) {
			$this->post($this->webscan_url,array('log' => $this->json_encode_($this->_log_array),'key'=>WEBSCAN_KEY,'task'=>$this->taskid,'version'=>WEBSCAN_VERSION));
		}
		sleep(5);
		$this->del_state();
	}


	private function sendfile()
	{
		$r = array("md5"=>"","info"=>"","content"=>"","gzcompress"=>0);
		if (isset($_POST['filename']))
		{
			$filename = base64_decode($_POST['filename']);
	
			if (file_exists($filename))
			{
				$r["md5"] = md5_file($filename);
				if (function_exists("gzcompress")) {
					$r["content"]= base64_encode(gzcompress(file_get_contents($filename),9));
					$r["gzcompress"]=1;
				}
				else{
					$r["content"]= base64_encode(file_get_contents($filename));
				}
			
			}
			else {
				$r["info"] = "Cant find selected file";
			}
		}
		else {
			$r["info"] = "No file specified";

		}
		if (isset($_POST['is_fixed'])&&$_POST['is_fixed']==1)
		{
			$webscan_upload=$this->webscan_url;
		}
		else{
			$webscan_upload=$this->webscan_upload;
		}
		if (isset($_POST['is_end'])&&$_POST['is_end']==1)
		{
			$is_end=1;
		}
		else{
			$is_end=0;
		}
		$this->post($webscan_upload,array('state'=>2,'log' => $this->json_encode_($r),'key'=>WEBSCAN_KEY,'task'=>$this->taskid,'is_end'=>$is_end));
		if($is_end)
		{
		$this->post($webscan_upload,array('key'=>WEBSCAN_KEY,'task'=>$this->taskid,'is_end'=>$is_end));
		}
		exit;
	}

	public function start() {
		if($this->action=='del_state'){
			$this->del_state();
		}
		if($this->action=='sendfile'){
			$this->sendfile();
		}
		if (@file_get_contents(($this->_tmp.'scan_lock.tmp'))=='scannig')  {
			exit("scannig");
		}
		switch ($this->action) {
			case 'check_environment':
				$this->check_environment();
				break;
			case 'shell_scan':
				set_time_limit(0);
				ignore_user_abort();
				register_shutdown_function(array($this,"del_state"));
				$this->ck_state();
				$this->listdir($this->directory);
				$this->anaylize();
				$this->del_state();
				break;
			default:
				echo WEBSCAN_VERSION;
				break;
		}
	}

}

$a=new scan();
$a->start();
?>