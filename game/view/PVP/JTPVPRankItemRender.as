package game.view.PVP
{
	import com.components.RollTips;
	import com.langue.Langue;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import game.common.JTFormulaUtil;
	import game.common.JTLogger;
	import game.data.Robot;
	import game.manager.AssetMgr;
	import game.managers.JTPvpInfoManager;
	import game.managers.JTSingleManager;
	import game.net.GameSocket;
	import game.net.data.c.CColiseumRivalFightInfo;
	import game.net.data.c.CColiseumRivalHero;
	import game.net.data.vo.ColiseumRankInfo;
	import game.view.PVP.ui.JTUIPvpRankItem;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class JTPVPRankItemRender extends DefaultListItemRenderer
	{
		private var item:JTUIPvpRankItem = null;
		private const MAX_SIZE:int = 10;
		public function JTPVPRankItemRender()
		{
			super();
			item = new JTUIPvpRankItem();
			this.defaultSkin = item;
			this.item.txt_head.touchable = false;
			this.item.addEventListener(TouchEvent.TOUCH, onLookHeroHandler);
		}
		
		private var isDown:Boolean = false;
		private var moveLostX:Number = 0;
		private var moveLostY:Number = 0;
		private function onLookHeroHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			if (!touch)
			{
				return;
			}
			var currentTarget:DisplayObject = e.target as DisplayObject;
			if (touch.phase == TouchPhase.BEGAN)
			{
				isDown = true;
				this.moveLostX = touch.globalX;
				this.moveLostY = touch.globalY;
				return;
			}
			if (touch.phase != TouchPhase.ENDED)
			{
				return;
			}
			if (this.moveLostX + MAX_SIZE < touch.globalX && isDown
				|| this.moveLostX - MAX_SIZE > touch.globalX && isDown
				|| this.moveLostY + MAX_SIZE < touch.globalY && isDown
				|| this.moveLostY - MAX_SIZE > touch.globalY && isDown)
			{
				isDown = false;
				return;
			}
			isDown = false;
			var paren:Sprite = currentTarget.parent as Sprite;
			var rankInfo:ColiseumRankInfo = this.data as ColiseumRankInfo;
			if (paren.parent === this.item.btn_pk)
			{
				if (!this.data)
				{
					return;
				}
				var pvpInfoManager:JTPvpInfoManager = JTSingleManager.instance.pvpInfoManager;
				var errors:Array = Langue.getLans("pvpErrors");
//				if (pvpInfoManager.rank < rankInfo.pos)
//				{
//					RollTips.add(errors[3]);
//					return;
//				}
				if (pvpInfoManager.rank == rankInfo.pos)
				{
					RollTips.add(errors[2]);
					return;
				}
				JTPvpInfoManager.type = JTPvpInfoManager.TYPE_PVP;
				var sendPkPackage:CColiseumRivalFightInfo = new CColiseumRivalFightInfo();
				sendPkPackage.id = rankInfo.id;
				sendPkPackage.type = JTPvpInfoManager.TYPE_PVP;
				sendPkPackage.index = rankInfo.pos;
				JTPvpInfoManager.pvpRid = rankInfo.rid;
				JTLogger.info("[JTPvpRankItemRender.]" + JTPvpInfoManager.pvpRid);
				GameSocket.instance.sendData(sendPkPackage);
			}
			else
			{
				if (!this.data)
				{
					return;
				}
				var lines:Array = (rankInfo.name as String).split(".");
				if (rankInfo.name == "^." + rankInfo.rid + ".$")
				{
					RollTips.showTips("robot");
					return;
				}
				var sendlookHeros:CColiseumRivalHero = new CColiseumRivalHero();
				sendlookHeros.id = rankInfo.rid;
				JTPvpInfoManager.hero_title = rankInfo.name;
				GameSocket.instance.sendData(sendlookHeros);
			}
		}
		
		private function onPkHandler(e:Event):void
		{
			if (!this.data)
			{
				return;
			}
			var pvpInfoManager:JTPvpInfoManager = JTSingleManager.instance.pvpInfoManager;
			var rankInfo:ColiseumRankInfo = data as ColiseumRankInfo;
			var errors:Array = Langue.getLans("pvpErrors");
//			if (pvpInfoManager.rank < rankInfo.pos)
//			{
//				RollTips.add(errors[3]);
//				return;
//			}
			if (pvpInfoManager.rank == rankInfo.pos)
			{
				RollTips.add(errors[2]);
				return;
			}
			JTPvpInfoManager.type = JTPvpInfoManager.TYPE_PVP;
			var sendPkPackage:CColiseumRivalFightInfo = new CColiseumRivalFightInfo();
			sendPkPackage.id = rankInfo.id;
			sendPkPackage.type = JTPvpInfoManager.TYPE_PVP;
			GameSocket.instance.sendData(sendPkPackage);
			e.stopImmediatePropagation();
		}
		
		override public function set data(value:Object):void
		{
			if (!value)
			{
				return;
			}
			var rankInfo:ColiseumRankInfo = value as ColiseumRankInfo;
			var btn_head:Button = this.item.txt_head;
			var lines:Array = (rankInfo.name as String).split(".");
			var pvpInfoManager:JTPvpInfoManager = JTSingleManager.instance.pvpInfoManager;
			var robot:Robot=Robot.hash.getValue(int(lines[1]));
			var name:String = lines[0] == "^" ? robot.name : rankInfo.name ;
			var img_head:Image = this.item.txt_head.getChildByName("head") as Image;
			if (!img_head)
			{
				img_head = new Image(AssetMgr.instance.getTexture("ui_pvp_renwutouxiang" + rankInfo.picture));
				img_head.name = "head";
				this.item.txt_head.addChildAt(img_head, this.item.txt_head.numChildren - 2);
			}
			else
			{
				img_head.texture = AssetMgr.instance.getTexture("ui_pvp_renwutouxiang" + rankInfo.picture);
			}
			this.item.txt_no.text = rankInfo.pos.toString();
			this.item.txt_name.text = name;
			this.item.txt_horn.text = Langue.getLangue("everyday") + "+" + JTFormulaUtil.getRankHonor(rankInfo.pos).toString();
			this.item.txt_fight.text = rankInfo.power.toString();
			this.item.textField.text = "0";
//			if (rankInfo.pos >= pvpInfoManager.rank)
//			{
//				this.item.btn_pk.upState = AssetMgr.instance.getTexture("ui_button_abattoir_tiaozhan1");
//			}
//			else
			{
				this.item.btn_pk.upState = AssetMgr.instance.getTexture("ui_button_abattoir_tiaozhan");
			}
			super.data = value;
		}
		
		override public function dispose():void
		{
			this.item.dispose();
			super.dispose();
		}
	}
}