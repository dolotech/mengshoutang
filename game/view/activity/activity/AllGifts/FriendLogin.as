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
	import game.net.data.c.CLoginGetPrize;
	import game.net.data.s.SLoginGetPrize;
	import game.net.data.vo.FestValues;
	import game.view.activity.base.AllGiftsBase.FriendLoginBase;
	
	import starling.events.Event;
	
	/**
	 * 
	 * @author 好友登录
	 * 
	 */	
	public class FriendLogin extends FriendLoginBase  implements IGifts
	{
		private var festValues:FestValues;
		public function FriendLogin()
		{
			super();
			var i:int = 0;
			var len:int = 4;
			for(i = 0 ; i<4; i ++)
			{
				this["r" + (i+1) + "Image"].texture = AssetMgr.instance.getTexture("ui_activities_diamond_search_denglu5");
			}
			parImage.width = 0;
			receiveButton.text = Langue.getLangue("signRewardReceiveButton");
			receiveButton.addEventListener(Event.TRIGGERED,onReceive);
			receiveButton.fontSize = 30;
			receiveButton.fontColor = 0xffffcc;
		}
		private var value:FestPrizeData;
		public function set data(value:ActivityNum):void
		{
			var i:int = 0;
			var len:int = value.ids.length;
			var values:FestValues;
			for(i ; i < len ; i ++)
			{
				values = ( value.ids[i]as FestValues)
				if(value.id == values.id)
				{
					this.value = FestPrizeData.hash.getValue(value.id + "" + values.num);
					contentTxt.text = value.caption;
					festValues = values;
					showGoods(this.value);
					showProgress();
					showText();
					break;
				}
			}
		}
		
		private function showText():void
		{
			var i:int = 0;
			var len:int = 4;
			var fest:FestPrizeData 
			for(i = 1 ; i<5; i ++)
			{
				fest = FestPrizeData.hash.getValue(value.id + "" + i);
				this["text" + (i) + "Txt"].text = fest.condition + "";
			}
		}
		
		private function showProgress():void
		{
			if(value.id2 > 0)
			{
				var len:int = value.id2;
				var i:int ;
				for (i = 1 ; i <= len ; i ++)
				{
					var data:FestPrizeData = FestPrizeData.hash.getValue(value.id + "" + i);
					if(festValues.val >= data.condition)
					this["r" + (i) + "Image"].texture = AssetMgr.instance.getTexture("ui_activities_diamond_search_denglu4");
				}
				this.parImage.width = this["r" + (value.id2) + "Image"].x - this["r" + (1)+"Image"].x;
			}
		}
		
		private var box:Box;
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
			var info:SLoginGetPrize = _arg1 as SLoginGetPrize;
			if(info.code == 0)
			{
				RollTips.add(Langue.getLangue("signRewardSucceed"));
				
				festValues .num = info.num;
				box.stuate = info.state;
				this.value = FestPrizeData.hash.getValue(value.id + "" + festValues.num);
				showProgress();
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
				RollTips.add(Langue.getLangue("codeError") + info.code);
			}
			ShowLoader.remove();
		}
		
		override public function listNotificationName():Vector.<String>
		{
			var vect:Vector.<String> = new Vector.<String>;
			vect.push(SLoginGetPrize.CMD);
			return vect;
		}
		
		
		private function send():void
		{
			var cmd:CLoginGetPrize = new CLoginGetPrize();
			GameSocket.instance.sendData(cmd);
			ShowLoader.add();
		}
		
		private function onReceive(e:Object):void
		{
			if(box.stuate == 0)
			{
				RollTips.add(Langue.getLangue("notReceive"));
			}
			else if(box.stuate == 1)
			{
				send();
			}
			else if(box.stuate == 2)
			{
				RollTips.add(Langue.getLangue("useReceive"));
			}
		}
	}
}