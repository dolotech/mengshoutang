package game.view.activity.activity.AllGifts
{
	import com.components.RollTips;
	import com.langue.Langue;
	import com.mvc.interfaces.INotification;
	import com.webchat.WebChat;

	import flash.utils.getTimer;

	import game.data.ActivityNum;
	import game.data.FestPrizeData;
	import game.dialog.ShowLoader;
	import game.manager.AssetMgr;
	import game.net.GameSocket;
	import game.net.data.c.CWeixinShare;
	import game.net.data.c.CWeixinSharePrize;
	import game.net.data.s.SWeixinSharePrize;
	import game.net.data.vo.FestValues;
	import game.view.activity.base.AllGiftsBase.MicroChannelBase;

	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.events.Event;

	/**
	 *
	 * @author 微信分享
	 *
	 */
	public class MicroChannel extends MicroChannelBase implements IGifts
	{
		private var festValues : FestValues;
		private var time : int;
		private static var lastTime : int;
		private var loadUrl : String;

		public function MicroChannel()
		{
			super();
			receiveButton.text = Langue.getLangue("signRewardReceiveButton");
			receiveButton.addEventListener(Event.TRIGGERED, onReceive);
			receiveButton.fontSize = 30;
			receiveButton.fontColor = 0xffffcc;

			if (lastTime == 0)
				lastTime = getTimer();
		}
		private var anum : ActivityNum;

		public function set data(value : ActivityNum) : void
		{
			var i : int = 0;
			var len : int = value.ids.length;
			var values : FestValues;
			var data : FestPrizeData;
			loadUrl = value.loadUrl;
			anum = value;

			for (i; i < len; i++)
			{
				values = (value.ids[i] as FestValues)

				if (value.id == values.id)
				{
					data = FestPrizeData.hash.getValue(value.id + "" + values.num);
					contentTxt.text = value.caption;
					festValues = values;
					showGoods(data);
					time = values.val;
					updateTime();

					if (festValues.state == 1)
					{
						receiveButton.text = Langue.getLangue("signRewardReceiveButton");
					}
					else
						receiveButton.text = Langue.getLangue("fengxiang");

					break;
				}
			}
		}
		private var _delayCall : DelayedCall;

		override public function dispose() : void
		{
			Starling.juggler.remove(_delayCall);
			lastTime = 0;
			super.dispose();
		}
		private var cd : int

		private function updateTime() : void
		{
			cd = (time - (getTimer() - lastTime) / 1000);

			if (cd > 0)
			{
				_delayCall = Starling.juggler.delayCall(updateTime, 1);
				cdTxt.text = Langue.getLangue("ReceiveCd") + ((cd / 60 / 60 >> 0) + ":" + (cd / 60 % 60 >> 0) + ":" + cd % 60);
			}
			else
			{
				cdTxt.text = "";
			}

		}
		private var box : Box;

		private function showGoods(fest : FestPrizeData) : void
		{
			box = new Box(AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang0"));
			box.data = fest;
			receiveButton.addEventListener(Event.TRIGGERED, onReceive);
			addChild(box);
			box.stuat = festValues.state;
		}

		private function send() : void
		{
			var cmd : CWeixinSharePrize = new CWeixinSharePrize();
			GameSocket.instance.sendData(cmd);
			ShowLoader.add();
		}

		override public function handleNotification(_arg1 : INotification) : void
		{
			var info : SWeixinSharePrize = _arg1 as SWeixinSharePrize;

			if (info.code == 0)
			{
				Starling.juggler.remove(_delayCall);
				time = info.num;
				lastTime = getTimer();
				updateTime();
				RollTips.add(Langue.getLangue("signRewardSucceed"));
			}
			else if (info.code == 1)
			{
				RollTips.add(Langue.getLangue("useReceive"));
			}
			else if (info.code >= 127)
			{
				RollTips.add(Langue.getLangue("codeError"));
			}
			ShowLoader.remove();
		}

		override public function listNotificationName() : Vector.<String>
		{
			var vect : Vector.<String> = new Vector.<String>;
			vect.push(CWeixinSharePrize.CMD);
			return vect;
		}


		private function onReceive(e : Event) : void
		{
			if (box.stuate == 1)
			{
				send();
			}
			else
			{
				try
				{
					WebChat.manager.registerApp("wx3bc2fdf323421815");
					WebChat.manager.shareWeChat("", Langue.getLangue("WeChat").replace("*", anum.code), loadUrl, "icon/icon/App114.png", 1);
					WebChat.manager.addEventListener("RespResult", onRespResult);
				}
				catch (e : Error)
				{
					trace(this);
				}
				onRespResult("0");
			}
		}

		private function sendState() : void
		{
			var cmd : CWeixinShare = new CWeixinShare();
			GameSocket.instance.sendData(cmd);
		}

		private function onRespResult(e : String) : void
		{
			var code : int = int(e);

			if (code == 0)
			{
				if (cd <= 0)
				{
					sendState();
					box.stuate = 1;
					receiveButton.text = getLangue("signRewardReceiveButton");
				}
			}
			else
			{
				addTips("WeChatNot");
			}
		}
	}
}