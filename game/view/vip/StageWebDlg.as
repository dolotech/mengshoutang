package game.view.vip
{
	import com.dialog.Dialog;
	import com.utils.Constants;

	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	import flash.events.LocationChangeEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;

	import starling.core.Starling;

	public class StageWebDlg extends Dialog
	{
		private var webView : StageWebView;

		public function StageWebDlg()
		{
			super(true);
		}

		override protected function init() : void
		{
			clickBackroundClose(0.5);
			webView = new StageWebView();
			webView.stage = Starling.current.nativeStage;
			webView.viewPort = new Rectangle(Constants.FullScreenWidth * .1, Constants.FullScreenHeight * .1, Constants.FullScreenWidth * .8, Constants.FullScreenHeight * .8);
			webView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, getUpdate);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKey, false, 10);
		}

		private function onKey(event : KeyboardEvent) : void
		{
			//安卓退出键
			if (!Constants.iOS && event.keyCode == 16777238)
			{
				event.preventDefault();
				close();
			}
		}

		public function getUpdate(event : LocationChangeEvent) : void
		{
			if (event.location.indexOf("onlinepay/payment") >= 0)
				close();

//			if (event.location.indexOf("www.paypal.com") >= 0)
//				ShowLoader.remove();
		}

		override protected function show() : void
		{
			webView.loadURL(_parameter as String);
		}

		override public function dispose() : void
		{
			super.dispose();
			NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
			webView.removeEventListener(LocationChangeEvent.LOCATION_CHANGE, getUpdate);
			webView.dispose();
		}
	}
}