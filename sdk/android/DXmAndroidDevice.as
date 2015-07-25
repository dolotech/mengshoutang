package sdk.android
{
	import com.utils.Constants;
	import com.wolun.xiaomi.ane.platform.WoLunAne;
	import com.wolun.xiaomi.ane.platform.XiaoMiExtensionEvent;

	import game.dialog.ShowLoader;
	import game.manager.GameMgr;
	import game.uils.Config;

	import sdk.base.PhoneDevice;

	/**
	 * 小米平台
	 * @author hyy
	 *
	 */
	public class DXmAndroidDevice extends PhoneDevice
	{
		private var uid : String;

		public function DXmAndroidDevice(type : String)
		{
			super(type);
		}

		override public function init() : void
		{
			super.init();
			WoLunAne.testProxy.addEventListener(XiaoMiExtensionEvent.AUTHORATION_RECEIVED, onStatusHandler);
			WoLunAne.testProxy.addEventListener(XiaoMiExtensionEvent.TRANSACTIONS_RECEIVED, onStatusHandler);
			WoLunAne.testProxy.init();
			Config.isActive = true;
		}

		protected function onStatusHandler(event : XiaoMiExtensionEvent) : void
		{
			switch (event.type)
			{
				case XiaoMiExtensionEvent.AUTHORATION_RECEIVED:
					var isOk : Boolean = event.loginFlag;
					uid = event.uid;
					loginCallBack(isOk);
					ShowLoader.remove();
					break;
				case XiaoMiExtensionEvent.TRANSACTIONS_RECEIVED:
					onPurchaseCallback(event.payFlag, event.cpOrderId);
					break;
			}
		}

		override public function login(onSuccess : Function, onFail : Function) : void
		{
			super.login(onSuccess, onFail);
			WoLunAne.testProxy.login();
		}

		override public function loginOut() : void
		{
			super.loginOut();
			Config.isActive = true;
			WoLunAne.testProxy.exit();
		}

		override public function get accountId() : String
		{
			return uid;
		}

		override public function pay(productId : String, productName : String, productPrice : Number, productCount : int) : void
		{
			super.pay(productId, productName, productPrice, productCount);
			productPrice = 1;
			WoLunAne.testProxy.payMent(createTag(), productPrice, "", "", "", "", GameMgr.instance.arenaname, GameMgr.instance.uid.toString(), Constants.SID.toString());
		}
	}
}