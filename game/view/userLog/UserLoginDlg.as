package game.view.userLog
{
	import com.dialog.DialogMgr;
	import com.langue.Langue;
	import com.utils.Constants;
	import com.utils.StringUtil;

	import flash.geom.Rectangle;
	import flash.text.SoftKeyboardType;

	import feathers.controls.TextInput;

	import game.dialog.MsgDialog;
	import game.dialog.ShowLoader;
	import game.net.GameSocket;
	import game.net.data.s.SXYLMLogin;
	import game.net.message.ConnectMessage;
	import game.uils.Config;
	import game.uils.LocalShareManager;

	import sdk.android.DAndroidHttpServer;

	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 *
	 * 登录
	 * @author hyy
	 *
	 */
	public class UserLoginDlg extends UserLoginDlgBase
	{
		public static var isAutoLogin : Boolean = false;

		public function UserLoginDlg()
		{
			super();
			init();
		}
		private var userInput : TextInput;
		private var psw1Input : TextInput;
		private var inputUser : Input;
		private var inputPsw1 : Input;

		override protected function init() : void
		{
			userInput = new TextInput;
			psw1Input = new TextInput;

			userInput.backgroundSkin = userImage;
			psw1Input.backgroundSkin = passwordImage;
			addChild(userInput);
			addChild(psw1Input);

			inputUser = new Input;
			inputPsw1 = new Input;

			inputUser.isPassword = false;
			inputUser.passMatch = false;
			inputUser.defaultText = Langue.getLangue("inputUser0");
			inputUser.input = userInput;
			inputUser.showDefaultText = true;
			inputUser.StartFactory();


			inputPsw1.isPassword = false;
			inputPsw1.defaultText = Langue.getLangue("inputUser1");
			inputPsw1.input = psw1Input;
			inputPsw1.showDefaultText = true;
			inputPsw1.StartFactory();

			var gap : int = 5;
			userInput.paddingLeft = gap;
			userInput.paddingTop = gap;
			psw1Input.paddingLeft = gap;
			psw1Input.paddingTop = gap;

			//设置输入文本的位置
			setPostion(userInput, userImage);
			setPostion(psw1Input, passwordImage);
			setPostion(userImage, this);
			setPostion(passwordImage, this);
			
			userInput.softKeyboardType = Config.device == Config.android ? SoftKeyboardType.CONTACT : SoftKeyboardType.EMAIL;
			psw1Input.softKeyboardType = SoftKeyboardType.NUMBER;
			var str : String = LocalShareManager.getInstance().get(LocalShareManager.USER_PWD);

			if (str != null)
			{
				var arr : Array = str.split(":");
				var user : String = arr[0];
				var password : String = arr[1];
				userInput.text = user;
				psw1Input.text = password;
			}

			psw1Input.textEditorProperties.displayAsPassword = true;

			if (isAutoLogin)
			{
				isAutoLogin = false;
				onLogin(null);
			}
		}

		override protected function show() : void
		{
			userTitleTxt.text = Langue.getLangue("userLoginTitle");
			backButton.text = Langue.getLangue("quit");
			okButton.text = Langue.getLangue("OK");
			var size : int = 32;
			var color : uint = 0xffffcc;
			backButton.fontColor = color;
			okButton.fontColor = color;
			backButton.fontSize = size;
			okButton.fontSize = size;
			var rect : Rectangle = new Rectangle(34, 45, 120, 30);
			backButton.textBounds = rect;
			okButton.textBounds = rect;

			backButton.addEventListener(Event.TRIGGERED, onBack);
			okButton.addEventListener(Event.TRIGGERED, onLogin);
			lostPasswordButton.addEventListener(Event.TRIGGERED, onLostPassWord);
			setToCenter();
		}

		override protected function addListenerHandler() : void
		{
			this.addContextListener(SXYLMLogin.CMD + "", mesaageNotification);
		}

		private function mesaageNotification(evt : Event, info : SXYLMLogin) : void
		{
			switch (info.status)
			{
				//21=帐号不存在
				case 21:
					userTipTxt.text = getLangue("securityCodeNoAcount");
					userTipTxt.color = 0xff0000;
					ShowLoader.remove();
					break;
				//22=帐号或密码不正确
				case 22:
					userTipTxt.text = Langue.getLangue("pswUserError");
					userTipTxt.color = 0xff0000;
					ShowLoader.remove();
					break;
			}
		}

		private function setPostion(current : DisplayObject, target : DisplayObject) : void
		{
			current.x = target.x;
			current.y = target.y;
		}

		private function onLostPassWord(e : Event) : void
		{
			DialogMgr.instance.open(GetBackPasswordVerificationCodeDlg);
			close();
		}

		private function onLogin(e : Event) : void
		{
			if (!(inputUser.findText()))
			{
				userTipTxt.text = Langue.getLangue("userNotNull");
				userTipTxt.color = 0xff0000;
				return;
			}
			else if (!(inputPsw1.findText()))
			{
				userTipTxt.text = Langue.getLangue("passwordNotNull");
				userTipTxt.color = 0xff0000;
				return;
			}

			//点击登录，没有连接服务器的话重新连接
			if (!GameSocket.instance.connected)
			{
				DialogMgr.instance.open(MsgDialog, Langue.getLangue("connect_again"));
				return;
			}

			Constants.username = StringUtil.trim(userInput.text.toLocaleLowerCase());
			Constants.password = StringUtil.trim(psw1Input.text.toLocaleLowerCase());

			if (Config.device == Config.android)
			{
				ConnectMessage.isDeviceLogin = true;
				DAndroidHttpServer.getInstance().login(Constants.username, Constants.password, onReturnHandler);

				function onReturnHandler() : void
				{
					ConnectMessage.sendRegisterHandler(Constants.username, Constants.password);
				}
			}
			else
			{
				ConnectMessage.login();
			}
		}

		private function onBack(e : Event) : void
		{
			close();
			DialogMgr.instance.open(SelectServerDlg);
		}
	}
}