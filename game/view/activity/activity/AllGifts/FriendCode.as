package game.view.activity.activity.AllGifts
{
	import com.components.RollTips;
	import com.langue.Langue;
	import com.mvc.interfaces.INotification;
	import com.utils.TouchProxy;
	
	import game.data.ActivityNum;
	import game.data.FestPrizeData;
	import game.dialog.ShowLoader;
	import game.manager.AssetMgr;
	import game.net.GameSocket;
	import game.net.data.c.CInviteGetPrize;
	import game.net.data.s.SInviteGetPrize;
	import game.net.data.vo.FestValues;
	import game.view.activity.base.AllGiftsBase.FriendCodeBase;
	
	import starling.events.Event;

	/**
	 * 
	 * @author 邀请好友
	 * 
	 */	
	public class FriendCode extends FriendCodeBase implements IGifts
	{
		private var festValues:FestValues;
		public function FriendCode()
		{
			super();
			youCodeTxt.text = Langue.getLangue("youCode");
			
			receiveButton.text = Langue.getLangue("signRewardReceiveButton");
			receiveButton.addEventListener(Event.TRIGGERED,onReceive);
			receiveButton.fontSize = 30;
			receiveButton.fontColor = 0xffffcc;
		}
		
		public function set data(value:ActivityNum):void
		{
			var i:int = 0;
			var len:int = value.ids.length;
			var values:FestValues;
			var data:FestPrizeData;
			codeTxt.text = value.code+"";
			for(i ; i < len ; i ++)
			{
				values = ( value.ids[i]as FestValues)
				if(value.id == values.id)
				{
					data = FestPrizeData.hash.getValue(value.id + "" + values.num);
					festValues = values;
					contentTxt.text = value.caption;
					showGoods(data);
					herosTxt.text=Langue.getLangue("heros") + values.val +"/" +  data.condition;
					if(values.val  < data.condition )
						herosTxt.color = 0xff0000;
					else herosTxt.color = 0x00ff00;
					break;
				}
			}
		}
		private var box:Box ;
		private function showGoods(fest:FestPrizeData):void
		{
			box = new Box(AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang0"));
			box.data = fest;
			var touch:TouchProxy = new TouchProxy(box);
			touch.onClick.add(onReceive);
			addChild(box);
			box.stuat = festValues.state;
		}
		
		override public function handleNotification(_arg1:INotification):void
		{
			var info:SInviteGetPrize  = _arg1 as SInviteGetPrize;
			if(info.code == 0)
			{
				RollTips.add(Langue.getLangue("signRewardSucceed"));
				festValues.num = info.num;
				var data:FestPrizeData = FestPrizeData.hash.getValue(festValues.id + "" + info.num);
				herosTxt.text=Langue.getLangue("heros") + festValues.val +"/" +  data.condition;
				box.stuate = info.state;
			}
			else if(info.code == 1)
			{
				RollTips.add(Langue.getLangue("notReceive"));
			}
			else if(info.code == 2)
			{
				RollTips.add(Langue.getLangue("useReceive"));
			}
			else if(info.code == 3)
			{
				RollTips.add(Langue.getLangue("packFulls"));
			}
			else if(info.code >= 127)
			{
				RollTips.add(Langue.getLangue("codeError")+info.code);
			}
			ShowLoader.remove();
		}
		
		override public function listNotificationName():Vector.<String>
		{
			var vect:Vector.<String> = new Vector.<String>;
			vect.push(SInviteGetPrize.CMD);
			return vect;
		}
		
		
		private function send():void
		{
			var cmd:CInviteGetPrize = new CInviteGetPrize();
			GameSocket.instance.sendData(cmd);
			ShowLoader.add();
		}
		
		
		private function onReceive(e:Object):void
		{
			if(box.stuate == 1)
			{
				send();
			}
			else if(box.stuate == 2)
			{
				RollTips.add(Langue.getLangue("alreadyUse"));
			}
			else if(box.stuate == 0)
			{
				RollTips.add(Langue.getLangue("notReceive"));
			}
		}
	}
}