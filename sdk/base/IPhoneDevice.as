package sdk.base
{

	public interface IPhoneDevice
	{
		function init() : void;
		function login(onSuccess : Function, onFail : Function) : void;
		function loginOut() : void;
		function exit() : void;
		function get accountId() : String;
		function pay(productId : String, productName : String, productPrice : Number, productCount : int, pay_orderId : String) : void;
		function showBar() : void;
		function hideBar() : void;
		function exitPay() : void;
	}
}