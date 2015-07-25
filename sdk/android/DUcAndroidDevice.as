package sdk.android
{
	import com.langue.Langue;
	
	import cn.uc.gamesdk.ane.CallbackEvent;
	import cn.uc.gamesdk.ane.Constants;
	import cn.uc.gamesdk.ane.StatusCode;
	import cn.uc.gamesdk.ane.UCGameSDK;
	
	import game.dialog.ShowLoader;
	import game.manager.GameMgr;
	import game.uils.Config;
	import game.uils.HttpClient;
	
	import sdk.base.PhoneDevice;

	public class DUcAndroidDevice extends PhoneDevice
	{
		private var ucGameSDK : UCGameSDK;
		private var uid : String;

		public function DUcAndroidDevice(type : String)
		{
			super(type);
		}

		override public function init() : void
		{
			super.init();
			ucGameSDK = UCGameSDK.getInstance();
			ucGameSDK.setOrientation(Constants.ORIENTATION_LANDSCAPE);
			ucGameSDK.addEventListener(Constants.EVENT_TYPE_UCGameSDKCallback, onStatusHandler);
			ucGameSDK.initSDK(true, Constants.LOGLEVEL_DEBUG, 539558, 37418, 3032, "萌兽堂", true, false);
			ShowLoader.add(Langue.getLangue("init"));
		}

		protected function onStatusHandler(event : CallbackEvent) : void
		{
			switch (event.callbackType)
			{
				//初始化
				case Constants.CALLBACKTYE_InitSDK:
					ShowLoader.remove();
					break;
				case Constants.CALLBACKTYE_Login:
					if (event.code == StatusCode.SUCCESS)
					{
						HttpClient.send("http://42.62.14.78/sdk/uc/user.php", {"sid": ucGameSDK.getSid()}, onComplement);

						function onComplement(returnObj : String) : void
						{
							var tmpData : Object = JSON.parse(returnObj);

							if (tmpData.state.code == 1)
							{
								uid = tmpData.data.ucid;
								ucGameSDK.createFloatButton();
								Config.device_bar && ucGameSDK.showFloatButton(0, 100, true);
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
						if (event.data == "取消登录")
						{
							loginCallBack(false);
							ShowLoader.remove();
						}
					}
					break;
				case Constants.CALLBACKTYE_Pay:
					onPurchaseCallback(event.code == StatusCode.SUCCESS, orderId);
					break;
			}
		}

		override public function login(onSuccess : Function, onFail : Function) : void
		{
			super.login(onSuccess, onFail);
			ucGameSDK.login(false, "", null);
		}

		override public function loginOut() : void
		{
			super.loginOut();
			ucGameSDK.logout();
		}

		override public function get accountId() : String
		{
			return uid;
		}

		override public function pay(productId : String, productName : String, productPrice : Number, productCount : int, pay_orderId : String) : void
		{
			super.pay(productId, productName, productPrice, productCount,pay_orderId);
			ucGameSDK.pay(false, productPrice, 3032, GameMgr.instance.uid.toString(), "", "0", pay_orderId);
		}
	}
}