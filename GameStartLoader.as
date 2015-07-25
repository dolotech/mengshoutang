package
{
	import com.freshplanet.ane.AirAlert.AirAlert;
	import com.mobileLib.utils.ConverURL;
	import com.mobileLib.utils.DeviceType;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import game.uils.Config;
	import game.uils.HttpClient;
	import game.uils.LoaderManger;
	
	import sdk.AccountManager;

	public class GameStartLoader extends Sprite
	{
		// 加载转圈圈图标
		[Embed(source="../assets_mst/loading_circle.png")]
		public static var LoadingICO : Class;
		private var loader_img : Bitmap;
		private var loader_container : Sprite;

		private var swf_type : String;
		private var loader : Loader;
		private var device : String;
		/**
		 * 打包的时候，数据的版本信息，用于删除以前更新遗留在缓存的数据
		 */
		private const curr_version : int = 1;
		private var version_data : int;

		public function GameStartLoader()
		{
			super();
			device = Config.android; //平台
			swf_type = "GameStartAndroid.swf"; //swf
			addEventListener(flash.events.Event.ADDED_TO_STAGE, onAdd);
		}

		private function onAdd(evt : flash.events.Event) : void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAdd);
			stage.color = 0x111111;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;

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
			startLoaderMainSwf();
		}

		protected function onEnterFrame(event : Event) : void
		{
			loader_container.rotation += 10;
		}

		private function startLoaderMainSwf() : void
		{
			//加载本地更新文件
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
				version_data = tmp_list.shift();

				if (version_data <= curr_version && File.applicationStorageDirectory.resolvePath("update.txt").exists)
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
					HttpClient.send(server_url, {"p": device, "v": version, "a": version_data}, onServerDownComplement, timeoutFunction);
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
						else
						{
							trace(tmp_arr[1])
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
			var cur_file : File = getFile(swf_type);
			var data : ByteArray = new ByteArray();
			var fileStream : FileStream = new FileStream();
			fileStream.open(cur_file, FileMode.READ);
			fileStream.readBytes(data, 0, fileStream.bytesAvailable);
			fileStream.close();
			var loaderContext : LoaderContext = new LoaderContext();
			loaderContext.allowCodeImport = true;
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadMainComplement);
			loader.loadBytes(data, loaderContext);
		}

		/**
		 * 主程序加载完毕
		 * @param evt
		 *
		 */
		private function onLoadMainComplement(evt : Event) : void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeChild(loader_container);
			loader_container = null;
			loader_img.bitmapData.dispose();
			loader_img = null;
			stage.addChild(loader.content);
			loader.content["updateVersion"](version_data);
			loader.content["updateSwf"](swf_type);
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
			return file.exists ? file : (fileName == swf_type ? File.applicationDirectory.resolvePath(fileName) : ConverURL.conver(fileName));
		}
	}
}