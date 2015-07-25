package sdk.ios
{
	import com.tongbu.Events.TBPlatformEvents;
	import com.tongbu.TBPlatform.TBPlatform;

	import flash.events.StatusEvent;

	import game.uils.Config;

	import sdk.base.PhoneDevice;

	import starling.core.Starling;

	/**
	 * 同步推
	 * @author hyy
	 *
	 */
	public class DTbIosDevice extends PhoneDevice
	{
		private var tbPlatform : TBPlatform;

		public function DTbIosDevice(type : String)
		{
			super(type);
		}

		override public function init() : void
		{
			super.init();
			tbPlatform = TBPlatform.getInstance();
			tbPlatform.addEventListener(StatusEvent.STATUS, onStatusHandler);
			tbPlatform.TBPlatformInitSelf(140517, 3, true);
			tbPlatform.TBSetScreenOrientation(4);
			tbPlatform.TBSetAutoRotation(false);
		}

		override public function login(onSuccess : Function, onFail : Function) : void
		{
			super.login(onSuccess, onFail);
			tbPlatform.TBLogin(0);
		}

		override public function loginOut() : void
		{
			super.loginOut();
			tbPlatform.TBLogout(0);
		}

		override public function get accountId() : String
		{
			return tbPlatform.userID();
		}

		override public function pay(productId : String, productName : String, productPrice : Number, productCount : int) : void
		{
			super.pay(productId, productName, productPrice, productCount);
			tbPlatform.TBUniPayForCoin(createTag(), productPrice, productName);
		}

		protected function onStatusHandler(event : StatusEvent) : void
		{
			switch (event.code)
			{
				//登陆
				case TBPlatformEvents.kTBLoginNotification:
					var xmlLogin : XML = XML(event.level);
					var isOk : Boolean = int(xmlLogin.error) == 0;
					loginCallBack(isOk);
					isOk && Config.device_bar && tbPlatform.TBShowToolBar(6, true);
					break;
				//购买成功
				case TBPlatformEvents.kTBBuyGoodsDidSuccess:
					var xmlBuy : XML = XML(event.level);
					TBPlatform.getInstance().TBCheckPaySuccess(String(xmlBuy.order));
					//onPurchaseCallback(true, String(xmlBuy.order));
					break;
				//离开平台
				case TBPlatformEvents.kTBLeavePlatformNotification:
					var xmllevel : XML = XML(event.level);
					if (int(xmllevel.type) == 3)
						TBPlatform.getInstance().TBCheckPaySuccess(String(xmllevel.order));
					else
						loginCallBack(false);
					break;
				//查询订单成功
				case TBPlatformEvents.kTBCheckOrderSuccess:
					var xmlcheck : XML = XML(event.level);
					if (int(xmlcheck.status) == 3)
						onPurchaseCallback(true, String(xmlcheck.order));
					if (int(xmlcheck.status) == 1)
						Starling.juggler.delayCall(checkOrder, 1);

					function checkOrder() : void
					{
						TBPlatform.getInstance().TBCheckPaySuccess(String(xmllevel.order));
					}
					break;
			}
		}

	}
}