package sdk.android
{
	import com.utils.Constants;
	import com.wolun.qihoo.ane.platform.QiHooExtensionEvent;
	import com.wolun.qihoo.ane.platform.WoLunAne;

	import flash.events.Event;

	import game.dialog.ShowLoader;

	import sdk.base.PhoneDevice;

	/**
	 * 360平台
	 * @author hyy
	 *
	 */
	public class D360AndroidDevice extends PhoneDevice
	{
		private var uid : String;
		private var access_token : String;

		public function D360AndroidDevice(type : String)
		{
			super(type);
		}

		override public function init() : void
		{
			super.init();
			WoLunAne.testProxy.addEventListener(QiHooExtensionEvent.INIT_RECEIVED, onInitCallback);
			WoLunAne.testProxy.addEventListener(QiHooExtensionEvent.AUTHORATION_RECEIVED, onLoginCallback);
			WoLunAne.testProxy.addEventListener(QiHooExtensionEvent.TRANSACTIONS_RECEIVED, onPayRuleCalllback);
			WoLunAne.testProxy.init(true);
		}

		protected function onInitCallback(event : Event) : void
		{
			ShowLoader.remove();
		}

		override public function login(onSuccess : Function, onFail : Function) : void
		{
			super.login(onSuccess, onFail);
			ShowLoader.remove();
			WoLunAne.testProxy.login(true);
		}

		private function onLoginCallback(event : QiHooExtensionEvent) : void
		{
			uid = event.id;
			access_token = event.access_token;
			loginCallBack(event.loginFlag);
		}

		override public function loginOut() : void
		{
			super.loginOut();
			WoLunAne.testProxy.exit();
		}

		override public function get accountId() : String
		{
			return uid;
		}

		override public function pay(productId : String, productName : String, productPrice : Number, productCount : int, pay_orderId : String) : void
		{
			super.pay(productId, productName, productPrice, productCount,pay_orderId);
			//单位分
			productPrice *= 100;
			WoLunAne.testProxy.pay(access_token, uid, true, "萌兽堂", Constants.username, orderId, productName, productId, "1", chargeUrl, productPrice.toString());
		}

		protected function onPayRuleCalllback(event : QiHooExtensionEvent) : void
		{
			onPurchaseCallback(event.payFlag, event.orderId);
		}
	}
}