package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	
	import flash.utils.ByteArray;
	
	public class ActivityListData extends Data
	{
		public var Icon:String;
		
		public var tableName:String;
		
		public var showClass:String;
		
		public function ActivityListData()
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
				var instance : ActivityListData = new ActivityListData();
				
				for (var key:String in obj)
				{
					instance[key] = obj[key];
				}
				hash.put(instance.id,instance);
			}
		}
		
		
		
		
		public function getValues():HashMap
		{
			var clas:HashMap = getHash(tableName);
			return clas ;
		}
		
		
		private  function getHash(name:String):HashMap
		{
			var obj:Object = {
				"FirstPay":FirstPay.hash,
				"ActivityNum":ActivityNum.hash
			};
			
			
			return obj[name];
		}
		
	}
}