package game.data
{
	import com.data.Data;
	import com.data.HashMap;

	import flash.utils.ByteArray;

	public class BuffData extends Data
	{
		public var desc : String;
		public var buffEffect : String;
		public var position : int;
		public var loop : int;
		/*
		 * 1：普通技能
		   2：觉醒技能
		 * */
		public var type : int;

		public function BuffData()
		{
			super();
		}

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
			initData(data, hash, BuffData);
		}
	}
}