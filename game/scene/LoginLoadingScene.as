package game.scene
{
	import com.adobe.utils.crypto.MD5;
	import com.freshplanet.nativeExtensions.AirNetworkInfo;
	import com.langue.Langue;
	import com.mobileLib.utils.ConverURL;
	import com.scene.BaseScene;
	import com.scene.SceneMgr;
	import com.utils.Assets;
	import com.utils.Constants;
	
	import flash.display.Bitmap;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import game.data.DataDecompress;
	import game.data.Val;
	import game.hero.AnimationCreator;
	import game.manager.AssetMgr;
	import game.uils.Config;
	import game.uils.LoaderManger;
	
	import sdk.AccountManager;
	
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import treefortress.spriter.SpriterClip;

	/**
	 * 登陆加载
	 * @author hyy
	 *
	 */
	public class LoginLoadingScene extends BaseScene
	{
		private var progressbar : SpriterClip;
		private var titleTxt : TextField;
		private var ratio : int;
		private var image : Image;

		public function LoginLoadingScene(isAutoInit : Boolean = true)
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
		}

		override protected function show() : void
		{
			if (!AirNetworkInfo.networkInfo.isConnected())
			{
				AccountManager.instance.showAlert(Val.NET_CONNECT_ERROR, AccountManager.instance.exitApp, Val.exit);
				text = Val.NET_CONNECT_ERROR;
				return;
			}

			if (Constants.WINDOWS)
			{
//				DAndroidHttpServer.getInstance().getSession();
//				Config.device = Config.android;
				Config.device = Config.windows;
			}

			//是否显示登陆/注册界面
			if (Config.device == Config.android || Config.device == Config.windows || Config.device == Config.android_kp)
				Config.isOpenLoginRegister = true;


			//需要去服务器下载文件
			if (ConverURL.down_list && ConverURL.down_list.length > 0)
			{
				setRatio(100);
				text = "正在检测更新文件..请稍等!";
				delayCall(checkUpdateFile, 0.1);
			}
			else
			{
				gameAssetsLoader();
			}
		}


		/**
		 * 检测是否需要更新文件
		 *
		 */
		private function checkUpdateFile() : void
		{
			var update_list : Array = [];
			var tmp_list : Array = [].concat(ConverURL.down_list);
			var len : int = tmp_list.length;
			var fileArr : Array;
			var tmp_file : File;
			ConverURL.down_list = update_list;

			for (var i : int = 0; i < len; i++)
			{
				fileArr = tmp_list[i].split(" ");

				if (fileArr.length == 2 && fileArr[1] != getFileMd5(fileArr[0]))
				{
					tmp_file = File.applicationStorageDirectory.resolvePath(fileArr[0]);
					ConverURL.update_dic[tmp_file.name] = tmp_file;
					update_list.push(fileArr[0]);
				}
			}

			//当先下载不保存，还需要添加到下载列表里面，等所有文件更新完毕再保存文件
			update_list.push("update.txt");
			ratio = 0;

			//是否在wifi下更新
			if (AirNetworkInfo.networkInfo.isConnectedWithWIFI())
			{
				startLoader();
			}
			else if (Constants.WINDOWS)
			{
				startLoader();
			}
			else
			{
				AccountManager.instance.showAlert(Val.LOAD_NO_WIFT, startLoader, Val.GOTO, AccountManager.instance.exitApp, Val.exit);
			}

			function startLoader() : void
			{
				LoaderManger.startLoaderAndSave(ConverURL.down_url, update_list, gameAssetsLoader, setServerRatio, onServerDownError);
			}
		}

		private var total_k : int = 0;
		private var curr_k : int = 0;
		private var time : int = 0;

		private function setServerRatio(value : int, k : int, des : String) : void
		{
			total_k += k;

			if (value == 101)
			{
				text = des;
				return;
			}

			if (time == 0 || getTimer() - time >= 1000)
			{
				time = getTimer();
				text = Val.loader_server + total_k + "/k    " + des;
				curr_k = total_k;
				total_k = 0;
			}

			if (value == ratio)
				return;
			ratio = value;
			progressbar.play("progressbar_home");
			progressbar.update(progressbar.animation.length * value / 100);
			progressbar.stop();
			text = Val.loader_server + curr_k + "/k    " + des;
			Constants.setXToStageCenter(progressbar);
			progressbar.y = image.y + bg_height + 20 / Constants.scale;
		}

		private function onServerDownError() : void
		{
			AccountManager.instance.showAlert("加载文件失败，请重新启动游戏！", AccountManager.instance.exitApp, "退出");
		}

		/**
		 * 开始加载游戏资源
		 *
		 */
		private function gameAssetsLoader() : void
		{
			//如果更新了主程序，则退出游戏
			if (ConverURL.down_list && ConverURL.down_list.indexOf(Config.swf_type) >= 0)
			{
				AccountManager.instance.showAlert(Val.close_app, AccountManager.instance.exitApp, "退出");
				return;
			}

			ratio = 0;

			//除了ios,需要添加字体库
			!Constants.iOS && AssetMgr.instance.enqueue(ConverURL.conver("font/"));
			AssetMgr.instance.enqueue(ConverURL.conver("data.dat"), ConverURL.conver("audio/"), ConverURL.conver("loginUi/"), ConverURL.conver("other"));
			AssetMgr.instance.loadQueue(onComplete);

			function onComplete(tmp_ratio : Number) : void
			{
				setRatio(tmp_ratio * 100);

				if (tmp_ratio == 1.0)
				{
					System.pauseForGCIfCollectionImminent(0);
					System.gc();
					setRatio(100);
					Langue.init(AssetMgr.instance.getXml("languagepack"));
					DataDecompress.instance.decompress(AssetMgr.instance.getByteArray("data"));
					AccountManager.instance.init();
					Config.parseXml(AssetMgr.instance.getXml("config"));
					SceneMgr.instance.changeScene(LoginScene);
				}
			}
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

		private function setRatio(value : int) : void
		{
			if (value <= ratio)
				return;
			ratio = value;
			progressbar.play("progressbar_home");
			progressbar.update(progressbar.animation.length * (value - 1) / 100);
			progressbar.stop();
			text = Val.loader + value + "%";
			Constants.setXToStageCenter(progressbar);
			progressbar.y = image.y + bg_height + 20 / Constants.scale;
		}

		public function set text(value : String) : void
		{
			titleTxt.text = value;
		}

		private function getFile(fileName : String) : File
		{
			var file : File = File.applicationStorageDirectory.resolvePath(fileName);
			return file.exists ? file : (fileName == Config.swf_type ? File.applicationDirectory.resolvePath(fileName) : ConverURL.conver(fileName));
		}

		/**
		 * 检测MD5
		 * @param fileName
		 * @return
		 *
		 */
		private function getFileMd5(fileName : String) : String
		{
			var cur_file : File = getFile(fileName);

			if (!cur_file.exists)
				return null;
			var data : ByteArray = new ByteArray();
			var fileStream : FileStream = new FileStream();
			fileStream.open(cur_file, FileMode.READ);
			fileStream.readBytes(data, 0, fileStream.bytesAvailable);
			fileStream.close();
			var md5 : String = MD5.hashBinary(data);
			data.clear();
			return md5;
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