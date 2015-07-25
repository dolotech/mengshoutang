package game.data
{
	import com.data.Data;
	import com.data.HashMap;

	import flash.utils.ByteArray;

	/**
	 * 英雄品质
	 * @author Administrator
	 *
	 */
	public class HeroQualityData extends Data
	{
		public var quality : int;
		public var arg : Number;

		public function HeroQualityData()
		{
			super();
		}


		public static var hash : HashMap;

		/**
		 *
		 * @param data
		 */
		public static function init(data : ByteArray) : void
		{
			hash = new HashMap();
			initData(data, hash, HeroQualityData, "quality");
		}
	}
}