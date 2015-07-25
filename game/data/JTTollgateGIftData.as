package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	
	import flash.utils.ByteArray;
	
	public class JTTollgateGIftData extends Data
	{
		public var id1:int = 0;
		public var id2:int = 0;
		public var prize:Array = [];
		public static var hash:HashMap = null;
		public function JTTollgateGIftData()
		{
			super();
		}
		
		public static function init(data:ByteArray):void
		{
			hash = new HashMap();
			var list:Array = data.readObject() as Array;
			var exp:RegExp = /\{[\d,\,]*\}/gs;
			var ex:RegExp = /\d+/gs;
			var i:int = 0;
			var l:int = list.length;
			for (i = 0; i < l; i ++)
			{
				var instance:JTTollgateGIftData = new JTTollgateGIftData();
				var dataInfo:Object = list[i];
				for (var key:String in dataInfo)
				{
					if (key == "prize")
					{
						var str:String = dataInfo[key];
						var arr:Array = str.match(exp);
						var le:int = arr.length;
						for (var k:int = 0; k < le; k++)
						{
							var sub:String = arr[k];
							var subArr:Array = sub.match(ex);
							instance.prize[k] = subArr;
						}
						continue;
					}
					instance[key] = dataInfo[key];
				}
				hash.put(instance.id1, instance);
			}
		}
		
		public static function getTollgateGift(tollgate:int):JTTollgateGIftData
		{
			if (tollgate == 0)
			{
				return null;
			}
			var list:Vector.<*> = hash.values();
			var i:int = 0;
			var l:int = list.length;
			for (i = 0; i < l; i++)
			{
				var tollgateGiftData:JTTollgateGIftData = list[i] as JTTollgateGIftData;
				if (tollgateGiftData.id1 < tollgate)
				{
					continue;
				}
				return tollgateGiftData;
			}
			return null;
		}
		
		public static function getMax():int
		{
			return hash.values().length;
		}
	}
}