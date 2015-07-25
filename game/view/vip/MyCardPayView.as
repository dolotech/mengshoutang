package game.view.vip
{
	import game.view.viewBase.UiMyCardPayBase;

	import sdk.android.DAndroidHttpServer;

	import starling.events.Event;

	public class MyCardPayView extends UiMyCardPayBase
	{
		public function MyCardPayView()
		{
			super();
		}

		override protected function init() : void
		{
			_closeButton = btn_cancel;
			clickBackroundClose();
		}

		override protected function show() : void
		{
			setToCenter();
		}

		override protected function addListenerHandler() : void
		{
			super.addListenerHandler();
			btn_ok.addEventListener(Event.TRIGGERED, onClick);
		}

		private function onClick() : void
		{
			if (txt_input1.text != "" && txt_input2.text != "")
				DAndroidHttpServer.getInstance().pay_MyCard1(txt_input1.text, txt_input2.text);
			else
				addTips("input_mycard");
		}
	}
}