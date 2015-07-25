package game.view.activity.activity.AllGifts
{
	import com.components.RollTips;
	import com.dialog.DialogMgr;
	import com.langue.Langue;
	import com.mvc.interfaces.INotification;
	
	import game.common.JTGlobalDef;
	import game.data.ActivityNum;
	import game.data.FestPrizeData;
	import game.dialog.ShowLoader;
	import game.manager.AssetMgr;
	import game.manager.GameMgr;
	import game.net.GameSocket;
	import game.net.data.c.CVerifyGetPrize;
	import game.net.data.s.SVerifyGetPrize;
	import game.net.data.vo.FestValues;
	import game.view.activity.base.AllGiftsBase.BindingGoodFriendBase;
	
	import starling.events.Event;
	
	/**
	 * 
	 * @author litao 绑定好友
	 * 
	 */
	public class BindingGoodFriend extends BindingGoodFriendBase implements IGifts
	{
		
		private var festValues:FestValues;
		public function BindingGoodFriend()
		{
			receiveButton.text = Langue.getLangue("signRewardReceiveButton");
			receiveButton.addEventListener(Event.TRIGGERED,onReceive);
			receiveButton.fontSize = 30;
			receiveButton.fontColor = 0xffffcc;
		}
		
		
		private function onReceive(e:Object = null):void
		{
			if (GameMgr.instance.tollgateID >= JTGlobalDef.BUILDING_FRIEND_TOLLTAGE)
			{
				if(box.stuate == 1)
				{
					send();
				}
				else if(box.stuate == 2) 
				{
					RollTips.add(Langue.getLangue("useReceive"));
				}
				else 
				{
					var tip:InputCode = DialogMgr.instance.open(InputCode) as InputCode;
					tip.onSuccess.addOnce(function ():void
					{
						box.stuate = 1;
					});
				}
			}
			else
			{
				RollTips.add(Langue.getLangue("tollgateMinH"));
			}
		}
		
		private function send():void
		{
			
			var cmd:CVerifyGetPrize = new CVerifyGetPrize();
			GameSocket.instance.sendData(cmd);
			ShowLoader.add();
			
		}
		
		public function set data(value:ActivityNum):void
		{
			var i:int = 0;
			var len:int = value.ids.length;
			var values:FestValues;
			var data:FestPrizeData;
			
			
			for(i ; i < len ; i ++)
			{
				values = ( value.ids[i]as FestValues)
				
				if(value.id == values.id)
				{
					
					data = FestPrizeData.hash.getValue(value.id + "" + values.num);
					festValues = values;
					contentTxt.text = value.caption;
					showGoods(data);
					break;
				}
			}
		}
		private var box:Box ; 
		private function showGoods(fest:FestPrizeData):void
		{
			box = new Box(AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang0"));
			box.data = fest;
			addChild(box);
			box.stuat = festValues.state;
		}
		
		override public function handleNotification(_arg1:INotification):void
		{
			var info:SVerifyGetPrize = _arg1 as SVerifyGetPrize;
			if(info.code == 0)
			{
				RollTips.add(Langue.getLangue("signRewardSucceed"));
				box.stuate = 2;
			}
			else if(info.code == 1)
			{
				RollTips.add(Langue.getLangue("useReceive"));
			}
			else if(info.code==2)
			{
				RollTips.add(Langue.getLangue("codeError"));
			}
			else 
				RollTips.add(Langue.getLangue("codeError") + info.code);
			
			ShowLoader.remove();
		}
		
		override public function listNotificationName():Vector.<String>
		{
			var vect:Vector.<String> = new Vector.<String>;
			vect.push(SVerifyGetPrize.CMD);
			return vect;
		}
		
	}
}