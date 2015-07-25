package game.data
{
	import com.data.Data;
	import com.data.HashMap;

	import flash.utils.ByteArray;

	/**
	 * 净化数据
	 * @author Administrator
	 */
	public class PurgeData extends Data
	{
		public var level:int;
		public var materials:Array;
		public var type:int;
		public var num:int;

		/**
		 * 
		 * @default 
		 */
		public static var hash:HashMap;

		/**
		 * 
		 */
		public function PurgeData()
		{
			super();
		}

		public static function init(data:ByteArray):void
		{
			hash = new HashMap();
			data.position = 0;
			var exp:RegExp = /\{[\d,\,]*\}/gs;
			var ex:RegExp = /\d+/gs;
			
			var vector:Array = data.readObject() as Array;
			var len:int = vector.length;
			for(var i : int = 0; i < len; i++)
			{
				var obj:Object = vector[i];
				var instance : PurgeData = new PurgeData();
				
				for (var key:String in obj)
				{
					if(key == "materials")
					{
						var str:String = obj[key];
						var arr:Array = str.match(exp);
						var le:int = arr.length;
						instance.materials = [];
						for (var k:int = 0;k<le;k++)
						{
							var sub:String = arr[k];
							var subArr:Array = sub.match(ex);
							instance.materials[k] = subArr;
						}
					}
					else
					{
						instance[key] = obj[key];
					}
				}
				hash.put(instance.level,instance);
			}
		}
	}
}
