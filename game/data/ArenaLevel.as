package game.data
{
	import com.data.Data;
	import com.data.HashMap;

	import flash.utils.ByteArray;

	public class ArenaLevel extends Data
	{
		/**
		 *竞技积分
		 */
		public var integral : int;
		/**
		 *段位图标
		 */
		public var picture : String;

		public static var hash : HashMap;

		/**
		 *
		 * @param data
		 */
		public static function init(data : ByteArray) : void
		{
			hash = new HashMap();
			initData(data, hash, ArenaLevel);
		}
	}
}