package game.data
{
	import com.data.Data;
	import com.data.HashMap;

	import flash.utils.ByteArray;

	public class Robot extends Data
	{
		/**
		 *机器人头像
		 */
		public var picture : int;

		public static var hash : HashMap;

		/**
		 *
		 * @param data
		 */
		public static function init(data : ByteArray) : void
		{
			initData(data, hash, Robot);
		}
	}
}