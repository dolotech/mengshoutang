package sdk.android
{
	import com.nd.ane.NdCommplatform;

	import flash.events.StatusEvent;

	import game.uils.Config;

	import sdk.base.PhoneDevice;

	/**
	 * 91安卓平台
	 * @author hyy
	 *
	 */
	public class D91AndroidDevice extends PhoneDevice
	{
		public function D91AndroidDevice(type : String)
		{
			super(type);
		}

		override public function init() : void
		{
			super.init();
			NdCommplatform.getInstance().ndSetScreenOrientation(1);
			NdCommplatform.getInstance().init91SDK(113852, "543347cade281022624542c2a9c5781a9e16a523e216d802", 0);
			NdCommplatform.getInstance().ndSetRestartWhenSwitchAccount(false);
			NdCommplatform.getInstance().addEventListener(StatusEvent.STATUS, onStatusHandler);
		}

		protected function onStatusHandler(event : StatusEvent) : void
		{
			if (event.code == "NdLoginFunction")
			{
				var xmlLogin : XML = XML(event.level);
				var isOk : Boolean = int(xmlLogin.error) == 0;
				loginCallBack(isOk);
				isOk && Config.device_bar && NdCommplatform.getInstance().ndToolBarShow(1);
			}
			else if (event.code == "NdUniPayAsynFunction")
			{
				onPurchaseCallback(int(event.level) == 0, orderId);
			}
		}

		override public function login(onSuccess : Function, onFail : Function) : void
		{
			super.login(onSuccess, onFail);
			NdCommplatform.getInstance().ndLogin();
		}

		override public function loginOut() : void
		{
			super.loginOut();
			NdCommplatform.getInstance().ndLogout(1);
		}

		override public function get accountId() : String
		{
			return NdCommplatform.getInstance().ndGetLoginUin();
		}

		override public function pay(productId : String, productName : String, productPrice : Number, productCount : int, pay_orderId : String) : void
		{
			super.pay(productId, productName, productPrice, productCount,pay_orderId);
			NdCommplatform.getInstance().ndUniPayAsyn(pay_orderId, productId, productName, productPrice, productPrice, productCount, "充值");
		}
	}
}