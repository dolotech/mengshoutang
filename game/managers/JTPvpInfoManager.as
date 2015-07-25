package game.managers
{
	import com.components.RollTips;
	import com.dialog.DialogMgr;
	import com.langue.Langue;
	import com.mvc.interfaces.INotification;
	import com.view.base.event.EventType;
	import com.view.base.event.ViewDispatcher;

	import game.common.JTFormulaUtil;
	import game.common.JTGlobalDef;
	import game.common.JTLogger;
	import game.common.JTSession;
	import game.data.VipData;
	import game.manager.GameMgr;
	import game.net.GameSocket;
	import game.net.data.IData;
	import game.net.data.c.CColiseumChance;
	import game.net.data.c.CColiseumRankInfo;
	import game.net.data.s.SColiseumBuy;
	import game.net.data.s.SColiseumChance;
	import game.net.data.s.SColiseumInit;
	import game.net.data.s.SColiseumRankInfo;
	import game.net.data.s.SColiseumReport;
	import game.net.data.s.SColiseumRivalFightInfo;
	import game.net.data.s.SColiseumRivalHero;
	import game.net.data.s.SColiseumSend;
	import game.net.data.vo.ColiseumRankInfo;
	import game.net.data.vo.ColiseumReportList;
	import game.view.PVP.JTPvpComponent;
	import game.view.data.Data;
	import game.view.tipPanel.TipPanelDlg;
	import game.view.uitils.FunManager;

	/**
	 *
	 * @author PVP信息管理器
	 *
	 */
	public class JTPvpInfoManager extends JTDataInfoManager
	{
		public var enemy_info : ColiseumRankInfo;
		public var rank : int = 0;
		public var pvpLv : int = 0;
		public var rankList : Vector.<IData> = null;
		public var pvpEquipemts : Array = null;
		public var pvpCount : int = 0;
		public var pvpIntervalCd : int = 0;
		public var timer : Data = null;
		public var myselfInfo : ColiseumRankInfo = null;
		public var fightInfos : Vector.<IData> = null;
		public static var type : int = 0;
		public static const TYPE_PVP : int = 1;
		public static const TYPE_FIGHT : int = 2;
		private var _last_rank : int = 0;
		public static var pvpRid : int = 0;
		public var buyCount : int = 0;
		public var hornor : int = 0;

		public static var hero_title : String = null;

		public function JTPvpInfoManager()
		{
			super();
			pvpEquipemts = [];
			timer = new Data();
			rankList = new Vector.<IData>();
			fightInfos = new Vector.<IData>();
		}

		public function get last_rank() : int
		{
			return _last_rank;
		}

		public function set last_rank(value : int) : void
		{
			_last_rank = value;
		}

		override public function handleNotification(gameData : INotification) : void
		{
			var downProtocol : String = gameData.getName();

			switch (downProtocol)
			{
				case SColiseumInit.CMD.toString():
				{
					updateUserPvpInfo(gameData);
					JTFunctionManager.executeFunction(JTGlobalDef.PVP_MYSELF_INFO, gameData);
					break;
				}
				case SColiseumRankInfo.CMD.toString():
				{
					if (rankList)
					{
						JTLogger.info("[JTPvpInfoManager.handleNotification]The RankList Panel Data Will Update!");
					}
					var pvpInfo : SColiseumRankInfo = gameData as SColiseumRankInfo;
					this.rankList = pvpInfo.targets;
					this.myselfInfo = this.getRankInfo(GameMgr.instance.uid);
					this.updateUserPvpInfo(gameData);
					JTFunctionManager.executeFunction(JTGlobalDef.PVP_RANKS_LIST, gameData);
					GameMgr.instance.rankLevel = pvpInfo.level;
					ViewDispatcher.dispatch(EventType.UPDATE_RANK_LEVEL);
					break;
				}
				case SColiseumReport.CMD.toString():
				{
					this.fightInfos = (gameData as SColiseumReport).lists;
					this.fightInfos.reverse();
					JTFunctionManager.executeFunction(JTGlobalDef.PVP_REVENGES_LIST, gameData);
					break;
				}
				case SColiseumRivalFightInfo.CMD.toString():
				{
					executePkResponse(gameData as SColiseumRivalFightInfo);
					break;
				}
				case SColiseumChance.CMD.toString():
				{
					onExecuteBuy(gameData as SColiseumChance);
					break;
				}
				case SColiseumRivalHero.CMD.toString():
				{
					JTFunctionManager.executeFunction(JTGlobalDef.PVP_LOOK_HEROS, gameData);
					break;
				}
				case SColiseumSend.CMD.toString():
				{
					JTFunctionManager.executeFunction(JTGlobalDef.PVP_REFRESH_INFOS, gameData);
					break;
				}
                default :
                    break;
			}
		}

		public function refreshRankList() : void
		{
			var reRanksPackage : CColiseumRankInfo = new CColiseumRankInfo();
			GameSocket.instance.sendData(reRanksPackage);
		}

		private function onExecuteBuy(gameData : SColiseumChance) : void
		{
			switch (gameData.code)
			{
				case 0:
					JTFunctionManager.executeFunction(JTGlobalDef.PVP_BUY_NUM, gameData);
					break;
				case 1:
					RollTips.showTips("diamendNotEnough");
					break;
				case 4:
					RollTips.showTips("vip_max");
					break;
				default:
					RollTips.showTips("proError");
					break;
			}
		}

		private var will_fightInfo : SColiseumRivalFightInfo = null;

		private function executePkResponse(result : SColiseumRivalFightInfo) : void
		{
			var errors : Array = Langue.getLans("pvpErrors");
			var prompt : String = Langue.getLangue("buyPvpCount");
			var money : int = FunManager.coliseum_buys(buyCount);

			switch (result.code)
			{
				case 0:
				{
					will_fightInfo = result;
					JTFunctionManager.executeFunction(JTGlobalDef.PVP_PK_FIGHT, result);
					break;
				}
				case 1:
				{
					RollTips.add(errors[0]);
					onBuyJIngjiCount();
					break;
				}
				case 2:
				{
					RollTips.add(errors[1]);
					onBuyJIngjiCount();
					break;
				}
				case 3:
				{
					refreshRankList();
					RollTips.add(errors[2]);
					break;
				}
				case 4:
				{
					refreshRankList();
					RollTips.add(errors[3]);
					break;
				}
				case 5:
				{
					refreshRankList();
					RollTips.add(errors[4]);
					break;
				}
				case 6:
				{
					refreshRankList();
					RollTips.add(errors[5]);
					break;
				}
				default:
				{
					RollTips.add(errors[6]);
					break;
				}
			}

			function onBuyJIngjiCount() : void
			{
				var vipData : VipData = GameMgr.instance.vipData.baseVip;
				var needVip : int = vipData.getVipByJingjiCount(buyCount + 1);

				if ((buyCount + 1) >= vipData.jingji_buy && vipData.id < needVip)
				{
					RollTips.add(Langue.getLangue("vip_jingji_buy").replace("*", needVip).replace("*", buyCount + 1));
					return;
				}
				var tips : TipPanelDlg = DialogMgr.instance.open(TipPanelDlg) as TipPanelDlg;
				tips.createVerify(prompt.replace("*", money), onClickBuyHandler, onCanelHandler);
			}
		}


		public function updateRanks() : void
		{
			if (!will_fightInfo)
			{
				JTLogger.error();
			}
			var playerUID : int = will_fightInfo.id;
			var i : int = 0;
			var l : int = 0;

			if (type == TYPE_FIGHT || type == TYPE_PVP)
			{
				l = rankList.length;

				for (i = 0; i < l; i++)
				{
					var rankInfo : ColiseumRankInfo = rankList[i] as ColiseumRankInfo;

					if (rankInfo.id != playerUID)
					{
						continue;
					}
					var heRank : int = rankInfo.pos;
					var myRank : int = myselfInfo.pos;
					myselfInfo.pos = heRank;
					rankInfo.pos = myRank;
					break;
				}
				this.rank = myselfInfo.pos;
				this.rankList.sort(sortConvers);
			}

			if (type == TYPE_FIGHT)
			{
				if (!fightInfos)
				{
					fightInfos = new Vector.<IData>();
					return;
				}
				i = 0;
				l = fightInfos.length;

				for (i = 0; i < l; i++)
				{
					var reportInfo : ColiseumReportList = fightInfos[i] as ColiseumReportList;

					if (reportInfo.id != playerUID)
					{
						continue;
					}
					var index : int = fightInfos.indexOf(reportInfo);

					if (index == -1)
					{
						JTLogger.error("[JTPvpInfoManager.updateRanks] Can't Find The rid user!");
					}
					fightInfos.splice(index, 1);
					break;
				}
			}
		}

		private function sortConvers(a : ColiseumRankInfo, b : ColiseumRankInfo) : int
		{
			var result : int = 0;

			if (a.pos > b.pos)
			{
				result = 1;
			}
			else if (a.pos < b.pos)
			{
				result = -1;
			}
			return result;
		}

		override public function clears() : void
		{
			rank = 0;
			type = 0;
			pvpLv = 0;
			pvpRid = 0;
			pvpCount = 0;
			buyCount = 0;
			_last_rank = 0;
			pvpEquipemts = [];
			pvpIntervalCd = 0;
			timer = new Data();
			myselfInfo = null;
			rankList = new Vector.<IData>();
			fightInfos = new Vector.<IData>();
			JTPvpComponent.isRequest = false;
			JTSession.isPvped = false;
		}

		private function onClickBuyHandler() : void
		{
			var buyPvpCountPackage : CColiseumChance = new CColiseumChance();
			GameSocket.instance.sendData(buyPvpCountPackage);
			DialogMgr.instance.deleteDlg(TipPanelDlg);
		}

		private function onCanelHandler() : void
		{
			DialogMgr.instance.deleteDlg(TipPanelDlg);
		}

		private function updateUserPvpInfo(gameData : INotification) : void
		{
			var pvpInfo : SColiseumRankInfo = gameData as SColiseumRankInfo;
			this.rank = pvpInfo.rank;
			this.pvpLv = pvpInfo.level;
			this.pvpCount = pvpInfo.wars;
			this.pvpIntervalCd = pvpInfo.cd;
			this.buyCount = pvpInfo.chance;
			this.timer.time = pvpIntervalCd;
			this.hornor = pvpInfo.exp;

			if (last_rank == 0)
			{
				last_rank = rank;
			}
		}

		/**
		 *
		 * @param uid
		 * @return
		 *
		 */
		public function getRankInfo(uid : int) : ColiseumRankInfo
		{
			var i : int = 0;
			var l : int = rankList.length;

			for (i = 0; i < l; i++)
			{
				var rankInfo : ColiseumRankInfo = rankList[i] as ColiseumRankInfo;

				if (rankInfo.rid != uid)
				{
					continue;
				}
				return rankInfo;
			}

			if (uid == GameMgr.instance.uid)
			{
				JTLogger.error("[JTPvpInfoManager.getMyselfRankInfo]Cant Find Myself RankInfo!");
			}
			return null;
		}

		public function getRankInfoById(uid : int) : ColiseumRankInfo
		{
			var i : int = 0;
			var l : int = rankList.length;
			
			for (i = 0; i < l; i++)
			{
				var rankInfo : ColiseumRankInfo = rankList[i] as ColiseumRankInfo;
				
				if (rankInfo.id != uid)
				{
					continue;
				}
				return rankInfo;
			}
			
			if (uid == GameMgr.instance.uid)
			{
				JTLogger.error("[JTPvpInfoManager.getMyselfRankInfo]Cant Find Myself RankInfo!");
			}
			return null;
		}
		
		override public function listNotificationName() : Vector.<String>
		{
			this.pushProcotol(SColiseumSend.CMD);
			this.pushProcotol(SColiseumRivalHero.CMD);
			this.pushProcotol(SColiseumChance.CMD);
			this.pushProcotol(SColiseumRivalFightInfo.CMD);
			this.pushProcotol(SColiseumBuy.CMD);
			this.pushProcotol(SColiseumRankInfo.CMD);
			this.pushProcotol(SColiseumReport.CMD);
			this.pushProcotol(SColiseumInit.CMD);
			return super.listNotificationName();
		}

	}
}