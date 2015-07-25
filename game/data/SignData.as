package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	
	import flash.utils.ByteArray;
	// 登录表
	public class SignData extends Data
	{
		public var coin:int;
		public var diamond	:int;
		public var tid_num:String;
		public var type:int;
		public var resign_cost:int;
		public var hero:String;
		
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
				var instance : SignData = new SignData();
				for (var key:String in obj)
				{
					instance[key] = obj[key];
				}
				hash.put(instance.type+ ""  + instance.id,instance);
			}
		}
	}
}