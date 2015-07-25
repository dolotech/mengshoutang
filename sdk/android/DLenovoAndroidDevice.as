package sdk.android
{
	import com.wolun.lenovo.ane.platform.LenovoExtensionEvent;
	import com.wolun.lenovo.ane.platform.WoLunAne;
	
	import game.dialog.ShowLoader;
	
	import sdk.base.PhoneDevice;
	
	import starling.events.Event;

	public class DLenovoAndroidDevice extends PhoneDevice
	{
		private var uid : String;

		public function DLenovoAndroidDevice(type : String)
		{
			super(type);
		}

		override public function init() : void
		{
			super.init();
			WoLunAne.testProxy.addEventListener(LenovoExtensionEvent.AUTHORATION_RECEIVED, onLoginCallback);
			WoLunAne.testProxy.addEventListener(LenovoExtensionEvent.TRANSACTIONS_RECEIVED, onPayRuleCalllback);
			WoLunAne.testProxy.init("20043100000001200431");
		}

		protected function onInitCallback(event : Event) : void
		{
			ShowLoader.remove();
		}

		override public function login(onSuccess : Function, onFail : Function) : void
		{
			super.login(onSuccess, onFail);
			WoLunAne.testProxy.login();
		}

		private function onLoginCallback(event : LenovoExtensionEvent) : void
		{
			uid = event.uid;
			loginCallBack(event.loginFlag);
		}

		override public function loginOut() : void
		{
			super.loginOut();
		}

		override public function get accountId() : String
		{
			return uid;
		}

		override public function pay(productId : String, productName : String, productPrice : Number, productCount : int) : void
		{
			super.pay(productId, productName, productPrice, productCount);
			productPrice = 0.01;
			orderId = createTag();
			WoLunAne.testProxy.payMent("MjREREJDMDY5NDkxOTRCRjM4NjUyOTQ5NTM4QzJDREY0RjFFMjE5N01UYzFNamczTmpBd01UQTVNelEyTlRrM05qTXJNakEyTWpFek5qY3pOekl4TVRBd09EazVNRE0zTURVeE56UTFOVE16Tnpnek16STRPVEl6", "20043100000001200431",chargeUrl, uint(productId), productPrice, orderId, "");
		}

		protected function onPayRuleCalllback(event : LenovoExtensionEvent) : void
		{
			onPurchaseCallback(event.payFlag, event.cpOrderId);
		}
	}
}