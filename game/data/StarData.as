package game.data
{
	import com.data.Data;
	import com.data.HashMap;

	import flash.utils.ByteArray;

	public class StarData extends Data
	{
		/**
		 *星级
		 */
		public var star:int;

		/**付费类型*/
		public var payType:int;

		/**销耗的钱*/
		public var money:int;

		/**消耗钱材料*/
		public var materialNum:int;

		public function StarData()
		{
			super();
		}


		public static var hash:HashMap;

		/**
		 *
		 * @param data
		 */
		public static function init(data:ByteArray):void
		{
			hash=new HashMap();
			initData(data, hash, StarData, "star");
		}


	}
}
