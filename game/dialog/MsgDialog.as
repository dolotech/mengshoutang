package game.dialog
{
	import game.data.Val;
	import game.net.message.ConnectMessage;
	import game.view.SystemSet.SystemSetDlg;
	
	import sdk.AccountManager;
	
	import starling.events.Event;

	/**
	 *游戏信息弹出对话框
	 * @author Administrator
	 *
	 */
	public class MsgDialog extends MsgDlgBase
	{
		public static var conut : int = 0;

		public function MsgDialog()
		{
			okButton.fontSize = 30;
			okButton.text = Val.OK;
			titleTxt.text = Val.tips_title;
			//必须点击确认
			//clickBackroundClose();
		}

		override protected function show() : void
		{
			if (contentTxt.text == Val.ServerClose || contentTxt.text == Val.elsewhereLogin)
				return;
			text = String(_parameter);
			setToCenter();
		}

		public function set text(value : String) : void
		{
			contentTxt.text = value;
			okButton.visible = value != Val.connect_tips;
		}

		public function get text() : String
		{
			return contentTxt.text;
		}

		override protected function addListenerHandler() : void
		{
			this.addViewListener(okButton, Event.TRIGGERED, onOkHdr);
		}

		private function onOkHdr(e : Event) : void
		{

			switch (contentTxt.text)
			{
				case Val.connect_again:
					if (ConnectMessage.isAutoLogin)
					{
						ConnectMessage.connect(connectOk);
						text = Val.connect_tips;
					}
					else
					{
						close();
					}

					function connectOk() : void
				{
					ShowLoader.remove();
					addTips("connect_ok");
				}
					return;
					break;
				case Val.ServerClose:
					SystemSetDlg.logout();
					return;
					break;
				case Val.elsewhereLogin:
					//如果缓存有保存用户文件，则删除该文件   , 清除缓存文件
					SystemSetDlg.logout();
					break;
				case Val.update_data:
					AccountManager.instance.exitApp();
					break;
                default :
                    break;
			}
			onOkBtn();
		}

		override public function getViewGuideDisplay(name : String) : *
		{
			return okButton;
		}
	}
}