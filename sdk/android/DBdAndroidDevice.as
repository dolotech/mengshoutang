package sdk.android
{
	import com.dklib.AneDispatcher;
	
	import flash.events.StatusEvent;
	
	import game.dialog.ShowLoader;
	
	import sdk.base.PhoneDevice;

	public class DBdAndroidDevice extends PhoneDevice
	{
		private var ane : AneDispatcher;
		private var uid : String;

		public function DBdAndroidDevice(type : String)
		{
			super(type);
		}

		override public function init() : void
		{
			super.init();
			ane = AneDispatcher.getInstance();
			ane.addEventListener(StatusEvent.STATUS, statusEventListener);
			ane.DKSdkInit("2979948", "dXTkmskOC3lgPtm1C0uClhz8", 0);
		}

		private function statusEventListener(e : StatusEvent) : void
		{
			//普通登录：
			if (e.code == "LoginCallBack" || e.code == "LogSupCallBack")
			{
				var loginCallData : Object = JSON.parse(e.level);
				var loginState : int = int(loginCallData.state_code);
				uid = loginCallData.user_id;

				//登录成功
				if (1021 == loginState)
				{
					loginCallBack(true);
				}
				//用户取消登录
				else if (1106 == loginState)
				{
					loginCallBack(false);
				}
				else
				{
					loginCallBack(false);
				}
			}
			//支付的回调
			else if (e.code == "PayCallBack")
			{
				var PayCallBack : Object = JSON.parse(e.level);
				var mStateCode : int = int(PayCallBack.state_code); //状态码
				var mMessage : String = PayCallBack.message; //信息		
				var mOrderId : String = PayCallBack.cp_order_id; //订单号
				// 此处只表示是否有充值行为，无法判断充值结果，充值结果由多酷服务器通知至CP的回调地址
				onPurchaseCallback(mStateCode == 0, mOrderId);
			}
		}

		override public function login(onSuccess : Function, onFail : Function) : void
		{
			super.login(onSuccess, onFail);
			ane.DKLogin();
			ShowLoader.remove();
		}

		override public function loginOut() : void
		{
			super.loginOut();
			ane.DKLogout();
		}

		override public function exit() : void
		{
			ane.DKReleaseResourceFunction();
		}

		override public function get accountId() : String
		{
			return uid;
		}

		override public function pay(productId : String, productName : String, productPrice : Number, productCount : int, pay_orderId : String) : void
		{
			super.pay(productId, productName, productPrice, productCount, pay_orderId);
			ane.DKUnitPay(productPrice, 10, "钻石", pay_orderId, "充值");
		}
	}
}