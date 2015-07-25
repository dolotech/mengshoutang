package game.manager
{
	import com.singleton.Singleton;
	import com.view.base.event.EventType;
	import com.view.base.event.ViewDispatcher;

	import game.data.StoryConfigData;
	import game.data.TollgateData;
	import game.data.VipData;
	import game.data.WidgetData;
	import game.net.data.s.SBattle;
	import game.net.data.s.SColiseumPrizeSend;
	import game.view.achievement.data.AchievementData;
	import game.view.arena.ArenaDareData;
	import game.view.luckyStar.StarData;
	import game.view.tavern.data.TavernData;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	/**
	 * 游戏全局数据
	 * @author Michael
	 *
	 */
	public class GameMgr
	{
		public var hasNotice : Boolean = false;
		/**
		 * 当前关卡数据
		 */
		public var tollgateData : TollgateData;
		/**
		 * 1可领取,0不可领取
		 */
		public var sign_reward : int = 0;
		/**
		 *　 战斗是否结束
		 */
		public var isGameover : Boolean = true;
		/**
		 * 金币
		 * @default
		 */
		public var coin : int;

		/**
		 * 角斗场排行榜
		 */
		public var rankLevel : int;
		/**
		 * 注册码
		 */
		public var code : int;

		/**
		 * 英雄格子数
		 */
		public var hero_gridCount : int;
		public var vip : int;
		/**
		 * 充值次数记录
		 */
		public var firstpay : int;
		public var tollgateprize : int;
		public var vipData : VipData = new VipData();
		public var tired : int;
		public var time : int;
		/**
		 * 钻石
		 * @default
		 */
		public var diamond : int;
		private var _tollgateID : int = 1;
		/**
		 * 当前关卡是否胜利
		 */
		public var isPass : Boolean;
		/**
		 * 0关卡 2副本 3PVP 4任务
		 */
		public var battle_type : int;
		public var sBattle : SBattle;
		public var reward_Battle : SColiseumPrizeSend;
		/**
		 *装备格子数
		 */
		public var bagequ : int;
		/**
		 *道具格子数
		 */
		public var bagprop : int;
		/**
		 *材料格子数
		 */
		public var bagmat : int;

		/**
		 * 玩家名字
		 */
		public var arenaname : String = "";
		/**
		 *玩家头像
		 */
		public var picture : int;
		/**
		 *荣誉值
		 */
		public var honor : int;
		/**
		 *幸运星
		 */
		public var star : int;
		/**
		 *喇叭
		 */
		public var horn : int = 0;

		/**
		 *聊天时间限制
		 */
		public var chatTime : int = 0;

		/**
		 *
		 */

		public var uid : int = 0;

		/**
		 * 游戏类型
		 * 0主线
		 * 1副本
		 * 2pvp
		 */
		public var game_type : int;
		public static const MAIN_LINE : int = 0;
		public static const FB : int = 1;
		public static const PVP : int = 2;


		public function GameMgr()
		{

		}
		//监听金币钻石更新
		public var onUpateMoney : ISignal = new Signal;


		//金币钻石更新发送通知

		/**
		 * 关卡
		 * @default
		 */
		public function get tollgateID() : int
		{
			return _tollgateID;
		}

		/**
		 * @private
		 */
		public function set tollgateID(value : int) : void
		{
			_tollgateID = value;
		}

		public function updateMoney() : void
		{
			onUpateMoney.dispatch();
			ViewDispatcher.dispatch(EventType.UPDATE_MONEY);
		}

		public function get honorMoney() : String
		{
			if ((honor + "").length > 5)
				return int(honor / 10000) + "";
			return honor + "";
		}

		/*
		 *
		 * 清楚所有游戏数据，用于玩家更换账号登陆
		 * */
		public function initAllData() : void
		{
			HeroDataMgr.instance.hash.clear();
			WidgetData.hash.clear();

			coin = tired = star = time = diamond = tollgateID = bagequ = bagmat = honor = picture = 0;
			arenaname = "";
			sBattle = null;
			isGameover = false;
			Singleton.remove(StarData);
			Singleton.remove(AchievementData);

			if ((ArenaDareData.instance.getData("dare") as ArenaDareData))
				(ArenaDareData.instance.getData("dare") as ArenaDareData).remove("dare");
			Singleton.remove(TavernData);
		}


		/**
		 *
		 * @return
		 */
		public static function get instance() : GameMgr
		{
			return Singleton.getInstance(GameMgr) as GameMgr;
		}
	}
}


