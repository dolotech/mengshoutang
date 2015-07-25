package sdk.android
{
	import com.utils.Constants;

	import game.dialog.ShowLoader;

	import sdk.base.PhoneDevice;

	import wolun.huawei.ane.platform.HuaWeiExtensionEvent;
	import wolun.huawei.ane.platform.WoLunAne;

	/**
	 * 华为安卓
	 * @author hyy
	 *
	 */
	public class DHwAndroidDevice extends PhoneDevice
	{
		private var uid : String;
		private var token : String;

		public function DHwAndroidDevice(type : String)
		{
			super(type);
		}

		override public function init() : void
		{
			super.init();
			WoLunAne.testProxy.addEventListener(HuaWeiExtensionEvent.INIT_RECEIVED, onclickInitCallback);
			WoLunAne.testProxy.addEventListener(HuaWeiExtensionEvent.AUTHORATION_RECEIVED, onLoginCallback);
			WoLunAne.testProxy.addEventListener(HuaWeiExtensionEvent.TRANSACTIONS_RECEIVED, onPayRuleCalllback);
			WoLunAne.testProxy.init();
		}

		private function onclickInitCallback(event : HuaWeiExtensionEvent) : void
		{
			ShowLoader.remove();
		}

		override public function login(onSuccess : Function, onFail : Function) : void
		{
			super.login(onSuccess, onFail);
			WoLunAne.testProxy.login("10155580");
		}

		private function onLoginCallback(event : HuaWeiExtensionEvent) : void
		{
			uid = event.uId;
			token = event.token;
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

		override public function pay(productId : String, productName : String, productPrice : Number, productCount : int) : void
		{
			super.pay(productId, productName, productPrice, productCount);
			//价格是分
			productPrice *= 100;
			orderId = createTag();
			WoLunAne.testProxy.payment(token, orderId, productPrice.toString(), productName, "钻石", Constants.username, chargeUrl);
		}

		protected function onPayRuleCalllback(event : HuaWeiExtensionEvent) : void
		{
			onPurchaseCallback(event.payFlag, event.cpOrderId);
		}
	}
}