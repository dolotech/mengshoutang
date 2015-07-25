package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	
	import flash.utils.ByteArray;

	public class Convert extends Data
	{

		public var price : int;
		public var newlev : int = 0;

		public function Convert()
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
			initData(data, hash, Convert);
		}
	}
}