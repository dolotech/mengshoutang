package game.view.vip
{
	import game.data.DiamondShopData;
	import game.view.viewBase.UiAndroidPayBase;

	import sdk.AccountManager;
	import sdk.android.DAndroidHttpServer;

	import starling.events.Event;

	public class AndroidPayView extends UiAndroidPayBase
	{
		private var diamond : DiamondShopData;

		public function AndroidPayView()
		{
			super();
		}

		override protected function init() : void
		{
			_closeButton = btn_close;
			clickBackroundClose();
			enableTween = true;
			setToXCenter();
		}

		override protected function show() : void
		{
			diamond = _parameter as DiamondShopData;
			txt_1.text = diamond.fun + "";
			txt_2.text = diamond.twd + "";
			txt_3.text = diamond.usd + "";
			txt_4.text = diamond.usd + "";
			updateView(diamond);
		}

		override protected function addListenerHandler() : void
		{
			super.addListenerHandler();
			box1.addEventListener(Event.TRIGGERED, onClick);
			box2.addEventListener(Event.TRIGGERED, onClick);
			box3.addEventListener(Event.TRIGGERED, onClick);
			box4.addEventListener(Event.TRIGGERED, onClick);
		}

		private function onClick(event : Event) : void
		{
			switch (event.currentTarget)
			{
				case box1:
					DAndroidHttpServer.getInstance().pay_fun(diamond);
					break;
				case box2:
					DAndroidHttpServer.getInstance().pay_MyCard(diamond);
					break;
				case box3:
					DAndroidHttpServer.getInstance().pay_paypal(diamond);
					break;
				case box4:
					AccountManager.instance.pay(diamond.shopid.toString(), diamond.idNume, diamond.rmb, 1);
					break;
			}
		}

		public function updateView(diamond : DiamondShopData) : void
		{

		}
	}
}