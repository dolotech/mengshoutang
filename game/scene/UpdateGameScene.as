package game.scene
{
	import com.dialog.DialogMgr;
	import com.freshplanet.nativeExtensions.AirNetworkInfo;
	import com.scene.BaseScene;
	import com.test.ane.gongdong.platform.UpdateExtensionEvent;
	import com.test.ane.gongdong.platform.WoLunAne;
	import com.utils.Assets;
	import com.utils.Constants;
	
	import flash.display.Bitmap;
	import flash.utils.getTimer;
	
	import game.data.Val;
	import game.dialog.ShowLoader;
	import game.hero.AnimationCreator;
	import game.manager.AssetMgr;
	
	import sdk.AccountManager;
	
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import treefortress.spriter.SpriterClip;

	/**
	 * 更新游戏场景
	 * @author hyy
	 *
	 */
	public class UpdateGameScene extends BaseScene
	{
		private var progressbar : SpriterClip;
		private var titleTxt : TextField;
		private var ratio : int;
		private var image : Image;
		private var url : String;
		private var last_prossId : int = 0;
		private var total_k : int = 0;
		private var curr_k : int = 0;
		private var time : int = 0;

		public function UpdateGameScene(isAutoInit : Boolean = true)
		{
			super(isAutoInit);
		}

		override protected function init() : void
		{
			progressbar = AnimationCreator.instance.create("progressbar_home", AssetMgr.instance);

			titleTxt = new TextField(600, 40, '', '', 20, 0xffffff, false);
			titleTxt.touchable = false;
			titleTxt.hAlign = 'center';

			addQuiackChild(progressbar);
			addQuiackChild(titleTxt);
			addBg(Assets.Logo_IMAGE);
			DialogMgr.instance.closeAllDialog();
			ShowLoader.remove();
			setRatio(1, "");
		}

		override public function set data(value : Object) : void
		{
			url = String(value);
		}


		override protected function show() : void
		{
			if (!AirNetworkInfo.networkInfo.isConnectedWithWIFI())
				AccountManager.instance.showAlert(Val.LOAD_NO_WIFT, startUpdate, Val.GOTO, AccountManager.instance.exitApp, Val.exit);
			else
				startUpdate();
		}

		private function startUpdate() : void
		{
			last_prossId = curr_k = total_k = time = 0;
			WoLunAne.testProxy.addEventListener(UpdateExtensionEvent.UPDATE_CUONT_RECEIVED, onUpdateHandler);
			WoLunAne.testProxy.init(url, url.split("/").pop());
		}

		protected function onUpdateHandler(event : UpdateExtensionEvent) : void
		{
			//下载失败
			if (event.updateFlag || !AirNetworkInfo.networkInfo.isConnected())
			{
				AccountManager.instance.showAlert("下载失败,是否从新更新?", okHander, Val.OK, AccountManager.instance.exitApp, Val.exit);

				function okHander() : void
				{
					ratio = 0;
					delayCall(show, 0.5);
				}
				return;
			}
			total_k += event.prossId - last_prossId;
			last_prossId = event.prossId;

			if (time == 0 || getTimer() - time >= 1000)
			{
				time = getTimer();
				curr_k = total_k / 1024;
				total_k = 0;
			}

			setRatio(event.prossId / event.cuontLength * 100, Number(event.prossId / 1024 / 1024).toFixed(1) + "M/" + Number(event.cuontLength / 1024 / 1024).toFixed(1) + "M");

//			if (event.prossId >= event.cuontLength)
//			{
//				AccountManager.instance.showAlert("更新成功!", NativeApplication.nativeApplication.exit, Val.OK);
//			}
		}
		/**
		 * 加载背景资源
		 * @param bitmap
		 *
		 */
		private var bg_height : int;

		public function addBg(bitmap : Bitmap) : void
		{
			image = new Image(Texture.fromBitmap(bitmap));
			addQuiackChild(image);

			image.x = bitmap.x / Constants.scale;
			image.y = bitmap.y / Constants.scale;

			bg_height = image.height;
			Constants.setToStageCenter(titleTxt);
			titleTxt.y = image.y + bg_height + 60 / Constants.scale;

			if (bitmap.parent)
				bitmap.parent.removeChild(bitmap);
		}

		private function setRatio(value : int, des : String) : void
		{
			text = getLangue("update_loader") + des + "  " + (curr_k > 0 ? curr_k + "k/bs" : "");

			if (value <= ratio)
				return;
			ratio = value;
			progressbar.play("progressbar_home");
			progressbar.update(progressbar.animation.length * (value - 1) / 100);
			progressbar.stop();
			Constants.setXToStageCenter(progressbar);
			progressbar.y = image.y + bg_height + 20 / Constants.scale;
		}

		public function set text(value : String) : void
		{
			titleTxt.text = value;
		}

		override public function dispose() : void
		{
			super.dispose();
			titleTxt.dispose();
			progressbar.dispose();
			image && image.texture.dispose();
			image.dispose();
		}
	}
}
