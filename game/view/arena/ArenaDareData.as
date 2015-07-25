package game.view.arena
{
	import com.singleton.Singleton;

	import game.net.data.IData;
	import game.view.data.Data;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	public class ArenaDareData extends Data
	{
		/**
		 *对手
		 */
		public var rivalList : Vector.<IData>;
		/**
		 *挑战次数
		 */
		public var number : int;

		/**
		 *购买次数
		 */
		public var chance : int;
		/**
		 * 第一组宝箱是否开启
		 */
		public var team1 : int;
		/**
		 * 第二组宝箱是否开启
		 */
		public var team2 : int;
		/**
		 *挑战位置
		 */
		public var pos : int;
		/**
		 *排名
		 */
		public var rank : int;
		/**
		 *积分
		 */
		public var point : int;
		/**
		 *荣誉
		 */
		public var honor : int;
		/**
		 *等级
		 */
		public var level : int;
		/**
		 * 奖励金币 
		 */
		public var gold : int;
		/**
		 * 当前获得积分 
		 */
		public var get_point : int;
		/**
		 * 竞技挑战类型 ,1正常,2反击,3,揭榜
		 */
		public var type : int;

		/**
		 *是否请求过23004协议
		 */
		public var isRequestLevel : Boolean = false;

		public function ArenaDareData()
		{
			super();
		}

		public static function get instance() : ArenaDareData
		{
			return Singleton.getInstance(ArenaDareData) as ArenaDareData;
		}

		public function RestRivalList() : void
		{
			(rivalList[pos - 1])["beat"] = 1;
		}
		public var onUpdate : ISignal = new Signal();

		public function updatePross() : void
		{
			onUpdate.dispatch();
		}
	}
}