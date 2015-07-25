package sdk.base
{
	import com.adobe.utils.crypto.MD5;
	import com.components.RollTips;
	import com.langue.Langue;
	import com.utils.Constants;

	import game.common.JTLogger;
	import game.net.GameSocket;
	import game.net.data.c.CDiamondshop;
	import game.uils.Config;
	import game.uils.LocalShareManager;

	import sdk.DataEyeManger;

	/**
	 * 平台接口基类
	 * @author hyy
	 *
	 */
	public class PhoneDevice implements IPhoneDevice
	{
		public static const pay_device : String = "pay_device";
		/**
		 * 平台类型
		 */
		protected var device_type : String;
		protected var onSuccess : Function, onFail : Function;

		public function PhoneDevice(type : String)
		{
			this.device_type = type;
		}

		/**
		 * 初始化
		 *
		 */
		public function init() : void
		{
			debug("平台初始化:", device_type);
		}

		/**
		 * 登录
		 * @param onSuccess
		 * @param onFail
		 *
		 */
		public function login(onSuccess : Function, onFail : Function) : void
		{
			this.onSuccess = onSuccess;
			this.onFail = onFail;
		}

		public function exitPay() : void
		{

		}

		public function showBar() : void
		{

		}

		public function hideBar() : void
		{

		}

		/**
		 * 登录返回
		 * @param isSuccess
		 *
		 */
		protected function loginCallBack(isSuccess : Boolean) : void
		{
			if (isSuccess)
				onSuccess != null && onSuccess();
			else
				onFail != null && onFail();
			onSuccess = null;
			onFail = null;
		}

		/**
		 * 登出
		 *
		 */
		public function loginOut() : void
		{
			debug("平台注销");
		}

		/**
		 * 账号
		 * @return
		 *
		 */
		public function get accountId() : String
		{
			return null;
		}

		/**
		 * 退出
		 *
		 */
		public function exit() : void
		{

		}

		/**
		 * 支付
		 * @param productId 商品ID
		 * @param productName 商品名称
		 * @param productPrice 商品价格
		 * @param productOrignalPrice 商品原始价格
		 * @param productCount 购买商品个数
		 *
		 */
		public function pay(productId : String, productName : String, productPrice : Number, productCount : int, pay_orderId : String) : void
		{
			orderId = pay_orderId;
			DataEyeManger.instance.onCharge(pay_orderId, productPrice);
			debug("平台充值:", productId, "  ", productName, "  ", productPrice, "  ", productCount);
		}

		/**
		 * 发送验证消息
		 * @param verifyReceipt
		 *
		 */
		protected function sendVerifyReceipt(verifyReceipt : String) : void
		{
			DataEyeManger.instance.onChargeSuccess(orderId);
			sendDiamondShop(verifyReceipt);
			//储存充值信息
			LocalShareManager.getInstance().save(LocalShareManager.CHARGE, verifyReceipt);
		}

		/**
		 * 支付回调
		 * @param isSuccess     是否成功
		 * @param verifyReceipt 支付key
		 *
		 */
		protected function onPurchaseCallback(isSuccess : Boolean, verifyReceipt : String = "") : void
		{
			if (isSuccess)
			{
				//addTips("buySuccess");
				sendVerifyReceipt(verifyReceipt);
			}
			else
			{
				//addTips("buyLose");
			}
		}

		public function getLangue(id : String) : String
		{
			return Langue.getLangue(id);
		}

		/**
		 * 输出提示
		 * 打印到屏幕
		 * @param args
		 *
		 */
		public function addTips(info : String) : void
		{
			var msg : String = getLangue(info);
			RollTips.add(msg ? msg : info);
		}

		/**
		 * 用于调试数据
		 * 上线可能去掉
		 * @param args
		 *
		 */
		public function debug(... args) : void
		{
			JTLogger.debug.apply(this, args);
		}

		public function warn(... args) : void
		{
			JTLogger.warn.apply(this, args);
		}

		protected function set orderId(orderId : String) : void
		{
			LocalShareManager.getInstance().save(PhoneDevice.pay_device + Config.device, orderId, false);
			LocalShareManager.getInstance().flush();
		}

		protected function get orderId() : String
		{
			return LocalShareManager.getInstance().get(PhoneDevice.pay_device + Config.device, false);
		}

		/**
		 * 生成32位伪GUID
		 * @return
		 *
		 */
		private function createGUID() : String
		{
			var guid : String = "";
			var ALPHA_CHARS : String = "0123456789abcdef";
			var i : Number;
			var j : Number;

			for (i = 0; i < 8; i++)
			{ //先成成前8位
				guid += ALPHA_CHARS.charAt(Math.round(Math.random() * 15));
			}

			for (i = 0; i < 3; i++)
			{ //中间的三个4位16进制数
				guid += "-";

				for (j = 0; j < 4; j++)
				{
					guid += ALPHA_CHARS.charAt(Math.round(Math.random() * 15));
				}
			}
			guid += "-";
			var mlk : Date = new Date();
			var time : Number = mlk.getTime();
			guid += ("0000000" + time.toString(16).toUpperCase()).substr(-8); //取后边8位

			for (i = 0; i < 4; i++)
			{
				guid += ALPHA_CHARS.charAt(Math.round(Math.random() * 15)); //再循环4次随机拿出4位
			}
			return guid.toLowerCase();
		}

		protected function get chargeUrl() : String
		{
			return "http://42.62.14.78/charge.php?mod=callback&act=" + Config.device;
		}

		/**
		 * 发送充值信息
		 * @param name
		 * @param verifyReceipt
		 *
		 */
		public static function sendDiamondShop(verifyReceipt : String) : void
		{
			var date : Date = new Date();
			var rand : int = date.time / 1000;
			var cmd : CDiamondshop = new CDiamondshop();
			cmd.receipt = verifyReceipt;
			cmd.rand = rand;
			cmd.platform = Config.device;
			var key : String = "23d7f859778d2093";
			var md : String = Constants.SID + "" + key + "" + Constants.username + "" + rand;
			cmd.signature = MD5.hash(md);
			GameSocket.instance.sendData(cmd);
		}
	}
}