package game.view.activity.activity.AllGifts
{
	import com.components.RollTips;
	import com.langue.Langue;
	import com.mvc.interfaces.INotification;
	
	import flash.geom.Rectangle;
	
	import game.dialog.ShowLoader;
	import game.net.GameSocket;
	import game.net.data.c.CInviteVerify;
	import game.net.data.s.SInviteVerify;
	import game.view.activity.base.AllGiftsBase.InputCodeBase;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	public class InputCode extends InputCodeBase
	{
		public function InputCode()
		{
			super();
			yesButton.text = Langue.getLangue("noticeDlgClose");
			noButton.text = Langue.getLangue("signRewardResignMsgCloseText");
			yesButton.fontSize  = noButton.fontSize = 28;
			yesButton.fontColor= noButton.fontColor = 0xffffcc;
			_closeButton = noButton;
			yesButton.addEventListener(Event.TRIGGERED,onYes);
			
		}
		
		private function onYes(e:Event):void
		{
			if(inputCodeTxt.text == "")
			{
				RollTips.add(Langue.getLangue("codeNull"));
			}
			else 
			{
				var cmd:CInviteVerify = new CInviteVerify();
				cmd.account = int(inputCodeTxt.text);
				GameSocket.instance.sendData(cmd);
				ShowLoader.add();
			}
		}
		
		public var onSuccess:ISignal = new Signal();
		override public function handleNotification(_arg1:INotification):void
		{
			var info:SInviteVerify = _arg1 as SInviteVerify;
			if(info.code == 0)
			{
				RollTips.add(Langue.getLangue("BindingSuccess"));
				onSuccess.dispatch();
				close();
			}
			else if(info.code == 1)
			{
				RollTips.add(Langue.getLangue("BindingCode"));
			}
			else if(info.code == 2)
			{
				RollTips.add(Langue.getLangue("BingLonge"));
			}
			else if(info.code >= 127)
			{
				RollTips.add(Langue.getLangue("codeError") + info.code);
			}
			ShowLoader.remove();
		}
		
		override public function listNotificationName():Vector.<String>
		{
			var vect:Vector.<String> = new Vector.<String>;
			vect.push(SInviteVerify.CMD);
			return vect;
		}
		
		override public function open(container:DisplayObjectContainer, parameter:Object=null, okFun:Function=null, cancelFun:Function=null):void
		{
			super.open(container, parameter, okFun, cancelFun);
			setToCenter();
			
			var rect:Rectangle =  inputCodeTxt.viewPort;
			rect.x += this.x;
			rect.y += this.y;
			inputCodeTxt.viewPort = rect;
		}
		
		override public function dispose():void
		{
			onSuccess.removeAll();
			super.dispose();
		}
	}
}