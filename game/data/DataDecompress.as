package game.data
{
	import com.data.HashMap;
	import com.singleton.Singleton;

	import flash.utils.ByteArray;

	import game.common.JTLogger;
	import game.manager.HeroDataMgr;
	import game.view.new2Guide.data.NewDialogData;
	import game.view.new2Guide.data.NewGuideData;
	import game.view.new2Guide.data.NewGuideExcuteData;


	/**
	 * ...
	 * @author Michael
	 */
	public class DataDecompress
	{
		private var _hash:HashMap;

		public function DataDecompress()
		{
			_hash=new HashMap();
			_hash.put("skill", SkillData.init); // 技能表
			Goods.goods=new HashMap();
			_hash.put("item", Goods.init); // 道具表
			_hash.put("equip", Goods.init); // 装备表
			_hash.put("dialog", BattleWordVO.init); // 对话表
			_hash.put("hero", HeroData.init); // 英雄表
			_hash.put("hero_star", HeroStarData.init); //升星属性加成
			_hash.put("hero_starc", StarData.init); //升星条件
			_hash.put("monster", MonsterData.init); // 怪物表
			_hash.put("exp", ExpData.init); // 经验表
			_hash.put("strengthen", StrengthenData.init); // 强化表
			_hash.put("embed", EmbedData.init); // 镶嵌
			_hash.put("shop", ShopData.init); // 商城
			_hash.put("forge", ForgeData.init); // 合成
			_hash.put("heroPrice", HeroPriceData.init); // 英雄价格
			_hash.put("config", ConfigData.init); // 游戏全局配置
			_hash.put("tollgate", TollgateData.init); // 关卡
			_hash.put("produce", MainLineData.initReward); // 关卡
			_hash.put("magicorbs", MagicorbsData.init); // 魔法宝珠黑市
			_hash.put("roleshow", RoleShow.init); // 角色表现相关
			_hash.put("fbCD", FBCDData.init); // 副本掉落和描述显示
			_hash.put("mainline", MainLineData.init); // 主线显示
			_hash.put("buff", BuffData.init); //buff 
			_hash.put("purge", PurgeData.init); // 进化
			_hash.put("heroquality", HeroQualityData.init); //英雄品质
			_hash.put("effectSound", EffectSoundData.init); //      特效音效
			_hash.put("fb_monsters", FbMonsters.init); //副本怪物表
			_hash.put("heroSelect", HeroSelect.init); //英雄选择
			_hash.put("arenaLvel", ArenaLevel.init); //竞技等级
			_hash.put("new_convert", Convert.init); //兑换物品
			Robot.hash=new HashMap();
			_hash.put("robot", Robot.init); //机器人
			_hash.put("robot1", Robot.init); //机器人
			_hash.put("luck", LuckyStarData.init); //幸运星
			_hash.put("attain", Attain.init); //成就
			_hash.put("fightDlg", FightDlgData.init); //战斗内对话
			_hash.put("story", StoryData.init); //战斗结束对话
			_hash.put("story_config", StoryConfigData.init); //战斗结束对话
			_hash.put("strenthenRateData", StrenthenRateData.init); //  强化成功率计算表
			_hash.put("fbDrop", FbDropData.init); //  副本掉落显示
			_hash.put("sign", SignData.init); // 签到表
			_hash.put("bags", BagsData.init); // 背包开放表

			_hash.put("diamond_shop", DiamondShopData.init); // 钻石商店
			_hash.put("activityList", ActivityListData.init); // 活动列表 
			_hash.put("first_pay", FirstPay.init); // 首冲活动
			_hash.put("activityNum", ActivityNum.init); // 
			_hash.put("fest_prize", FestPrizeData.init); // 
			_hash.put("tollgate_prize", JTTollgateGIftData.init); //
			_hash.put("coliseum", JTPVPRuleData.init);
			_hash.put("newGuide", NewGuideData.init);
			_hash.put("newGuideStep", NewGuideExcuteData.init);
			_hash.put("newDialog", NewDialogData.init);
			_hash.put("newViewGuide", ViewGuideData.init);
			_hash.put("newViewGuideStep", ViewGuideDataStep.init);
			_hash.put("newColiseum", JTPvpNewRuleData.init);
			_hash.put("jewel_pick", MagicorbsData.parseCost);
			_hash.put("hero_tab", HeroDataMgr.initGridCostList);
			_hash.put("picture", GamePhotoData.init); //更换头像
			_hash.put("strategy", StrategyData.init);
			_hash.put("vip", VipData.init);
			_hash.put("vip_dayReward", VipData.initDayReward);
			_hash.put("vip_reward", VipData.initReward);
			_hash.put("mcard", VipData.initMonthCard);
			_hash.put("jewel_lev", JewelLevData.init); //宝珠吞噬
			_hash.put("mercenary", MercenaryData.init); //酒馆佣兵
			_hash.put("dispark", DisparkData.init); //功能开放
			_hash.put("hero_total", HeroTotalData.init); //英雄上阵总数限制
			_hash.put("task", TaskData.init); //任务系统

		}


		/**
		 * 解析总配置文件
		 * @param byteArray
		 *
		 */
		public function decompress(byteArray:ByteArray):void
		{
			byteArray.uncompress();
			byteArray.position=0;

			var i:int=0;

			while (byteArray.bytesAvailable)
			{
				var fullFileName:String=byteArray.readUTF();
				var len:int=byteArray.readUnsignedInt();
				var fileBytes:ByteArray=new ByteArray();
				byteArray.readBytes(fileBytes, 0, len);
				var fileNameList:Array=fullFileName.split(".");
				var fileType:String=fileNameList[1];
				var fileName:String=fileNameList[0];
				var fun:Function=_hash.getValue(fileName);

				if (fun != null)
					fun(fileBytes);
				else
					JTLogger.warn("配置文件没有处理:", fileName);
			}
			byteArray.clear();
		}

		public static function get instance():DataDecompress
		{
			return Singleton.getInstance(DataDecompress) as DataDecompress;
		}
	}
}
