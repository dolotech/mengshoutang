package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	
	import flash.utils.ByteArray;
	
	public class FirstPay extends Data
	{
		public var tid:int;
		public var num:int;
		public var heroType:int;
		public var quality:int;
		
		public function FirstPay()
		{
			super();
		}
		
		public static var hash:HashMap;
		
		public static function init(data:ByteArray):void
		{
			hash = new HashMap();
			data.position = 0;
			
			var vector:Array = data.readObject() as Array;
			var len:int = vector.length;
			for(var i : int = 0; i < len; i++)
			{
				var obj:Object = vector[i];
				var instance : FirstPay = new FirstPay();
				for (var key:String in obj)
				{
					if(key == "num" &&String (obj[key]).indexOf("{") != -1)
					{
						var ex:RegExp = /\d+/gs;
						var str:String  = obj[key];
						var arr:Array = str.match(ex);
						instance.heroType = arr[0];
						instance.quality = arr[1];
						instance.num = 1;
					}
					else 
					instance[key] = obj[key];
				}
				hash.put(instance.id,instance);
			}
		
		}
	}
}