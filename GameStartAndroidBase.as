package
{
	import com.utils.Constants;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import game.data.ConfigData;
	import game.uils.Config;
	import game.uils.LoaderManger;
	import game.uils.TweenLite;
	
	import sdk.AccountManager;

	/**
	 * 安卓平台基类
	 * @author hyy
	 *
	 */
	public class GameStartAndroidBase extends Sprite
	{
		protected var isFlashScreen : Boolean;

		/**
		 *
		 * @param device	    平台类型
		 * @param device_class平台驱动
		 * @param isFlashScreen    是否需要闪屏
		 *
		 */
		public function GameStartAndroidBase(device : String, device_class : Class, isFlashScreen : Boolean = false)
		{
			this.isFlashScreen = isFlashScreen;
			//平台
			Config.device = device;
			//平台驱动
			AccountManager.curr_device_class = device_class;
			addEventListener(flash.events.Event.ADDED_TO_STAGE, onAdd);
		}

		private function onAdd(evt : flash.events.Event) : void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAdd);

			stage.color = 0x111111;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			Constants.frameRate = this.stage.frameRate = 24;

			Constants.scale = stage.fullScreenHeight / Constants.standardHeight;
			Constants.scale_x = stage.fullScreenWidth / Constants.standardWidth;
			Constants.virtualHeight = stage.fullScreenHeight / Constants.scale;
			Constants.virtualWidth = stage.fullScreenWidth / Constants.scale;
			Constants.isScaleWidth = stage.fullScreenWidth / stage.fullScreenHeight < 960 / 640

			if (!isFlashScreen)
			{
				changeYingxiong();
			}
			else
			{
				LoaderManger.loadImage("dev_flash" + "/" + Config.device + "/" + Config.device + ".png", onComplement);
			}
		}

		private function onComplement(data : Bitmap) : void
		{
			data.scaleX = data.scaleY = Constants.scale;
			data.alpha = 0;
			addChild(data);
			TweenLite.to(data, 1, {alpha: 1, onComplete: showOnComplete});

			function showOnComplete() : void
			{
				TweenLite.to(data, 1, {alpha: 0.1, delay: 0.5, onComplete: hideOnComplete});
			}

			function hideOnComplete() : void
			{
				data.parent.removeChild(data);
				data.bitmapData.dispose();
				changeYingxiong();
			}
		}

		public function updateVersion(version : int) : void
		{
			ConfigData.data_version = version;
		}
		
		public function updateSwf(swf : String) : void
		{
			Config.swf_type = swf;
		}
		
		protected function changeYingxiong() : void
		{
			addChild(new yingxiong());
		}

	}
}