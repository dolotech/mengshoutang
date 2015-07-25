package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	
	import flash.utils.ByteArray;
	
	public class FestPrizeData extends Data
	{
		
		public var id2:int;
		public var ReceiveType:int;
		public var num:int;
		public var condition:int;
		public function FestPrizeData()
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
			hash = new HashMap();
			data.position = 0;
			
			var vector:Array = data.readObject() as Array;
			var len:int = vector.length;
			for(var i : int = 0; i < len; i++)
			{
				var obj:Object = vector[i];
				var instance : FestPrizeData = new FestPrizeData();
				
				for (var key:String in obj)
				{
					if(key == "Receive")
					{
						var ex:RegExp = /\d+/gs;
						var str:String  = obj[key];
						var arr:Array = str.match(ex);
						instance.ReceiveType = arr[0];
						instance.num = arr[1];
					}
					else instance[key] = obj[key];
				}
				hash.put(instance.id+""+instance.id2,instance);
			}
		}
		
	}

}