package game.view.notice
{
	import com.langue.Langue;
	import com.view.base.event.EventType;
	
	import flash.text.TextFormat;
	
	import feathers.controls.ScrollText;
	
	import game.dialog.ShowLoader;
	import game.manager.GameMgr;
	import game.net.GameSocket;
	import game.net.data.c.CNotice;
	import game.net.data.s.SNotice;
	import game.net.data.vo.noticeVO;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	/**
	 * 公告
	 * @author Administrator
	 *
	 */
	public class NoticeDlg extends NoticeDlgBase
	{

		private var _scrollText : ScrollText;

		public function NoticeDlg()
		{
			super();
			enableTween=true;
			clickBackroundClose();
			_closeButton = closeButton;
			titleTxt.text = Langue.getLangue("noticeDlgTitle");

			infoTxt.fontName = "方正综艺简体";
			_closeButton.text = Langue.getLangue("noticeDlgClose");

			_scrollText = new ScrollText();
			_scrollText.x = infoTxt.x;
			_scrollText.y = infoTxt.y;
			_scrollText.width = infoTxt.width;
			_scrollText.height = infoTxt.height;

			var textFormat : TextFormat = new TextFormat(infoTxt.fontName, infoTxt.fontSize, infoTxt.color);
			_scrollText.textFormat = textFormat;
			addChild(_scrollText);
			GameMgr.instance.hasNotice = false;
			this.dispatch(EventType.UPDATE_NOTICE);
		}

		override protected function addListenerHandler() : void
		{
			super.addListenerHandler();
			this.addContextListener(SNotice.CMD + "", messageNotification);
		}

		override public function open(container : DisplayObjectContainer, parameter : Object = null, okFun : Function = null, cancelFun : Function = null) : void
		{
			super.open(container, parameter, okFun, cancelFun);
			var cmd : CNotice = new CNotice();
			GameSocket.instance.sendData(cmd);
			ShowLoader.add();
			setToCenter();

		}

		private function messageNotification(evt : Event, info : SNotice) : void
		{
			updateNoticeInfo(info);
			ShowLoader.remove();
		}

		private function updateNoticeInfo(info : SNotice) : void
		{
			var str : String = "";
			var len : int = info.notice.length;

			for (var i : int = 0; i < len; i++)
			{
				str += (info.notice[i] as noticeVO).msg;
			}
			_scrollText.text = str;
		}
	}
}