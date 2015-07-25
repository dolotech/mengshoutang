package sdk.ios
{
	import com.nd.complatform.NdComPlatform;
	import com.nd.complatform.NdComPlatformEvents;
	import com.view.base.event.EventType;
	import com.view.base.event.ViewDispatcher;
	
	import flash.events.StatusEvent;
	
	import game.uils.Config;
	
	import sdk.base.PhoneDevice;

	public class D91IosDevice extends PhoneDevice
	{
		private var isAutoLogin : Boolean;

		public function D91IosDevice(type : String)
		{
			super(type);
		}

		override public function init() : void
		{
			super.init();
			isAutoLogin = Config.isAutoLogin;
			Config.isAutoLogin = false;
			NdComPlatform.getInstance().NdSetScreenOrientation(4);
			NdComPlatform.getInstance().NdSetAutoRotation(false);
			NdComPlatform.getInstance().NdInitSDK(114312, "64f868fc07fb3c688243f176061f982a32035b99ed0a86ce", 0);
			NdComPlatform.getInstance().addEventListener(StatusEvent.STATUS, onStatusHandler);
		}

		protected function onStatusHandler(event : StatusEvent) : void
		{

			switch (event.code)
			{
				//初始化
				case NdComPlatformEvents.kNdCPInitDidFinishNotification:
					Config.isAutoLogin = isAutoLogin;
					ViewDispatcher.dispatch(EventType.AUTO_LOGIN, isAutoLogin);
					break;
				//登陆
				case NdComPlatformEvents.kNdCPLoginNotification:
					var xmlLogin : XML = XML(event.level);
					var isOk : Boolean = int(xmlLogin.error) == 0;
					loginCallBack(isOk);
					isOk && Config.device_bar && NdComPlatform.getInstance().NdShowToolBar(1);
					break;
				case NdComPlatformEvents.kNdCPBuyResultNotification:
					var xmlBuy : XML = XML(event.level);
					onPurchaseCallback(int(xmlBuy.error) == 0, orderId);
					break;
			}
		}

		override public function login(onSuccess : Function, onFail : Function) : void
		{
			super.login(onSuccess, onFail);
			NdComPlatform.getInstance().NdLogin(0);
		}

		override public function loginOut() : void
		{
			super.loginOut();
			NdComPlatform.getInstance().NdLogout(1);
		}

		override public function get accountId() : String
		{
			return NdComPlatform.getInstance().loginUin();
		}

		override public function pay(productId : String, productName : String, productPrice : Number, productCount : int,pay_orderId:String) : void
		{
			super.pay(productId, productName, productPrice, productCount,pay_orderId);
			NdComPlatform.getInstance().NdUniPay(pay_orderId, productId, productName, productPrice, productPrice, productCount, pay_orderId);
		}
	}
}