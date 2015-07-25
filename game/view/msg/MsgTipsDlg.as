package game.view.msg
{
	import com.components.RollTips;
	import com.dialog.DialogMgr;
	import com.langue.Langue;
	import com.singleton.Singleton;

	import game.dialog.MsgDialog;
	import game.dialog.ShowLoader;

	public class MsgTipsDlg
	{
		public function MsgTipsDlg()
		{
			super();
		}

		public static function get instance() : MsgTipsDlg
		{
			return Singleton.getInstance(MsgTipsDlg) as MsgTipsDlg;
		}

		public function tips(code : int) : void
		{
			var tip : MsgDialog = DialogMgr.instance.open(MsgDialog) as MsgDialog;

			if (!tip)
				return;

			if (code == 1001)
			{
				tip.contentTxt.text = Langue.getLangue("ServerClose");
			}
			else if (code == 1002)
			{
				tip.contentTxt.text = Langue.getLangue("elsewhereLogin");
			}
			else if (code == 1003)
			{
				tip.contentTxt.text = Langue.getLangue("serverFull")
			}
			else if (code == 1004)
			{
				tip.contentTxt.text = Langue.getLangue("serverBusy");
			}
			else if (code == 1008)
			{
				tip.contentTxt.text = Langue.getLangue("packFulls");
			}
			//连接超时
			else if (code == 1009)
			{
				ShowLoader.remove();
				tip.contentTxt.text = Langue.getLangue("connect_out");
			}
			//数据更新
			else if (code == 1010)
			{
				ShowLoader.remove();
				tip.contentTxt.text = Langue.getLangue("update_data");
			}
		}
	}
}