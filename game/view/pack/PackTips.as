package game.view.pack
{
	import com.langue.Langue;
	import game.view.loginReward.ResignDlg;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import starling.events.Event;
	
	public class PackTips extends ResignDlg
	{
		public var onOk:ISignal = new Signal();
		public function PackTips()
		{
			super();
			enableTween=false;
			txt_title.text = Langue.getLangue("tips_title");
		}
		
		override protected function onOKButtonClick(e:Event):void
		{
			onOk.dispatch();
			close();
		}
		
		public function set data(value:int):void
		{
			
		}
	}
}