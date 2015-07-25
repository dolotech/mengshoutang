package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	
	import flash.utils.ByteArray;

	public class HeroStarData extends Data
	{
		public var star:String;

		public function HeroStarData()
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
			initData(data, hash, HeroStarData, "id");
		}

		public function get stars():Array
		{
			var arr:Array=star.substring(1,star.length-1).split(",");
			var list:Array=[100];
			for (var i:int=0; i < arr.length; i++)
			{
				list.push(Number(arr[i]));
			}
			return list;
		}
	}
}
