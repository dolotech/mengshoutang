package
{
	import com.dialog.DialogMgr;
	import com.langue.Langue;
	import com.mobileLib.utils.DeviceType;
	import com.scene.SceneMgr;
	import com.sound.SoundManager;
	import com.utils.Assets;
	import com.utils.Constants;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.ui.Keyboard;
	
	import game.data.Val;
	import game.dialog.MsgDialog;
	import game.manager.GameMgr;
	import game.net.message.ConnectMessage;
	import game.net.message.GoodsMessage;
	import game.net.message.RoleInfomationMessage;
	import game.scene.LoginScene;
	import game.uils.Config;
	import game.uils.GmView;
	import game.uils.LocalShareManager;
	import game.view.new2Guide.NewGuide2Manager;
	
	import sdk.AccountManager;
	import sdk.DataEyeManger;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.ResizeEvent;


	/*
	 *
	 *  程序入口
	 * */
	public class yingxiong extends Sprite
	{
		public static var mStarling : Starling;

		public function yingxiong()
		{
			addEventListener(flash.events.Event.ADDED_TO_STAGE, onAdd);
		}

		private function onError(e : UncaughtErrorEvent) : void
		{
			try
			{
				trace(e.error.errorID, e.error.name, e.error.message, e.error.getStackTrace());
				e.preventDefault();
				e.stopImmediatePropagation();
			}
			catch (e : Error)
			{

			}
		}

		private function onAdd(evt : flash.events.Event) : void
		{
			this.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onError);
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAdd);

			stage.color = 0x111111;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			Constants.frameRate = this.stage.frameRate = 24;
			this.stage.stageWidth = stage.fullScreenWidth;
			this.stage.stageHeight = stage.fullScreenHeight;
			Constants.iOS = Capabilities.manufacturer.indexOf("iOS") != -1;
			Constants.WINDOWS = Capabilities.manufacturer.indexOf("Windows") != -1;
			Constants.ANDROID = Capabilities.manufacturer.indexOf("Android") != -1;
			Starling.multitouchEnabled = false; // useful on mobile devices
			Starling.handleLostContext = !Constants.iOS; // not necessary on iOS. Saves a lot of memory!
			Constants.FullScreenWidth = stage.fullScreenWidth;
			Constants.FullScreenHeight = stage.fullScreenHeight;

			Constants.scale = stage.fullScreenHeight / Constants.standardHeight;
			Constants.scale_x = stage.fullScreenWidth / Constants.standardWidth;
			Constants.virtualHeight = stage.fullScreenHeight / Constants.scale;
			Constants.virtualWidth = stage.fullScreenWidth / Constants.scale;
			Constants.isScaleWidth = stage.fullScreenWidth / stage.fullScreenHeight < 960 / 640

			mStarling = new Starling(Game, stage, null, null, "auto", "auto");
			mStarling.stage.stageWidth = stage.fullScreenWidth; // <- same size on all devices!
			mStarling.stage.stageHeight = stage.fullScreenHeight; // <- same size on all devices!
			mStarling.simulateMultitouch = false;
			mStarling.enableErrorChecking = false;
			mStarling.antiAliasing = 0;

			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);

			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;

			stage.addEventListener(ResizeEvent.RESIZE, resizeStage);

			Assets.Logo_IMAGE = new Assets.Logo();
			var bg_image : Bitmap = Assets.Logo_IMAGE;
			bg_image.scaleX = bg_image.scaleY = Constants.scale;
			bg_image.x = (Constants.FullScreenWidth - bg_image.width) * .5;
			bg_image.y = (Constants.FullScreenHeight - bg_image.height) * .5 - 80;
			addChild(bg_image);
		}

		private function onRootCreated(event : Object, app : Game) : void
		{
			mStarling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);

			//debug版本去掉激活操作
			if (!Constants.WINDOWS)
			{
				NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, onActive, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, deActive, false, 0, true);
			}
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.EXITING, onClose, false, 0, true);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKey, false, 0, true);
			app.start();
			mStarling.start();
			SoundManager.instance.initPlayState();
		}

		private function onActive(e : *) : void
		{
			DataEyeManger.instance.onActive();
			mStarling.start();
			System.resume();
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			AccountManager.instance.showBar();
			SoundManager.instance.resumeSound();

			//每次切回到游戏，检测下是否连接了服务器
			if (!(SceneMgr.instance.getCurScene() is LoginScene))
			{
				ConnectMessage.ping();
			}

			if (RoleInfomationMessage.buyDiamondSuccess)
			{
				RoleInfomationMessage.buyDiamondSuccess = false;
				DialogMgr.instance.open(MsgDialog, Langue.getLangue("buyDiamondSuccess"));
			}
		}

		private function deActive(e : *) : void
		{
			DataEyeManger.instance.onActive();
			mStarling.stop();
			System.pause();
			AccountManager.instance.hideBar();
			SoundManager.instance.pauseSound();
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
		}

		private function resizeStage(e : flash.events.Event) : void
		{
			mStarling.stage.stageWidth = stage.fullScreenWidth;
			mStarling.stage.stageHeight = stage.fullScreenHeight;
		}

		private function onKey(event : KeyboardEvent) : void
		{
			
			//安卓退出键
			if (!Constants.iOS && event.keyCode == 16777238)
				AccountManager.instance.showAlert(Val.exit_msg, AccountManager.instance.exitApp, Val.exit, null, Val.CANCEL);

			if (event.keyCode == Keyboard.EXIT || event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
			}

			if (event.keyCode == Keyboard.MENU || event.keyCode == Keyboard.BACK || event.keyCode == Keyboard.SEARCH)
			{
				event.preventDefault();
			}

			if (event.keyCode == Keyboard.E && event.ctrlKey)
			{
				GoodsMessage.isOpen = !GoodsMessage.isOpen;
				GoodsMessage.autoTest();
			}

			if (event.keyCode == Keyboard.O && event.ctrlKey)
			{
				var tmp_tollgateId : int = GameMgr.instance.tollgateID;
				GameMgr.instance.tollgateID = 6;
				NewGuide2Manager.start();
				GameMgr.instance.tollgateID = tmp_tollgateId;
			}
			else if (event.keyCode == Keyboard.P && event.ctrlKey && event.shiftKey)
			{
				Config.isWarPass = !Config.isWarPass;
			}
			else if (event.keyCode == Keyboard.G && event.ctrlKey && event.shiftKey && DeviceType.getType() == DeviceType.DESKTOP)
			{
				DialogMgr.instance.open(GmView);
			}
		}


		private function onClose(e : flash.events.Event) : void
		{
			DataEyeManger.instance.loginOut();
			AccountManager.instance.exit();
			LocalShareManager.getInstance().cacheSaveData();
		}
	}
}
