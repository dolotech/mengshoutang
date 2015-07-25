package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	
	import flash.utils.ByteArray;
	
	public class JewelLevData extends Data
	{
		/**
		 * 升级品质等级
		 */		
		public var level:int;
		
		/**
		 * 品质
		 */
		public var quality:int;
		/**
		 * 升级所需的经验
		 */
		public var exp:int;
		/**
		 * 金币消耗
		 */
		public var coin:int;
		/**
		 * 吞噬宝珠所提供的经验
		 */
		public var provide:int;
		
		public static var JewelLevHash : HashMap;
		public function JewelLevData()
		{
			super();
		}
		
		public static function init(data : ByteArray) : void
		{
			JewelLevHash = new HashMap();
			data.position = 0;
			
			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;
			
			for (var i : int = 0; i < len; i++)
			{
				var obj : Object = vector[i];
				var instance : JewelLevData = new JewelLevData();
				
				for (var key : String in obj)
				{
					instance[key] = obj[key];
				}	
				JewelLevHash.put(instance.level +"" + instance.quality, instance);
			}
		}
	}
}