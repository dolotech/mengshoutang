package game.view.chat.component
{
	import com.scene.SceneMgr;
	import com.utils.Constants;

	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;

	import game.common.JTGlobalFunction;
	import game.common.JTSession;
	import game.manager.AssetMgr;
	import game.net.data.s.SChat;
	import game.scene.GameLoadingScene;
	import game.view.chat.base.JTUIMessageNotice;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	/**
	 * 喇叭横条
	 * @author Administrator
	 *
	 */
	public class JTMessageHornComponent extends JTUIMessageNotice
	{
		private static var notice : JTMessageHornComponent = null;
		private var container : Sprite = null;
		private static var messages : Vector.<SChat> = new Vector.<SChat>();
		private var isTween : Boolean = false;

		public function JTMessageHornComponent()
		{
			super();
			initialize();
		}

		public function initMessage(msg : SChat) : void
		{
			this.alpha = 1;
			this.isTween = true;
			var content : String = msg.content;
			this.txt_noticeTxt.text = "<font color='#33FCFC' face='方正综艺简体' size='24'><b>【喇叭】" + msg.name + " : </b></font>" + "<font color='#ff9900' face='方正综艺简体' size='24'><b>" + content + "</b></font>";
			Starling.juggler.tween(this.container, 15, {x: -txt_noticeTxt.textBounds.width, onComplete: onFinshTween});
		}


		private function onFinshTween() : void
		{
			JTMessageHornComponent.close();

			if (messages.length > 0)
			{
				open(messages.shift());
			}
		}

		private function initialize() : void
		{
			this.removeChild(txt_noticeTxt);
			this.container = new Sprite();
			this.container.addChild(this.txt_noticeTxt);
			this.addChild(this.container);
			var image : Image = this.getChildAt(0) as Image;
			image.y += image.height + 5;
			var txtMoveY : Number = 91.15 + image.height + 5;
			var horn_Texture : Texture = AssetMgr.instance.getTexture("ui_icon_chat1");
			var horn_Image : Image = new Image(horn_Texture);
			this.container.addChild(horn_Image);
			this.txt_noticeTxt.y = txtMoveY;
			this.txt_noticeTxt.isHtml = true;
			this.alpha = 0;
			this.clipRect = new Rectangle(116.7, txtMoveY, 723, this.height);
			this.txt_noticeTxt.autoSize = TextFieldAutoSize.CENTER;
			this.txt_noticeTxt.autoScale = true;
			horn_Image.scaleX = .9;
			horn_Image.scaleY = .9;
			horn_Image.x = 0;
			horn_Image.y = 91 + horn_Image.height / 2 + 20;
			txt_noticeTxt.x = horn_Image.width + 5;
			this.container.x = Constants.FullScreenWidth;
		}

		public function onReset() : void
		{
			this.alpha = 0;
			this.isTween = false;
			this.container.x = Constants.FullScreenWidth;
			Starling.juggler.removeTweens(this.container);
		}
		
		public static function open(msg : SChat) : void
		{
			if (SceneMgr.instance.getCurScene() is GameLoadingScene)
				return;

			if (!notice)
			{
				notice = new JTMessageHornComponent();
				JTGlobalFunction.autoAdaptiveSize(notice);
				JTSession.layerGlobal.addChild(notice);
			}

			if (!notice.isTween)
				notice.initMessage(msg);
			else
				messages.push(msg);
		}

		public static function close() : void
		{
			if (!notice)
			{
				return;
			}

			if (notice.alpha)
			{
				notice.onReset();
			}
		}
	}
}