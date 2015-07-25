package sdk.ios
{
	import com.adobe.ane.productStore.ProductEvent;
	import com.adobe.ane.productStore.ProductStore;
	import com.adobe.ane.productStore.Transaction;
	import com.adobe.ane.productStore.TransactionEvent;
	import com.sticksports.nativeExtensions.gameCenter.GameCenter;
	import com.view.base.event.ViewDispatcher;
	
	import game.data.DiamondShopData;
	import game.dialog.ShowLoader;
	import game.net.data.s.SXYLMLogin;
	import game.uils.Base64;
	
	import sdk.DataEyeManger;
	import sdk.base.PhoneDevice;

	/**
	 * 游戏中心
	 * @author hyy
	 *
	 */
	public class DGameCenter extends PhoneDevice
	{
		private var appPurchase : ProductStore;
		private var productOk : Boolean = false;

		public function DGameCenter(type : String)
		{
			super(type);
		}

		override public function init() : void
		{
			super.init();

			if (!GameCenter.isSupported)
				return;
			ViewDispatcher.instance.addEventListener(SXYLMLogin.CMD + "", initPay);
			GameCenter.init();
		}

		public function initPay() : void
		{
			if (appPurchase == null)
			{
				appPurchase = new ProductStore();
				appPurchase.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_SUCCESS, onProductsReceived);
				appPurchase.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_CANCEL, onFailedTransaction);
				appPurchase.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_FAIL, onFailedTransaction);
				appPurchase.addEventListener(ProductEvent.PRODUCT_DETAILS_FAIL, productInit);
				appPurchase.addEventListener(ProductEvent.PRODUCT_DETAILS_SUCCESS, productSuccess);
				finishTransactions(appPurchase.pendingTransactions);
				productInit();
			}
		}

		private function productInit(evt : ProductEvent = null) : void
		{
			var len : int = DiamondShopData.list.length;
			var diamond : DiamondShopData;
			var vector : Vector.<String> = new Vector.<String>();

			for (var i : int = 0; i < len; i++)
			{
				diamond = DiamondShopData.list[i];
				vector.push(diamond.idNume.substring(1, diamond.idNume.length - 1));
			}
			appPurchase.requestProductsDetails(vector);
		}

		private function productSuccess(evt : ProductEvent = null) : void
		{
			productOk = true;
		}

		private function onProductsReceived(e : TransactionEvent) : void
		{
			ShowLoader.remove();
			var i : uint = 0;
			var t : Transaction;

			while (e.transactions && i < e.transactions.length)
			{
				t = e.transactions[i];
				i++;
				appPurchase.finishTransaction(t.identifier);
				onPurchaseCallback(true, Base64.Encode(t.receipt));
			}
		}

		/**
		 * 发送验证消息
		 * @param verifyReceipt
		 *
		 */
		override protected function sendVerifyReceipt(verifyReceipt : String) : void
		{
			DataEyeManger.instance.onChargeSuccess(orderId);
			sendDiamondShop(verifyReceipt);
		}

		private function onFailedTransaction(e : TransactionEvent) : void
		{
			ShowLoader.remove();
			finishTransactions(e.transactions);
		}

		private function finishTransactions(list : Vector.<Transaction>) : void
		{
			if (list == null)
				return;
			var len : int = list.length;
			var t : Transaction;

			for (var i : int = 0; i < len; i++)
			{
				t = list[i];
				appPurchase.finishTransaction(t.identifier);
			}
		}

		override public function login(onSuccess : Function, onFail : Function) : void
		{
			super.login(onSuccess, onFail);

			if (!GameCenter.isSupported)
				return;
			ShowLoader.add(getLangue("login"));
			GameCenter.init();
			GameCenter.localPlayerAuthenticated.add(onSuccesComplement);
			GameCenter.localPlayerNotAuthenticated.add(onFailComplement);
			GameCenter.authenticateLocalPlayer();

			function onSuccesComplement() : void
			{
				remove();
				loginCallBack(true);
			}

			function onFailComplement() : void
			{
				remove();
				loginCallBack(false);
			}

			function remove() : void
			{
				GameCenter.localPlayerAuthenticated.removeAll();
				GameCenter.localPlayerNotAuthenticated.removeAll();
			}
		}

		override public function get accountId() : String
		{
			return GameCenter.localPlayer.id;
		}

		override public function pay(productId : String, productName : String, productPrice : Number, productCount : int, pay_orderId : String) : void
		{
			super.pay(productId, productName, productPrice, productCount, pay_orderId);

			if (!productOk)
			{
				addTips("pay_product");
				return;
			}
			ShowLoader.add(getLangue("pay"));
			appPurchase.makePurchaseTransaction(productName, productCount);
		}

	}
}