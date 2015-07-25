package game.manager
{
	import com.dialog.Dialog;
	import com.dialog.DialogMgr;
	import com.mobileLib.utils.ConverURL;
	import com.view.View;
	
	import game.dialog.ShowLoader;
	import game.view.vip.AndroidPayView;
	import game.view.vip.MyCardPayView;
	import game.view.vip.StageWebDlg;

	/**
	 * UI管理器
	 * @author hyy
	 *
	 */
	public class UiManager
	{
		/**
		 * 安卓支付界面
		 */
		public static const ANDROID_PAY : int = 1;
		/**
		 * 网页界面
		 */
		public static const STAGE_WEB : int = 2;
		/**
		 * mycard支付 
		 */
		public static const MYCARD_PAY : int = 3;

		public static function loadAndOpenView(viewId : int, parameter : Object = null) : void
		{
			var loadUi : String;

			switch (viewId)
			{
				case ANDROID_PAY:
					loadUi = "chongzhi";
					break;
				case MYCARD_PAY:
					loadUi = "chongzhi";
					break;
			}
			ShowLoader.add();
			AssetMgr.instance.enqueue(ConverURL.conver("newUi/" + loadUi));
			AssetMgr.instance.loadQueue(onComplement);

			function onComplement(ratio : Number) : void
			{
				if (ratio == 1.0)
				{
					ShowLoader.remove();
					var view : View = openView(viewId, parameter);
					view.addEventListener(Dialog.CLOSE_CONTAINER, onRemoveView);

					function onRemoveView() : void
					{
						view.removeEventListener(Dialog.CLOSE_CONTAINER, onRemoveView);
						AssetMgr.instance.removeUi(loadUi, "newUi/" + loadUi);
					}
				}
			}
		}

		public static function openView(viewId : int, parameter : Object = null) : View
		{
			var view : View;

			switch (viewId)
			{
				case ANDROID_PAY:
					view = DialogMgr.instance.open(AndroidPayView, parameter) as View;
					break;
				case STAGE_WEB:
					view = DialogMgr.instance.open(StageWebDlg, parameter) as View;
					break;
				case MYCARD_PAY:
					view = DialogMgr.instance.open(MyCardPayView, parameter) as View;
					break;
			}
			return view;
		}
	}
}