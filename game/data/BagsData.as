package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	
	import flash.utils.ByteArray;
	
	public class BagsData extends Data
	{
		public var price:int;
		public function BagsData()
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
				var instance : BagsData = new BagsData();
				
				for (var key:String in obj)
				{
					instance[key] = obj[key];
				}
				
				hash.put(instance.id,instance);
				
			}
		}
	}
}