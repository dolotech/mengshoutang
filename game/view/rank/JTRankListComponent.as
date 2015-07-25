package game.view.rank
{
	import com.components.RollTips;
	import com.dialog.DialogMgr;
	import com.langue.Langue;
	import com.utils.StringUtil;
	
	import flash.geom.Point;
	
	import feathers.core.PopUpManager;
	
	import game.common.JTGlobalDef;
	import game.common.JTGlobalFunction;
	import game.common.JTLogger;
	import game.common.JTScrollerMenu;
	import game.manager.GameMgr;
	import game.managers.JTFunctionManager;
	import game.managers.JTRankListInfoManager;
	import game.managers.JTSingleManager;
	import game.net.GameSocket;
	import game.net.data.IData;
	import game.net.data.c.CRankHero;
	import game.net.data.vo.RankInfo;
	import game.view.rank.ui.JTUIRankBackground;
	import game.view.vip.VipDlg;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

import starling.events.Event;

	/**
	 *排行榜列表  
	 * @author Administrator
	 * 
	 */	
	public class JTRankListComponent extends JTUIRankBackground
	{
		public static var instance:JTRankListComponent = null;
		private var scrollerRankList:JTScrollerMenu = null;
        public var onClose:ISignal;
		public function JTRankListComponent()
		{
			super();
			initialize();
		}
		
		private function initialize():void
		{
            onClose = new Signal(JTRankListComponent);
			JTRankListInfoManager.rankType = JTRankListInfoManager.RANK_FIGHT;
			var rankTitle:String = Langue.getLangue("rankTitle");
			StringUtil.changePriceText(GameMgr.instance.coin,coin,coinEnd)
			this.diamond.text = GameMgr.instance.diamond+"";
			this.txt_my_rank.text = rankTitle;
			this.btn_close.addEventListener(Event.TRIGGERED, onCloseHandler);
			JTScrollerMenu.show(this ,null, onMouseClickHandler, Langue.getLans("rankType"));
			JTScrollerMenu.localToGlobal(this.scale_mc_rank_menu.localToGlobal(new Point()));
			JTScrollerMenu.getInstance().layout = JTScrollerMenu.getInstance().getDefaultLayout();
			JTFunctionManager.registerFunction(JTGlobalDef.LOOK_OVER_HERO, onLookOverHerosResponse);
			JTFunctionManager.registerFunction(JTGlobalDef.REFRESH_RANK_LIST, onRefreshAllRankList);
			JTFunctionManager.executeFunction(JTGlobalDef.STOP_CITY_ANIMATABLE);
			notifyRefreshScroller(JTRankListInfoManager.rankType);
			btn_chong.addEventListener(Event.TRIGGERED,onChargeButtonClick);
		}
		
		private function onChargeButtonClick(e:Event):void
		{
			DialogMgr.instance.open(VipDlg,VipDlg.CHARGE);
		}
		
		private function onCloseHandler(e:Event):void
		{
			close();
		}
		
		//排行榜玩家名字
		private var title_name:String = null;
		/**
		 *查看英雄面板 
		 * @param result
		 * 
		 */		
		private function onLookOverHerosResponse(result:Object):void
		{
			JTHerosHallComponent.show(this, JTGlobalFunction.converHeros(result.heroes));
			JTHerosHallComponent.showTitle(title_name);
		}
		
		private function onMouseClickHandler(itemName:String):void
		{
			if (!itemName)
			{
				JTLogger.error("[]");
			}
			var lines:Array = itemName.split(":");
			var renderName:String = lines[1];
			switch(renderName)
			{
				case "btn_pvp":
				{
					notifyRefreshScroller(JTRankListInfoManager.RANK_PVP);
					break;
				}
				case "btn_star":
				{
					notifyRefreshScroller(JTRankListInfoManager.RANK_STAR);
					break;
				}
				case "btn_money":
				{
					notifyRefreshScroller(JTRankListInfoManager.RANK_MONEY);
					break;
				}
				case "btn_fight":
				{
					notifyRefreshScroller(JTRankListInfoManager.RANK_FIGHT);
					break;
				}
			}
		}
		
		private var rank_myItem:JTRankItemRender = null;
		private function notifyRefreshScroller(rankType:int):void
		{
			var rankTitles:Array = Langue.getLans("gameRankTitles");
			var rankTitle:String = rankTitles[rankType - 1];
			this.txt_rank_type.text = rankTitle;
			var rankListInfoManager:JTRankListInfoManager = JTSingleManager.instance.rankListInfoManager;
			JTRankListInfoManager.rankType = rankType;
			var rankInfoList:Vector.<IData> = rankListInfoManager.getRankInfos(JTRankListInfoManager.rankType);
			onRefreshAllRankList(rankInfoList);
		}
		
		private function onRefreshAllRankList(rankInfoList:Vector.<IData>):void
		{
			if (!rankInfoList)
			{
				if (this.rank_myItem) 
				{
					this.rank_myItem.visible = false; 
				}
				return;
			}
			createMyselfRank(rankInfoList);
			onRefreshScrollerRankList(rankInfoList);
		}
		
		private function onRefreshScrollerRankList(rankInfos:Vector.<IData>):void
		{
			if (!scrollerRankList)
			{
				scrollerRankList = JTScrollerMenu.createScrollerMenu(JTRankItemRender, onShowHerosHandler, rankInfos);
				scrollerRankList.width = this.scale_mc_ranks.width + 10;
				scrollerRankList.height = 312;
				scrollerRankList.x = this.scale_mc_ranks.x;
				scrollerRankList.y = this.scale_mc_ranks.y;
				scrollerRankList.layout = scrollerRankList.getDefaultLayout();
				this.addChild(scrollerRankList);
			}
			else
			{
				scrollerRankList.resetItemInfoList(rankInfos);
			}
		}
		
		private function createMyselfRank(ranks:Vector.<IData>):void
		{
			if (!rank_myItem)
			{
				rank_myItem = JTRankItemRender.instance();
				this.rank_myItem.x = this.txt_my_rank.x;
				this.rank_myItem.y = this.txt_my_rank.y + this.txt_my_rank.height + 10;
				this.addChild(rank_myItem);
			}
			if (!ranks.length)
			{
				if (this.rank_myItem) 
				{
					this.rank_myItem.visible = false; 
				}
				return;
			}
			this.rank_myItem.visible = true;
			var i:int = 0;
			var l:int = ranks.length;
		//	var userInfoManager:JTUserInfoManager = JTSingleManager.instance.userInfoManager;
			var rankMyselfInfo:RankInfo = null;
			for (i = 0; i < l; i++)
			{
				var dataInfo:RankInfo = ranks[i] as RankInfo;
				if (dataInfo.id != GameMgr.instance.uid)
				{
					continue;	
				}
				rankMyselfInfo = dataInfo;
				break;
			}
			if (rankMyselfInfo == null)
			{
				rankMyselfInfo = new RankInfo();
				rankMyselfInfo.id = GameMgr.instance.uid;//userInfoManager.uid;
				rankMyselfInfo.name = GameMgr.instance.arenaname;
				rankMyselfInfo.index = 100; 
				rankMyselfInfo.picture = GameMgr.instance.picture;
				rankMyselfInfo.custom = JTSingleManager.instance.rankListInfoManager.fight_level;
			//	rankMyselfInfo.custom = JTSingleManager.instance.rankListInfoManager.fight_vlaue;
			}
			switch(JTRankListInfoManager.rankType)
			{
//				case JTRankListInfoManager.RANK_MONEY:
//				{
//					//rankMyselfInfo.attr = JTSingleManager.instance.rankListInfoManager.myself_value;//GameMgr.instance.diamond;
//					break;
//				}
//				case JTRankListInfoManager.RANK_FIGHT:
//				case JTRankListInfoManager.RANK_PVP:
//				{
//					//rankMyselfInfo.attr = HeroDataMgr.instance.getPower();
//					//rankMyselfInfo.custom = JTSingleManager.instance.rankListInfoManager.fight_level;
//					break;
//				}
//				case JTRankListInfoManager.RANK_STAR:
//				{
					//rankMyselfInfo.attr = GameMgr.instance.star;
//					break;
//				}
			}
			rank_myItem.data = rankMyselfInfo;
		}
		
		private function onShowHerosHandler(rankInfo:RankInfo):void
		{
			var lines:Array = (rankInfo.name as String).split(".");
			if (rankInfo.name == "^." + rankInfo.id + ".$")
			{
				RollTips.showTips("robot");
				return;
			}
			this.title_name = rankInfo.name;
			var lookHerosPackage:CRankHero = new CRankHero();
			lookHerosPackage.id = rankInfo.id;
			GameSocket.instance.sendData(lookHerosPackage);
		}
		
		override public function dispose():void
		{
			if (rank_myItem)
			{
				rank_myItem.removeFromParent();
				rank_myItem.dispose();
				rank_myItem = null;
			}
			JTSingleManager.instance.rankListInfoManager.clearRankInfos(JTRankListInfoManager.RANK_PVP);
			JTFunctionManager.executeFunction(JTGlobalDef.PLAY_CITY_ANIMATABLE);
			this.btn_close && this.btn_close.removeEventListener(Event.TRIGGERED, onCloseHandler);
			JTFunctionManager.removeFunction(JTGlobalDef.LOOK_OVER_HERO, onLookOverHerosResponse);
			JTFunctionManager.removeFunction(JTGlobalDef.REFRESH_RANK_LIST, onRefreshScrollerRankList);
			if (scrollerRankList)
			{
				scrollerRankList.removeFromParent();
				scrollerRankList.dispose();
				scrollerRankList = null;
			}
			JTHerosHallComponent.hide();
			JTScrollerMenu.hide();


            onClose.dispatch(instance);
            instance = null;
			super.dispose();
		}
		
		public static function open():void
		{
			if (!instance)
			{
				instance = PopUpManager.addPopUp(new JTRankListComponent(), false) as JTRankListComponent;
				JTScrollerMenu.initializeDefualtMenu();
			}
		}
		
		public static function close():void
		{
			if (instance)
			{
				PopUpManager.removePopUp(instance ,true);
				instance = null;
			}
		}
	}
}