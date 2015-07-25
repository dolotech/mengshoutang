package game.view.tipPanel
{
	import com.dialog.Dialog;
	import com.langue.Langue;
	
	import starling.events.Event;

	public class TipPanelDlg extends Dialog
	{
		public function TipPanelDlg()
		{
			
			_closeStuat = "";
			
			clickBackroundClose();
		}
		
		/**
		 *充值面板 
		 */	
		public function createRecharge():void
		{
			var base:TipPanelRechargeBase = new TipPanelRechargeBase;
			base.ButtonNameTxt.text = Langue.getLangue("Recharge");
			base.ButtonNameTxt.touchable = false;
			base.TipCaptionTxt.text = Langue.getLangue("notDiamendBuy");
			base.clickButton.addEventListener(Event.TRIGGERED,onRecharge);
			addChild(base);
			var i:int = 0;
			while(i < base.numChildren)
			{
				base.getChildAt(i++).touchable = true;
			}
			base.ButtonNameTxt.touchable = false;
		}
		/**
		 *确认提示面板 
		 */	
		public function createVerify(caption:String,okFun:Function,cancelFun:Function):void
		{
			var base:TipPanelVerifyBase = new TipPanelVerifyBase;
			base.okButton.text = Langue.getLangue("OK");
			base.cancelButton.text = Langue.getLangue("CANCEL");
			base.titleTxt.text = Langue.getLangue("tips_title");
			base.okButton.fontSize = base.cancelButton.fontSize = 30;
			base.okButton.fontColor = base.cancelButton.fontColor = 0xffffff;
			addChild(base);
			base.captionTxt.text = caption;
			base.okButton.addEventListener(Event.TRIGGERED,okFun);
			base.cancelButton.addEventListener(Event.TRIGGERED,cancelFun);
		}
		
		
		//点击充值
		private function onRecharge(e:Event):void
		{

		}
	}
}