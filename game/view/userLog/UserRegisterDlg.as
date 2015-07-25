package game.view.userLog
{
	import com.utils.StringUtil;

	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.SoftKeyboardType;

	import feathers.controls.TextInput;
	import feathers.events.FeathersEventType;

	import game.net.message.ConnectMessage;
	import game.uils.Config;
	import game.view.viewBase.UserRegisterDlgBase;

	import sdk.android.DAndroidHttpServer;

	import starling.events.Event;

	/**
	 * 注册
	 * @author hyy
	 *
	 */
	public class UserRegisterDlg extends UserRegisterDlgBase
	{
		private const inputTextArr : Array = ["input_user", "input_pwd1", "input_pwd2"];
		private var defaultUserTips : String = "inputUser0";
		private var canRegister : Boolean = false;
		private var regex : RegExp = new RegExp("^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$");

		public function UserRegisterDlg()
		{
			super();
		}


		override protected function init() : void
		{
			if (Config.device == Config.android)
				defaultUserTips = "inputMail";
			_closeButton = btn_cancel;
			txt_tip.text = getLangue("userRule");

			input_user.softKeyboardType = Config.device == Config.android ? SoftKeyboardType.CONTACT : SoftKeyboardType.EMAIL;
			input_pwd1.softKeyboardType = input_pwd2.softKeyboardType = SoftKeyboardType.NUMBER;

			input_pwd2.restrict = input_pwd1.restrict = input_user.restrict = "0-9a-zA-Z@."
			input_pwd2.maxChars = input_pwd1.maxChars = input_user.maxChars = 30;
			input_user.text = getLangue(defaultUserTips);
			input_pwd1.text = getLangue("inputUser1");
			input_pwd2.text = getLangue("inputUser2");
			btn_ok.textBounds = new Rectangle(0, 10, btn_ok.width, btn_ok.height);
			btn_cancel.textBounds = new Rectangle(0, 10, btn_cancel.width, btn_cancel.height);

			if (Config.device == Config.android)
			{
				txt_tip.text = getLangue("userRule1");
				txt_tip.hAlign = 'left';
				txt_tip.height = 20;
				txt_tip.x += 10;
			}
		}

		override protected function addListenerHandler() : void
		{
			super.addListenerHandler();
			this.addViewListener(input_user, FeathersEventType.FOCUS_IN, onGetFocusIn);
			this.addViewListener(input_pwd1, FeathersEventType.FOCUS_IN, onGetFocusIn);
			this.addViewListener(input_pwd2, FeathersEventType.FOCUS_IN, onGetFocusIn);
			this.addViewListener(input_user, FeathersEventType.FOCUS_OUT, onGetFocusIn);
			this.addViewListener(input_pwd1, FeathersEventType.FOCUS_OUT, onGetFocusIn);
			this.addViewListener(input_pwd2, FeathersEventType.FOCUS_OUT, onGetFocusIn);
			this.addViewListener(input_user, Event.CHANGE, onInputChange);
			this.addViewListener(input_pwd1, Event.CHANGE, onInputChange);
			this.addViewListener(input_pwd2, Event.CHANGE, onInputChange);
			this.addViewListener(btn_ok, Event.TRIGGERED, onOkClick);
		}

		override protected function show() : void
		{
			setToCenter();
			onInputChange();
		}

		/**
		 * 文本获得焦点
		 * @param evt
		 *
		 */
		private function onGetFocusIn(evt : Event) : void
		{
			var inputText : String;
			var input : TextInput = evt.target as TextInput;

			switch (evt.target)
			{
				case input_user:
					inputText = getLangue(defaultUserTips);
					break;
				case input_pwd1:
					inputText = getLangue("inputUser1");
					break;
				case input_pwd2:
					inputText = getLangue("inputUser2");
					break;
			}

			if (evt.type == FeathersEventType.FOCUS_IN)
			{
				if (input.text == inputText)
					input.text = "";
				input.selectRange(0, input.text.length);
				input.setFocus();
			}
			else if (evt.type == FeathersEventType.FOCUS_OUT && input.text == "")
			{
				input.text = inputText;
			}
		}

		/**
		 * 文本改变
		 *
		 */
		private function onInputChange() : void
		{
			var input : TextInput;
			var tips : String = "";
			canRegister = true;
			tips = "";

			for (var i : int = 0; i < 3; i++)
			{
				input = this[inputTextArr[i]];
				input.text = StringUtil.trim(input.text);

				if (!Capabilities.isDebugger && input.text.length < 6)
					tips = getLangue("passwordRule");
				this["tag" + i].visible = input.text != getLangue("inputUser" + i);
				this["tag" + i].texture = getTexture("ui_yonghuzhuce_yuanquan" + (tips ? 1 : 2));
			}

			if (tips == "")
			{
				if (input_pwd1.text != getLangue("inputUser1") && input_pwd2.text != getLangue("inputUser2"))
				{
					if (input_pwd1.text != input_pwd2.text)
						tips = getLangue("passwordNoMatch");
					this["tag2"].texture = this["tag1"].texture = getTexture("ui_yonghuzhuce_yuanquan" + (tips ? 1 : 2));
				}
				else
				{
					canRegister = false;
				}
			}

			//验证邮箱
			if (Config.device == Config.android && input_user.text != getLangue(defaultUserTips) && !regex.test(input_user.text))
			{
				tips = getLangue("notinputMail");
			}

			if (tips != "")
				canRegister = false;
			txt_error.text = tips;
		}

		/**
		 * 注册
		 *
		 */
		private function onOkClick(evt : Event) : void
		{
			onInputChange();

			if (!canRegister)
				return;

			var account : String = input_user.text.toLocaleLowerCase();
			var password : String = input_pwd1.text.toLocaleLowerCase();

			if (Config.device == Config.android)
			{
				ConnectMessage.isDeviceLogin = true;
				DAndroidHttpServer.getInstance().register(account, password, onReturnHandler);
			}
			else
			{
				onReturnHandler();
			}

			function onReturnHandler() : void
			{
				ConnectMessage.sendRegisterHandler(account, password);
			}
		}

		override public function dispose() : void
		{
			super.dispose();
		}
	}
}