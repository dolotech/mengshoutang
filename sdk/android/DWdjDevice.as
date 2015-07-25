package sdk.android
{
	import com.wanglailai.extensions.WdjExtensionContext;
	import com.wanglailai.extensions.WdjExtensionEvent;
	import com.wanglailai.extensions.WdjTransaction;

	import sdk.base.PhoneDevice;

	/**
	 * 豌豆荚平台
	 * @author hyy
	 *
	 */
	public class DWdjDevice extends PhoneDevice
	{
		public function DWdjDevice(type : String)
		{
			super(type);
		}

		override public function init() : void
		{
			super.init();
			WdjExtensionContext.instance.init("100001623", "98afbc1da57c0a19a9520971744239aa", "萌兽堂");
			WdjExtensionContext.instance.addEventListener(WdjExtensionEvent.TRANSACTIONS_RECEIVED, onWDJPurchaseCallback);
		}

		override public function login(onSuccess : Function, onFail : Function) : void
		{
			super.login(onSuccess, onFail);
			WdjExtensionContext.instance.addEventListener(WdjExtensionEvent.AUTHORATION_RECEIVED, onLoginCallback);
			WdjExtensionContext.instance.login();

			function onLoginCallback(evt : WdjExtensionEvent) : void
			{
				WdjExtensionContext.instance.removeEventListener(WdjExtensionEvent.AUTHORATION_RECEIVED, onLoginCallback);
				loginCallBack(evt.data == WdjExtensionEvent.AUTHENTICATE_SUCCESS);
			}
		}

		override public function exitPay():void
		{
			//WdjExtensionContext.instance.finishPay();
		}

		override public function get accountId() : String
		{
			return WdjExtensionContext.instance.getProfile().uid;
		}

		override public function pay(productId : String, productName : String, productPrice : Number, productCount : int) : void
		{
			super.pay(productId, productName, productPrice, productCount);
			productPrice *= 100;
			WdjExtensionContext.instance.startPayment(createTag(), productPrice, productName);
		}

		/**
		 * 支付回调
		 * @param evt
		 *
		 */
		protected function onWDJPurchaseCallback(evt : WdjExtensionEvent) : void
		{
			for each (var t : WdjTransaction in evt.transactions)
			{
				onPurchaseCallback(t.state == WdjTransaction.TRANSACTION_STATE_PURCHASED, t.transactionID);
			}
		}
	}
}