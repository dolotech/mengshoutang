package sdk.ios
{
	import com.langue.Langue;
	import com.utils.Constants;

	import flash.desktop.NativeApplication;
	import flash.events.InvokeEvent;

	import game.dialog.ShowLoader;
	import game.uils.HttpClient;

	import ppEvents.PPLoginEvent;
	import ppEvents.PPPayEvent;
	import ppEvents.PPVerifyingUpdatePassEvent;

	import sdk.base.PhoneDevice;

	/**
	 * pp助手
	 * @author hyy
	 *
	 */
	public class DPpIosDevice extends PhoneDevice
	{
		private var pp : PPAne;
		private var uid : String = "";

		public function DPpIosDevice(type : String)
		{
			super(type);
		}

		override public function init() : void
		{
			super.init();
			pp = PPAne.getInstance();
			pp.addEventListener(PPLoginEvent.PP_LOGIN_EVENT, onLoginEvent);
			pp.initSDKPlatform(3603, "2da6c32610f7c768d99bc2e9ec374720", 1, true, true, false, true, "充值失败!", true, true, true, true);
			pp.addEventListener(PPVerifyingUpdatePassEvent.PP_VERIFYINGUPDATEPASS_EVENT, ppVerifyingUpdatePassEvent);
			pp.addEventListener(PPPayEvent.PP_PAY_EVENT, ppVerifyingUpdatePassEvent);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, function invokeHandler(event : InvokeEvent) : void
				{
					if (event.arguments.length > 0)
					{
						pp.alixPayResult(event.arguments[0]);
					}
				});
		}

		override public function login(onSuccess : Function, onFail : Function) : void
		{
			super.login(onSuccess, onFail);

			if (uid != "")
				loginCallBack(true);
			else
				pp.showLoginView();

		}

		/**
		 * 登录成功回调
		 * @param event
		 *
		 */
		protected function onLoginEvent(event : PPLoginEvent) : void
		{
			var loginOk : Boolean = event.typeEvent != null && event.typeEvent != "";

			if (loginOk)
			{
				pp.getUserInfoSecurity();
				HttpClient.send("http://42.62.14.78/sdk/pp/user.php", {"token": event.typeEvent}, onComplement);
				ShowLoader.add(Langue.getLangue("pay"));
				function onComplement(returnObj : String) : void
				{
					var tmpData : Object = JSON.parse(returnObj);

					if (tmpData.status == 0)
					{
						uid = tmpData.userid;
						loginCallBack(true);
					}
					else
					{
						addTips(tmpData.state.msg);
						loginCallBack(false);
					}
					ShowLoader.remove();
				}
			}
			else
			{
				loginCallBack(false);
			}
		}

		override public function loginOut() : void
		{
			super.loginOut();
			pp.logout();
		}

		override public function get accountId() : String
		{
			return "";
		}

		override public function pay(productId : String, productName : String, productPrice : Number, productCount : int) : void
		{
			super.pay(productId, productName, productPrice, productCount);
			orderId = createTag();
			productPrice = 1;
			pp.exchangeGoods(productPrice, orderId, productName, Constants.username, 0);
		}

		private function ppPayEvent(e : PPPayEvent) : void
		{
			var paramPPPayResultCode : int = parseInt(e.typeEvent);
			onPurchaseCallback(paramPPPayResultCode == PPAppConfig.PPPayResultCodeSucceed, orderId);
		}

		/**
		 * 检查游戏版本更新完成回调
		 * 完毕后弹出登录页面
		 */
		private function ppVerifyingUpdatePassEvent(e : PPVerifyingUpdatePassEvent) : void
		{
			pp.showLoginView();
		}
	}
}