package game.managers
{
	import com.mvc.interfaces.INotification;
	
	import flash.utils.Dictionary;
	
	import game.common.JTGlobalDef;
	import game.common.JTLogger;
	
	import game.net.GameSocket;
	import game.net.data.IData;
	import game.net.data.c.CRankList;
	import game.net.data.s.SRankHero;
	import game.net.data.s.SRankList;
	
	/**
	 * 排行榜数据管理器
	 * @author CabbageWrom
	 * 
	 */	
	public class JTRankListInfoManager extends JTDataInfoManager
	{
		public static const RANK_STAR:int = 1;
		public static const RANK_MONEY:int = 2;
		public static const RANK_FIGHT:int = 3;
		public static const RANK_PVP:int = 4;
		public static var rankType:int = 0;
		private var rankList:Dictionary = null;
		public var fight_level:int = 0;
		public var myself_value:int = 0;
		public function JTRankListInfoManager()
		{
			rankList = new Dictionary(false);
			super();
		}
		
		override public function clears():void
		{
			rankList = new Dictionary(false);
		}
		
		override public function handleNotification(gameData:INotification):void
		{
			var downProtocol:String = gameData.getName();
			switch(downProtocol)
			{
				case SRankList.CMD.toString():
				{
					saveRankInfoList(gameData as SRankList);
					break;
				}
				case SRankHero.CMD.toString():
				{
					JTFunctionManager.executeFunction(JTGlobalDef.LOOK_OVER_HERO, gameData);
					break;
				}
                default :
                    break;
			}
		}
		
		private function saveRankInfoList(rankInfos:SRankList):void
		{
			var type:int = rankInfos.type
			if (rankList[type])
			{
				JTLogger.warn("[JTRankListInfoManager.saveRankInfoList] Rank Info List is Update!");
			}
			rankList[type] = rankInfos;
			this.fight_level = rankInfos.lev;
			this.myself_value = rankInfos.num;
			var ranks:Vector.<IData> = rankInfos.ranks;
			JTFunctionManager.executeFunction(JTGlobalDef.REFRESH_RANK_LIST, ranks);
		}
		
		public function clearRankInfos(type:int):void
		{
			if (!rankList[type])
			{
				return;
			}
			rankList[type] = null;
			delete rankList[type];
		}
		
		public function getRankInfos(type:int):Vector.<IData>
		{
			if (!rankList[type])
			{
				var sendRanksPackage:CRankList = new CRankList();
				sendRanksPackage.type = type;
				GameSocket.instance.sendData(sendRanksPackage);
				return null;
			}
			var rankInfos:SRankList = rankList[type] as SRankList;
			this.fight_level = rankInfos.lev;
			this.myself_value = rankInfos.num;
			var ranks:Vector.<IData> = rankInfos.ranks;
			return ranks;
		}
		
		override public function listNotificationName():Vector.<String>
		{
			this.pushProcotol(SRankList.CMD);
			this.pushProcotol(SRankHero.CMD);
			return super.listNotificationName();	
		}
		
	}
}