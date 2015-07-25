package game.view.activity.activity.AllGifts
{
	import com.components.RollTips;
	import com.langue.Langue;
	import com.mvc.interfaces.INotification;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import game.data.ActivityNum;
	import game.data.FestPrizeData;
	import game.dialog.ShowLoader;
	import game.manager.AssetMgr;
	import game.net.GameSocket;
	import game.net.data.c.CGrade;
	import game.net.data.c.CGradeGetPrize;
	import game.net.data.s.SGrade;
	import game.net.data.s.SGradeGetPrize;
	import game.net.data.vo.FestValues;
	import game.view.activity.base.AllGiftsBase.RatingBase;
	
	import starling.events.Event;

	/**
	 * 
	 * @author 评星
	 * 
	 */	
	public class Rating extends RatingBase  implements IGifts
	{
		private var festValues:FestValues;
		private var ratingUrl:String;
		public function Rating()
		{
			super();
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
			ratingUrl = value.ratingUrl;
			for(i ; i < len ; i ++)
			{
				values = ( value.ids[i]as FestValues)
				if(value.id == values.id)
				{
					data = FestPrizeData.hash.getValue(value.id + "" + values.num);
					contentTxt.text = value.caption;
					festValues = values;
					showGoods(data);
					
					break;
				}
			}
		}
		
		override public function handleNotification(_arg1:INotification):void
		{
			if(_arg1.getName() == String(SGradeGetPrize.CMD))
			{
				var info:SGradeGetPrize = _arg1 as SGradeGetPrize;
				if(info.code == 0)
				{
					RollTips.add(Langue.getLangue("signRewardSucceed"));
					box.stuate = 2;
					receiveButton.text = Langue.getLangue("rating");
				
				}
				else if(info.code == 1)
				{
					
					RollTips.add(Langue.getLangue("useReceive"));
				}
				else if(info.code >= 127)
				{
					RollTips.add(Langue.getLangue("codeError")+info.code);
				}
			}
			else 
			{
				var info1:SGrade = _arg1 as SGrade;
				if(info1.code == 0)
				{
					box.stuate=1;
					receiveButton.text = Langue.getLangue("signRewardReceiveButton");
				}
				else if(info1.code == 1)
				{
					box.stuate = 1;
					receiveButton.text = Langue.getLangue("signRewardReceiveButton");
				}
				else if(info1.code >= 127)
				{
					RollTips.add(Langue.getLangue("codeError")+info.code);
				}
			}
			ShowLoader.remove();
		}
		
		override public function listNotificationName():Vector.<String>
		{
			var vect:Vector.<String> = new Vector.<String>;
			vect.push(SGradeGetPrize.CMD);
			vect.push(SGrade.CMD);
			return vect;
		}
		
		private function send():void
		{
			var cmd:CGradeGetPrize = new CGradeGetPrize;
			GameSocket.instance.sendData(cmd);
			ShowLoader.add();
		}
		
		
		private var box:Box;
		private function showGoods(fest:FestPrizeData):void
		{
			box = new Box(AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang0"));
			box.data = fest;
			addChild(box);
			box.stuat = festValues.state;
			if(box.stuate == 1)
			{
				receiveButton.text = Langue.getLangue("signRewardReceiveButton");
			}
			else receiveButton.text = Langue.getLangue("rating");
		}
		private function onReceive(e:Event):void
		{
			if(box.stuate == 1)
			{
				send();
			}
			else 
			{
				var url:URLRequest = new URLRequest(ratingUrl);
				navigateToURL(url, "_blank");
				
				var cmd:CGrade = new CGrade();
				GameSocket.instance.sendData(cmd);
				ShowLoader.add();
			}
		}
		
	}
}