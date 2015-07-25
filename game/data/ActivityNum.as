package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	
	import flash.utils.ByteArray;
	
	import game.net.data.IData;
	
	public class ActivityNum extends Data
	{
		public var tableName:String;
		public var showClass:String;
		public var caption:String;
		public var ids:Vector.<IData>;
		public var loadUrl:String;
		public var ratingUrl:String;
		
		public var code:int;//验证码
		
		public function ActivityNum()
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
				var instance : ActivityNum = new ActivityNum();
				
				for (var key:String in obj)
				{
					instance[key] = obj[key];
				}
				hash.put(instance.id,instance);
			}
		}
		
		
	}
}