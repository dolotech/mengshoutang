package
{
	import com.freshplanet.ane.AirAlert.AirAlert;
	import com.mobileLib.utils.ConverURL;
	import com.mobileLib.utils.DeviceType;
	import com.utils.Constants;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.text.Font;
	import flash.utils.ByteArray;
	
	import game.data.ConfigData;
	import game.uils.Config;
	import game.uils.HttpClient;
	import game.uils.LoaderManger;
	import game.uils.TweenLite;
	
	import sdk.AccountManager;

	/**
	 * ios平台基类
	 * @author hyy
	 *
	 */
	public class GameStartIosBase extends Sprite
	{
		[Embed(source="../assets_mst/font.TTF", fontName="方正综艺简体", embedAsCFF="false", advancedAntiAliasing="true", mimeType="application/x-font")]
		private var MichaelFont : Class;
		// 加载转圈圈图标
		[Embed(source="../assets_mst/loading_circle.png")]
		public static var LoadingICO : Class;
		private var loader_img : Bitmap;
		private var loader_container : Sprite;
		
		protected var isFlashScreen : Boolean;
		/**
		 * 打包的时候，数据的版本信息，用于删除以前更新遗留在缓存的数据
		 */
		private const curr_version : int = 1;

		/**
		 *
		 * @param device	    平台类型
		 * @param device_class平台驱动
		 * @param isFlashScreen    是否需要闪屏
		 *
		 */
		public function GameStartIosBase(device : String, device_class : Class, isFlashScreen : Boolean = false)
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

			Font.registerFont(MichaelFont);
			stage.color = 0x111111;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			Constants.frameRate = this.stage.frameRate = 24;

			loader_img = new LoadingICO();
			loader_img.scaleX = loader_img.scaleY = stage.fullScreenHeight / 640;
			loader_container = new Sprite();
			loader_container.addChild(loader_img);
			addChild(loader_container);
			loader_img.x = -loader_img.width * .5;
			loader_img.y = -loader_img.height * .5;
			loader_container.x = stage.fullScreenWidth * .5;
			loader_container.y = stage.fullScreenHeight * .5;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			if (!isFlashScreen)
			{
				startLoaderMainSwf();
			}
			else
			{
				LoaderManger.loadImage("dev_flash" + "/" + Config.device + "/" + Config.device + ".png", onComplement);
			}
		}
		
		protected function onEnterFrame(event : Event) : void
		{
			loader_container.rotation += 10;
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
				startLoaderMainSwf();
			}
		}

		private function startLoaderMainSwf() : void
		{
			var tmp_update_data : ByteArray = new ByteArray();
			var fileStream : FileStream = new FileStream();
			fileStream.open(getFile("update.txt"), FileMode.READ);
			fileStream.readBytes(tmp_update_data, 0, fileStream.bytesAvailable);
			fileStream.close();
			onUpdateComplete(tmp_update_data);

			function onUpdateComplete(data : ByteArray, isServerFile : Boolean = false) : void
			{
				var tmp_list : Array = data.readUTFBytes(data.bytesAvailable).split("\r\n");
				//本地版本信息
				ConfigData.data_version = tmp_list.shift();

				if (ConfigData.data_version <= curr_version && File.applicationStorageDirectory.resolvePath("update.txt").exists)
				{
					deleteCacheData(File.applicationStorageDirectory);
					startLoaderMainSwf();
					return;
				}

				//服务器地址
				var server_url : String = tmp_list.shift();

				//开发地址
				if (DeviceType.getType() == DeviceType.DESKTOP)
					server_url = "http://42.121.111.191/mst/check_assets.php";

				//请求是否需要更新文件
				if (isServerFile)
				{
					//需要到服务器下载的文件	
					ConverURL.down_list = tmp_list;
					startLoaderMain();
				}
				else
				{
					checkUpdate();
				}

				//请求是否需要更新文件
				function checkUpdate() : void
				{
					var ns : Namespace = NativeApplication.nativeApplication.applicationDescriptor.namespace();
					var version : String = NativeApplication.nativeApplication.applicationDescriptor.ns::versionNumber
					HttpClient.send(server_url, {"p": Config.device, "v": version, "a": ConfigData.data_version}, onServerDownComplement, timeoutFunction);
				}

				//请求超时
				function timeoutFunction() : void
				{
					AirAlert.getInstance().showAlert("提示", "网络连接失败,请检测你的网络!", "连接", onAlertOk, "退出", onAlertClosed);

					function onAlertOk() : void
					{
						checkUpdate();
					}

					function onAlertClosed() : void
					{
						AccountManager.instance.exitApp();
					}
				}

				//请求成功
				function onServerDownComplement(obj : String) : void
				{
					//不需要更新文件
					if (obj == "ok")
					{
						var len : int = tmp_list.length;
						var update_list : Array = [];
						var update_url : String;
						var tmp_file : File;

						for (var i : int = 0; i < len; i++)
						{
							update_url = tmp_list[i].split(" ")[0];
							tmp_file = File.applicationStorageDirectory.resolvePath(update_url);
							ConverURL.update_dic[tmp_file.name] = tmp_file;
						}

						startLoaderMain();
					}
					else
					{
						var tmp_arr : Array = obj.split("|");

						//需要更新
						if (tmp_arr[0] == "update_assets")
						{
							//更新地址
							ConverURL.down_url = tmp_arr[1];
							LoaderManger.load(ConverURL.down_url + "update.txt" + "?v" + Math.random(), onServerFileComplete);
						}
					}
				}

				function onServerFileComplete(server_data : ByteArray) : void
				{
					onUpdateComplete(server_data, true);
				}
			}
		}

		/**
		 * 开始加载主程序
		 * @param url
		 *
		 */
		private function startLoaderMain() : void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeChild(loader_container);
			loader_container = null;
			loader_img.bitmapData.dispose();
			loader_img = null;
			addChild(new yingxiong());
		}

		/**
		 * 清除缓存数据
		 *
		 */
		private function deleteCacheData(file : File) : void
		{
			var list : Array = file.getDirectoryListing();
			var len : int = list.length;
			var tmp_file : File;

			for (var i : int = 0; i < len; i++)
			{
				tmp_file = list[i];

				if (tmp_file.isDirectory)
					tmp_file.deleteDirectory(true);
				else if (tmp_file.exists)
					tmp_file.deleteFile();
			}
		}

		private function getFile(fileName : String) : File
		{
			var file : File = File.applicationStorageDirectory.resolvePath(fileName);
			return file.exists ? file : ConverURL.conver(fileName);
		}
	}
}