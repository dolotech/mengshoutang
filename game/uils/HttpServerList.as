package game.uils
{
	import com.components.RollTips;
	import com.dialog.DialogMgr;
	import com.langue.Langue;
	import com.scene.SceneMgr;
	import com.utils.Constants;
	import com.view.base.event.EventType;
	import com.view.base.event.ViewDispatcher;
	
	import flash.desktop.NativeApplication;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getTimer;
	
	import game.dialog.MsgDialog;
	import game.dialog.ShowLoader;
	import game.scene.UpdateGameScene;
	import game.view.userLog.data.ServerInfoData;
	
	import sdk.AccountManager;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;


	/**
	 * 请求服务器列表
	 * @author hyy
	 *
	 */
	public class HttpServerList
	{
		/**
		 * 服务器列表
		 */
		public static var list_server : Array = [];
		/**
		 * 登陆过的服务器列表
		 */
		public static var list_login : Array;
		/**
		 * 更新游戏数据地址
		 */
		public static var update_data_url : String = null;
		private static var instance : HttpServerList;
		private var curr_time : int;
		private var delayCall : IAnimatable;
		private var type : String;

		public static const GET_LIST : String = "1";
		public static const GET_LOGIN : String = "2";
//		private var ip : String = "http://42.62.14.78";
		private var ip : String = "http://211.72.249.246";

		public static function getInstance() : HttpServerList
		{
			if (instance == null)
				instance = new HttpServerList();
			return instance;
		}

		public function HttpServerList()
		{
			if (Constants.WINDOWS)
				ip = "http://42.121.111.191";
//			Config.device = Config.ios;
		}

		public function getServerList() : void
		{
			curr_time = getTimer();
			type = GET_LIST;
			ShowLoader.add(Langue.getLangue("connect"));
			delayCall = Starling.juggler.delayCall(timeoutFunction, 15);
			sendVersion();
		}

		private function sendVersion() : void
		{
			//版本号
			var ns : Namespace = NativeApplication.nativeApplication.applicationDescriptor.namespace();
			var version : String = NativeApplication.nativeApplication.applicationDescriptor.ns::versionNumber;
			var server_url : String = ip + "/mst/servers.php";
			HttpClient.send(server_url, {"v": version, "p": Config.device}, onComplement, timeoutFunction);

			function onComplement(obj : Object) : void
			{
				list_server.length = 0;
				var list : Array = String(obj).split("\n");
				var serverData : ServerInfoData;
				var fields : Array;
				var len : int = list.length;

				for (var i : int = 0; i < len; i++)
				{
					fields = list[i].split("|");

					if (fields.length == 6)
					{
						serverData = new ServerInfoData();
						serverData.name = fields[0];
						serverData.sid = fields[1];
						serverData.ip = fields[2];
						serverData.port = fields[3];
						serverData.status = fields[4];
						serverData.des = fields[5];
						list_server.push(serverData);
					}
				}
				list_server.sortOn("sid", Array.NUMERIC);

				okNofify();
			}
		}

		/**
		 * 超时处理
		 *
		 */
		private function timeoutFunction(obj : Object = null) : void
		{
			if (obj == null || getTimer() - curr_time >= 10000)
			{
				failNofify();
			}
		}

		/**
		 * 登陆检测
		 * @param okFun
		 * @param failFun
		 *
		 */
		public function checkLoginStatus() : void
		{
			curr_time = getTimer();
			type = GET_LOGIN;
			delayCall = Starling.juggler.delayCall(timeoutFunction, 20);
			sendLogin();
		}

		private function sendLogin() : void
		{
			//版本号
			var ns : Namespace = NativeApplication.nativeApplication.applicationDescriptor.namespace();
			var version : String = NativeApplication.nativeApplication.applicationDescriptor.ns::versionNumber;
			var server_url : String = ip + "/mst/check.php";
			HttpClient.send(server_url, {"v": version, "p": Config.device, "s": Constants.SID}, onComplement, timeoutFunction);

			function onComplement(obj : Object) : void
			{
				var tmp_arr : Array = String(obj).split("|");

				switch (tmp_arr[0])
				{
					//正常响应
					case "ok":
						okNofify();
						break;
					//错误信息
					case "error":
						DialogMgr.instance.open(MsgDialog, tmp_arr[1], onGetHttpMsg);
						function onGetHttpMsg() : void
					{
						HttpServerList.list_login = null;
						HttpServerList.getInstance().getServerList();
					}
						break;
					//停服维护
					case "close":
						failNofify();
						RollTips.add(tmp_arr[1]);
						break;
					//更新游戏
					case "update_game":
						//客户端检测是否更新
						if (Config.checkUpdate)
						{
							ShowLoader.remove();

							if (Constants.iOS)
							{
								DialogMgr.instance.open(MsgDialog, Langue.getLangue("GAME_UPDATE"), onOk);

								function onOk(param : Object) : void
								{
									navigateToURL(new URLRequest(tmp_arr[1]), "_blank");
									AccountManager.instance.exitApp();
								}

							}
							else
							{
								SceneMgr.instance.changeScene(UpdateGameScene, tmp_arr[1]);
							}
						}
						else
							okNofify();
						break;
				}
			}
		}

		/**
		 * 成功
		 *
		 */
		private function okNofify() : void
		{
			if (instance)
			{
				dispose();
				ViewDispatcher.dispatch(EventType.GET_SERVER_LIST_OK, type);
			}
		}

		/**
		 * 失败
		 *
		 */
		private function failNofify() : void
		{
			if (instance)
			{
				dispose();
				ShowLoader.remove();
				RollTips.showTips("connect_out");
				ViewDispatcher.dispatch(EventType.GET_SERVER_LIST_FAIL, type);
			}
		}

		public function dispose() : void
		{
			Starling.juggler.remove(delayCall);
			instance = null;
		}
	}
}