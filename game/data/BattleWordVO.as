package game.data
{
	import com.data.Data;
	import com.data.HashMap;

	import flash.utils.ByteArray;


	/**
	 * 战斗内说话内容
	 * @author joy
	 */
	public class BattleWordVO extends Data
	{
		/**
		 *
		 * @default
		 */
		public static var hash : HashMap;

		/**
		 *
		 * @param data
		 */
		public static function init(data : ByteArray) : void
		{
			hash = new HashMap();
			initData(data, hash, BattleWordVO);
		}


		/**
		 * 随机获取指定英雄的一个对话
		 * @param hero
		 * @return
		 */
		public static function getRandom(hero : int) : BattleWordVO
		{
			var arr : Vector.<BattleWordVO> = new Vector.<BattleWordVO>();
			hash.eachValue(eachFun);
			var i : int = 0;
			function eachFun(vo : BattleWordVO) : void
			{
				if (vo.type == hero)
				{
					arr[i++] = vo;
				}
			}
			return arr[arr.length * Math.random() >> 0];
		}


		/**
		 *
		 * 英雄类型
		 */
		public var type : int;
		/**
		 *
		 * 对话内容
		 */
		public var dialog : String;

		/**
		 *
		 */
		public function BattleWordVO()
		{
			super();
		}
	}
}