package sdk
{
	import ane.ljsdk.GameProxy;
	import ane.ljsdk.XMExitCallback;
	import ane.ljsdk.XMPayCallback;
	import ane.ljsdk.XMUser;
	import ane.ljsdk.XMUserListener;

	import sdk.base.PhoneDevice;

	/**
	 * 凌静SDK
	 * @author hyy
	 *
	 */
	public class DLjDevice extends PhoneDevice implements XMUserListener, XMPayCallback, XMExitCallback
	{
		private var uid : String;

		public function DLjDevice(type : String)
		{
			super(type);
		}

		override public function init() : void
		{
			super.init();
			GameProxy.getInstance().init();
			GameProxy.getInstance().setuserListener(this);
		}

		override public function login(onSuccess : Function, onFail : Function) : void
		{
			super.login(onSuccess, onFail);
			GameProxy.getInstance().login();
		}

		override public function loginOut() : void
		{
			super.loginOut();
			GameProxy.getInstance().logout();
		}

		override public function get accountId() : String
		{
			return uid;
		}

		override public function pay(productId : String, productName : String, productPrice : Number, productCount : int, pay_orderId : String) : void
		{
			super.pay(productId, productName, productPrice, productCount, pay_orderId);
			GameProxy.getInstance().pay(1, "钻石", 1, pay_orderId, chargeUrl, this);
		}

		public function onSuccess(info : String) : void
		{
			onPurchaseCallback(true, info);
		}

		public function onFail(info : String) : void
		{
			onPurchaseCallback(false);
		}

		public function onChannelExitConfirmed() : void
		{
		}

		public function onNoChanelExitProvided() : void
		{
		}

		public function onLogout() : void
		{
		}

		public function onLoginFailed(reason : String) : void
		{
			loginCallBack(false);
		}

		public function onLoginSuccess(user : XMUser) : void
		{
			uid = user.userID;
			var obj : Object = new Object();
			obj.roleId = "007";
			obj.zoneId = "1";
			obj.roleName = "linglingqi";
			GameProxy.getInstance().setExtRoleData(obj);
			loginCallBack(true);
		}
	}
}