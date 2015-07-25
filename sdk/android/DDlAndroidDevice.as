package sdk.android
{
	import com.langue.Langue;
	import com.utils.Constants;
	import com.wolun.dangle.ane.platform.DangLeExtensionEvent;
	import com.wolun.dangle.ane.platform.WoLunAne;
	
	import game.dialog.ShowLoader;
	
	import sdk.base.PhoneDevice;

	/**
	 * 当乐安卓
	 * @author hyy
	 *
	 */
	public class DDlAndroidDevice extends PhoneDevice
	{
		private var uid : String;

		public function DDlAndroidDevice(type : String)
		{
			super(type);
		}

		override public function init() : void
		{
			super.init();
			ShowLoader.add(Langue.getLangue("init"));
			WoLunAne.testProxy.addEventListener(DangLeExtensionEvent.INIT_RECEIVED, onclickInitCallback);
			WoLunAne.testProxy.addEventListener(DangLeExtensionEvent.AUTHORATION_RECEIVED, onLoginCallback);
			WoLunAne.testProxy.addEventListener(DangLeExtensionEvent.TRANSACTIONS_RECEIVED, onPayRuleCalllback);
			WoLunAne.testProxy.init("750", "1436", "1", "cRKnb8Rw");
		}

		private function onclickInitCallback(event : DangLeExtensionEvent) : void
		{
			ShowLoader.remove();
		}

		override public function login(onSuccess : Function, onFail : Function) : void
		{
			super.login(onSuccess, onFail);
			WoLunAne.testProxy.login();
		}

		private function onLoginCallback(event : DangLeExtensionEvent) : void
		{
			uid = event.uId;
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

		override public function pay(productId : String, productName : String, productPrice : Number, productCount : int,pay_orderId:String) : void
		{
			super.pay(productId, productName, productPrice, productCount,pay_orderId);
			WoLunAne.testProxy.payMent(pay_orderId, "0.01", productName);
		}

		protected function onPayRuleCalllback(event : DangLeExtensionEvent) : void
		{
			onPurchaseCallback(event.payFlag, event.cpOrderId);
		}
	}
}