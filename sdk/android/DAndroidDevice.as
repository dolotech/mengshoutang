package sdk.android
{
	import com.turbotech.PlatformSDK.SdkExtension;
	import com.turbotech.PlatformSDK.SdkExtensionEvent;
	import com.turbotech.PlatformSDK.SdkProxy;
	import com.view.base.event.EventType;
	import com.view.base.event.ViewDispatcher;

	import game.uils.Config;
	import game.uils.HttpClient;

	import sdk.base.PhoneDevice;

	import starling.events.Event;

	public class DAndroidDevice extends PhoneDevice
	{
		public function DAndroidDevice(type : String)
		{
			super(type);
		}

		private var sdkProxy : SdkProxy;

		override public function init() : void
		{
			super.init();
			ViewDispatcher.instance.addEventListener(EventType.GOTO_WEB, gotoWebHandler);
			sdkProxy = SdkExtension.getSdkProxy(); //创建extension
			sdkProxy.addEventListener(SdkExtensionEvent.PAY_RECEIVED, onPayCallback);
		}

		private function gotoWebHandler(evt : Event, url : String) : void
		{
			sdkProxy.web(url);
		}

		private function onPayCallback(e : SdkExtensionEvent) : void
		{
			if (e.payFlag)
			{
				HttpClient.send("http://211.72.249.246/charge.php", {mod: "callback", act: Config.android, payment_method: "google_play", data: encodeURI(e.data), sign: encodeURI(e.sign)}, onComplement, null, "post");

				function onComplement(returnObj : String) : void
				{
					if (returnObj == "success")
						addTips("buySuccess");
					else
						addTips("buyLose");
				}
			}
			//onPurchaseCallback(true, Base64.Encode(data.receipt));
		}

		override public function pay(productId : String, productName : String, productPrice : Number, productCount : int, pay_orderId : String) : void
		{
			super.pay(productId, productName, productPrice, productCount, pay_orderId);
			sdkProxy.pay(productName.substring(1, productName.length - 1), pay_orderId);
		}
	}
}