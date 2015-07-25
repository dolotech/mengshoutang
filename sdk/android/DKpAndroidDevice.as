package sdk.android
{
	import com.wolun.coolpad.ane.platform.CoolPadExtensionEvent;
	import com.wolun.coolpad.ane.platform.WoLunAne;

	import sdk.base.PhoneDevice;

	/**
	 * 酷派
	 * @author hyy
	 *
	 */
	public class DKpAndroidDevice extends PhoneDevice
	{
		public function DKpAndroidDevice(type : String)
		{
			super(type);
		}

		override public function init() : void
		{
			super.init();
			WoLunAne.testProxy.addEventListener(CoolPadExtensionEvent.TRANSACTIONS_RECEIVED, onPayCallback);
			WoLunAne.testProxy.init("3000464951");
		}

		override public function pay(productId : String, productName : String, productPrice : Number, productCount : int) : void
		{
			super.pay(productId, productName, productPrice, productCount);
			//单位分
			productPrice *= 100;
			orderId = createTag();
			var appkey : String = "NjA2QTU4MjZCRjMwMDU4NDUwQjc0MTAzQ0NCREQ0RDkyQjY5MTUyQk1UVXpPRGt3TURZMU5qZzVPRGt4TVRVeU9Ea3JPVFkyTWpZME1EYzBOREl3TkRZMU1qVTNNVEF4T1RVd01UQTBOVEl4TURjNE9USTJORGM9";
			WoLunAne.testProxy.payMent(chargeUrl, "3000464951", int(productId), 1, orderId, productPrice, productName, appkey);
		}

		protected function onPayCallback(event : CoolPadExtensionEvent) : void
		{
			onPurchaseCallback(event.payFlag, event.cpOrderId);
		}
	}
}