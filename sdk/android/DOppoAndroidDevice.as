package sdk.android
{
	import com.langue.Langue;
	import com.wolun.oppo.ane.platform.OppoExtensionEvent;
	import com.wolun.oppo.ane.platform.WoLunAne;

	import game.dialog.ShowLoader;

	import sdk.base.PhoneDevice;

	/**
	 * oppo平台
	 * @author hyy
	 *
	 */
	public class DOppoAndroidDevice extends PhoneDevice
	{
		private var uid : String;

		public function DOppoAndroidDevice(type : String)
		{
			super(type);
		}

		override public function init() : void
		{
			super.init();
			ShowLoader.add(Langue.getLangue("init"));
			WoLunAne.testProxy.addEventListener(OppoExtensionEvent.INTI_RECEIVED, onclickInitCallback);
			WoLunAne.testProxy.addEventListener(OppoExtensionEvent.AUTHORATION_RECEIVED, onLoginCallback);
			WoLunAne.testProxy.addEventListener(OppoExtensionEvent.PAYRULE_RECEIVED, onPayRuleCalllback);
			WoLunAne.testProxy.init("E30760pgTy8Kg4w04kWww8ww0", "f42a9b6406Ba507495176c88073E582c");
		}

		override public function showBar() : void
		{
			WoLunAne.testProxy.showSprite();
		}

		override public function hideBar() : void
		{
			WoLunAne.testProxy.dismissSprite();
		}


		private function onclickInitCallback(event : OppoExtensionEvent) : void
		{
			showBar();
			ShowLoader.remove();
		}

		override public function login(onSuccess : Function, onFail : Function) : void
		{
			super.login(onSuccess, onFail);
			WoLunAne.testProxy.login();
		}

		private function onLoginCallback(event : OppoExtensionEvent) : void
		{
			uid = event.id;
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
			//价钱是分
			productPrice *= 100;
			orderId = createTag();
			WoLunAne.testProxy.payRule(orderId, orderId, productPrice, productName, "充值", chargeUrl);
		}

		protected function onPayRuleCalllback(event : OppoExtensionEvent) : void
		{
			onPurchaseCallback(event.payNorm, event.order);
		}
	}
}