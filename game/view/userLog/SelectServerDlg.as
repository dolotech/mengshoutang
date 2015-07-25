package game.view.userLog
{
	import com.adobe.utils.crypto.MD5;
	import com.dialog.DialogMgr;
	import com.utils.ArrayUtil;
	import com.utils.Constants;
	import com.view.base.event.EventType;

	import game.dialog.ShowLoader;
	import game.net.GameSocket;
	import game.net.message.ConnectMessage;
	import game.uils.Config;
	import game.uils.HttpServerList;
	import game.uils.LocalShareManager;
	import game.view.userLog.data.ServerInfoData;
	import game.view.viewBase.SelectServerDlgBase;

	import sdk.AccountManager;

	import starling.events.Event;

	/**
	 * 选区
	 * @author hyy
	 *
	 */
	public class SelectServerDlg extends SelectServerDlgBase
	{
		private var cur_server : ServerInfoData;
		private var isLogin : Boolean;
		private static var isInit : Boolean = false;

		public function SelectServerDlg()
		{
			super();
		}

		override protected function init() : void
		{
			btn_login.visible = Config.isOpenLoginRegister;

			//特殊处理
			if (Config.device == Config.ios)
			{
				btn_login.visible = true;
			}

			if (Config.device == Config.android)
			{
				btn_registered.text = getLangue("userRegist");
				btn_login.text = getLangue("userLogin");
			}
		}

		override protected function addListenerHandler() : void
		{
			this.addViewListener(btn_bg, Event.TRIGGERED, onChangeServer);
			this.addViewListener(btn_login, Event.TRIGGERED, onOpenLogin);
			this.addViewListener(btn_registered, Event.TRIGGERED, onRegistered);
			this.addViewListener(btn_change, Event.TRIGGERED, onChangeServer);
			this.addContextListener(EventType.SELECTED_SERVER, onSelectedServer);
			this.addContextListener(EventType.AUTO_LOGIN, autoLogin);
			this.addContextListener(EventType.GET_SERVER_LIST_OK, getServerListOK);
			this.addContextListener(EventType.GET_SERVER_LIST_FAIL, connectFail);
		}

		private function onSelectedServer(evt : Event, server : ServerInfoData) : void
		{
			selectedServer(server);
		}

		override protected function show() : void
		{
			setToCenter();
			//请求服务器列表\
			HttpServerList.getInstance().getServerList();
		}

		/**
		 * 请求成功
		 *
		 */
		private function getServerListOK(event : Event, type : String) : void
		{
			switch (type)
			{
				case HttpServerList.GET_LIST:
					updateList();
					break;
				case HttpServerList.GET_LOGIN:
					if (isLogin)
					{
						ConnectMessage.isDeviceLogin = false;
						connect(UserLoginDlg);
					}
					else
					{
						connect(UserRegisterDlg);
					}
					break;
			}
		}

		private function connectFail(event : Event, type : String) : void
		{
			switch (type)
			{
				case HttpServerList.GET_LIST:
					break;
				case HttpServerList.GET_LOGIN:
					break;
			}
		}

		private function updateList() : void
		{
			ShowLoader.remove();
			var list_server : Array = HttpServerList.list_server;
			var list_login : Array = HttpServerList.list_login;

			if (HttpServerList.list_login == null)
			{
				var data : String = LocalShareManager.getInstance().get(LocalShareManager.SERVER, false);
				list_login = [];

				//储存登陆过的服务器SID
				if (data)
				{
					var tmpArr : Array = data.split(",");
					var obj : Object;

					for (var i : int = 0; i < tmpArr.length; i++)
					{
						obj = ArrayUtil.getArrayObjByField(list_server, tmpArr[i], "sid");
						obj && list_login.indexOf(obj) == -1 && list_login.push(obj);
					}
				}
				HttpServerList.list_login = list_login;
			}

			//如果以前没有登陆过,默认选择最新的服务器
			if (list_login.length == 0 && list_server.length > 0)
				seclectedCanLoginServer(list_server, list_server.length - 1);
			//最后登陆的服务器，登陆
			else if (list_login.length > 0)
				selectedServer(list_login[0]);

			delayCall(autoLogin, 0.1);
		}

		/**
		 * 登陆的时候如果以前有账号，则直接登陆
		 *
		 */
		private function autoLogin(value : Boolean = true) : void
		{
			if (!isInit && value && Config.isAutoLogin && cur_server)
			{
				isInit = true;

				if (!Config.isOpenLoginRegister)
				{
					onRegistered();
				}
				else if (LocalShareManager.getInstance().get(LocalShareManager.USER_PWD) != null)
				{
					UserLoginDlg.isAutoLogin = true;
					onOpenLogin();
				}
			}
		}

		private function seclectedCanLoginServer(list_server : Array, index : int) : void
		{
			var server : ServerInfoData = list_server[index];

			if (server == null)
				return;

			if (server.status == 3 || server.status == 5)
				seclectedCanLoginServer(list_server, index - 1);
			else
				selectedServer(server);
		}

		/**
		 * 登陆
		 *
		 */
		private function onOpenLogin() : void
		{
			isLogin = true;
			validationServer();
		}

		/**
		 * 注册
		 *
		 */
		private function onRegistered() : void
		{
			isLogin = false;
			validationServer();
		}

		private function connect(dialogCalss : Class) : void
		{
			var list_login : Array = HttpServerList.list_login;
			//先从登陆列表删除
			ArrayUtil.deleteArrayByField(list_login, cur_server.sid, "sid");
			//添加到登陆列表,最新的放第一个
			list_login.splice(0, 0, cur_server);

			//只缓存3个最近登陆过的列表
			if (list_login.length >= 3)
				list_login.length = 3;

			if (GameSocket.instance.connected)
				GameSocket.instance.close(true);

			ConnectMessage.connect(socketConnected);

			function socketConnected(sockt : GameSocket) : void
			{
				ShowLoader.remove();

				if (!Config.isOpenLoginRegister && dialogCalss == UserRegisterDlg)
				{
					deviceLogin();
					return;
				}
				DialogMgr.instance.open(dialogCalss);
			}
		}

		/**
		 * 选区
		 *
		 */
		private function onChangeServer() : void
		{
			DialogMgr.instance.open(ShowServerListDlg);
		}

		/**
		 * 选择一个区
		 * @param server
		 *
		 */
		private function selectedServer(server : ServerInfoData) : void
		{
			if (server == null)
			{
				warn("找不到服务器");
				return
			}
			cur_server = server;
			Constants.IP = server.ip;
			Constants.PORT = server.port;
			Constants.SERVER_NAME = server.name;
			Constants.SID = server.sid;
			txt_servername.text = server.name;
			tag_new.visible = server.status == 4;
			tag_hot.visible = server.status == 2;

			if (server.des != "" && server.des != null)
				addTips(server.des);
		}

		/**
		 * 验证服务器版本号和状态
		 * @return
		 *
		 */
		private function validationServer() : void
		{
			if (cur_server == null)
			{
				addTips("select_server");
				return
			}
			ShowLoader.add(getLangue("login"));
			HttpServerList.getInstance().checkLoginStatus();
		}

		/**
		 * 平台登录
		 *
		 */
		private function deviceLogin() : void
		{
			AccountManager.instance.login(localPlayerAuthenticated, notAuthenticated);
		}

		private function notAuthenticated() : void
		{
			warn("平台", "登陆失败")
			var userId : String = LocalShareManager.getInstance().get(LocalShareManager.GM_USER_PWD, false);
			var pwd : String;

			if (userId != null && (userId.indexOf(Config.device) >= 0 && Config.device == Config.ios))
			{
				userId = userId.split(":")[0];
				pwd = userId.split(":")[1];
				ConnectMessage.isDeviceLogin = true;
				ConnectMessage.sendRegisterHandler(userId, pwd);
				return;
			}
			ShowLoader.remove();

			if (!Constants.ANDROID)
			{
				ConnectMessage.isDeviceLogin = false;
				DialogMgr.instance.open(UserRegisterDlg);
			}
		}

		/**
		 * 登陆成功
		 *
		 */
		private function localPlayerAuthenticated() : void
		{
			ConnectMessage.isDeviceLogin = true;
			var id : String = AccountManager.instance.accountId.replace(":", "");
			ConnectMessage.sendRegisterHandler(id, id);
			warn("平台", "登陆成功")
		}
	}
}