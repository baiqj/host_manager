<?php

class AccountTemplets extends AmysqlModel
{
	// 账号列表
	function get_account_list($id = NULL)
	{
		$data = array();
		$sql = "SELECT * FROM amh_config WHERE config_name LIKE 'AMWebsite%' ORDER BY config_id ASC";
		$result = $this -> _query($sql);
		while ($rs = mysql_fetch_assoc($result))
		{
			$key = explode('-', $rs['config_name']);
			if (!empty($id))
			{
				if($key[2] == $id)
					$data["{$key[0]}-{$key[1]}"] = $rs['config_value'];
			}
			else
			{
				$data[$key[2]]["{$key[0]}-{$key[1]}"] = $rs['config_value'];
			}
		}
		Return $data;
	}

	// 删除账号
	function del_account($id)
	{
		$sql = "DELETE FROM amh_config WHERE config_name LIKE 'AMWebsite-%-{$id}' ";
		$this -> _query($sql);
		Return $this -> Affected;
	}
	
	// 保存
	function save_account()
	{
		$user_id = (int)$_POST['user_id'];
		if (!empty($user_id))
		{
			$field = array('AMWebsite-user', 'AMWebsite-pass', 'AMWebsite-email');
			$up_row = 0;
			foreach ($field as $key=>$val)
			{
				$arr = array('config_value' => $_POST[$val]);
				$up_row += $this -> _update('amh_config', $arr, "WHERE config_name = '$val-$user_id'");
			}
			Return $up_row;
		}
		Return false;
	}

	// 新增
	function add_account()
	{
		$user_id = (int)$_POST['user_id'];
		if (!empty($user_id))
		{
			$field = array('AMWebsite-user', 'AMWebsite-pass', 'AMWebsite-email');
			$up_row = 0;
			foreach ($field as $key=>$val)
			{
				$arr = array('config_name' => "$val-$user_id", 'config_value' => $_POST[$val]);
				$up_row += $this -> _insert('amh_config', $arr);
			}
			Return $up_row;
		}
		Return false;
	}

}

?>