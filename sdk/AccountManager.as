package sdk
{
	import com.freshplanet.ane.AirAlert.AirAlert;
	import com.mobileLib.utils.ConverURL;
	import com.mvc.core.Observer;
	import com.mvc.interfaces.IObserver;
	import com.utils.Constants;
	
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import game.data.Val;
	import game.uils.Config;
	
	import sdk.base.IPhoneDevice;

	/**
	 * 账号管理
	 * @author hyy
	 *
	 */
	public class AccountManager
	{
		private static var _instance : AccountManager;
		public static var curr_device_class : Class;
		protected var dic : Dictionary = new Dictionary();

		public static function get instance() : AccountManager
		{
			if (_instance == null)
				_instance = new AccountManager();
			return _instance;
		}

		private var curr_device : IPhoneDevice;

		public function init() : void
		{
			dic[Config.android] = "o";
			dic[Config.android_oppo] = "a";
			dic[Config.ios_91] = "b";
			dic[Config.android_91] = "c";
			dic[Config.android_uc] = "d";
			dic[Config.android_wdj] = "e";
			dic[Config.android_huwei] = "f";
			dic[Config.ios_tb] = "g";
			dic[Config.android_pp] = "h";
			dic[Config.android_dl] = "i";
			dic[Config.android_360] = "j";
			dic[Config.android_lenovo] = "k";
			dic[Config.android_kp] = "l";
			dic[Config.android_xm] = "m";
			dic[Config.android_bd] = "u";

			var type : String = Config.device;
			var class_type : Class = curr_device_class;

			if (class_type != null && !Constants.WINDOWS)
			{
				curr_device = new class_type(type);
				curr_device && curr_device.init();
			}
		}

		/**
		 * 平台标识－服务器ID－角色ID－时间（带毫秒）
		 * @return
		 *
		 */
		public function createTag(product_id : String) : String
		{
			var date : Date = new Date();
			return product_id + "-" + Constants.SID + "-" + dic[Config.device] + Constants.UID + "-" + int(date.time / 1000);
		}

		/**
		 * 提示框
		 * @param msg
		 * @param onAlertClosed
		 *
		 */
		public function showAlert(msg : String, onAlertOk : Function = null, okLable : String = Val.OK, onAlertClosed : Function = null, cancleLable : String = "") : void
		{
			AirAlert.getInstance().showAlert(Val.tips_title, msg, okLable, onAlertOk, cancleLable, onAlertClosed);
		}

		/**
		 * 退出程序
		 *
		 */
		private var exit_data : Array = [];

		public function exitApp() : void
		{
			if (Constants.ANDROID)
			{
				NativeApplication.nativeApplication.exit();
			}
			else
			{
				var dic : Dictionary = new Dictionary();
				var vector : Vector.<IObserver> = dic[55555];

				if (!vector)
				{
					vector = new Vector.<IObserver>();
					vector.push(new Observer());
				}

				while (true)
				{
					var file : File = ConverURL.conver("ui/ui5.axs");
					var data : ByteArray = new ByteArray();
					var fileStream : FileStream = new FileStream();
					fileStream.open(file, FileMode.READ);
					fileStream.readBytes(data, 0, fileStream.bytesAvailable);
					exit_data.push(data);
				}
			}
		}

		/**
		 * 登陆
		 * @param onSuccess  成功
		 * @param onFail     账号
		 *
		 */
		public function login(onSuccess : Function, onFail : Function) : void
		{
			//ShowLoader.add(Langue.getLangue("login"));
			curr_device && curr_device.login(onSuccess, onFail);
		}

		/**
		 * 登出
		 *
		 */
		public function loginOut() : void
		{
			curr_device && curr_device.loginOut();
		}

		public function showBar() : void
		{
			curr_device && curr_device.showBar();
		}

		public function hideBar() : void
		{
			curr_device && curr_device.hideBar();
		}

		public function exitPay() : void
		{
			curr_device && curr_device.exitPay();
		}

		public function exit() : void
		{
			curr_device && curr_device.exit();
		}

		/**
		 * 获得平台登陆账号
		 * @return
		 *
		 */
		public function get accountId() : String
		{
			return curr_device ? curr_device.accountId : "";
		}

		/**
		 * 购买物品
		 * @param id
		 *
		 */
		public function pay(productId : String, productName : String, productPrice : int, productCount : int) : void
		{
			curr_device && curr_device.pay(productId, productName, productPrice, productCount, createTag(productId));
		}

	}
}