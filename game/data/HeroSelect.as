package game.data
{
	import com.data.Data;
	import com.data.HashMap;

	import flash.utils.ByteArray;

	public class HeroSelect extends Data
	{

		public var pos : int;
		public var photo : String;
		public var quality : int;
		public var caption : String;
		public var job : String;

		public static var hash : HashMap;

		public function HeroSelect()
		{
			super();
		}

		public static function init(data : ByteArray) : void
		{
			hash = new HashMap();
			initData(data, hash, HeroSelect, "pos");
		}
	}
}