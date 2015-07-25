package game.scene
{
	import com.dialog.DialogMgr;
	import com.scene.BaseScene;
	import com.sound.SoundManager;
	import com.utils.Constants;
	
	import game.manager.AssetMgr;
	import game.manager.GameMgr;
	import game.view.chat.component.JTChatControllerComponent;
	import game.view.chat.component.JTMessageHornComponent;
	import game.view.chat.component.JTMessageSystemComponent;
	import game.view.userLog.SelectServerDlg;
	
	import sdk.PushNotifications;
	
	import starling.display.Image;

	/**
	 * 游戏登录界面
	 * @author hyy
	 */
	public class LoginScene extends BaseScene
	{
		private var isCreate : int;

		override protected function init() : void
		{
			JTChatControllerComponent.close() //出现重连时应关掉聊天对话框
			JTMessageHornComponent.close(); // 出现重连时关掉喇叭消息
			JTMessageSystemComponent.close(); // 出现重连时系统消息
			//DataEyeManger.instance.start();
			//推送
			PushNotifications.getInstance().start();
			DialogMgr.instance.open(SelectServerDlg);
		}

		override public function set data(value : Object) : void
		{
			super.data = value;
			GameMgr.instance.initAllData();
			addBackground();
			SoundManager.instance.playSound("denglu_bgm", true, 0, 99999);
			SoundManager.instance.tweenVolume("denglu_bgm", 1.0, 2);
		}


		override public function dispose() : void
		{
			SoundManager.instance.tweenVolumeSmall("denglu_bgm", 0.0, 1);
			super.dispose();
		}


		private function addBackground() : void
		{
			var background : Image = new Image(AssetMgr.instance.getTexture("ui_denglubeijing"));
			background.x = ((Constants.FullScreenWidth - background.width * Constants.scale) * .5);
			addChild(background);
		}
	}
}
