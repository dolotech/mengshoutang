package game.data
{
	import com.data.Data;
	import com.data.HashMap;

	import flash.utils.ByteArray;

	/**
	 * 雇佣兵数据
	 * @author Samuel
	 *
	 */
	public class MercenaryData extends Data
	{

		public var heroID:int=0;
		public var quality:int=0;
		public var star:int=0;
		public var level:int=0;
		public var pointID:int=0;
		public var sellCount:int=0;
		public var payType:int=0;
		public var sellPrice:int=0;

		public function MercenaryData()
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
			initData(data, hash, MercenaryData, "id");
		}

	}
}
