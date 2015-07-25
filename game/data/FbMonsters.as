package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	
	import flash.utils.ByteArray;
	
	public class FbMonsters extends Data
	{
		
		public var id1:int;
		public var id2:int;
		public var tid:int;
		
		public static var hash:HashMap;
		public function FbMonsters()
		{
			super();
		}
		
		public static function init(data:ByteArray):void
		{
			hash=new HashMap();
			
			var vector:Array=data.readObject() as Array;
			var len:int=vector.length;
			for (var i:int=0; i < len; i++)
			{
				var obj:Object=vector[i];
				var instance:FbMonsters = new FbMonsters();
				
				for (var key:String in obj)
				{
					instance[key]=obj[key];
				}
				var fb:FbMonsters = FbMonsters.hash.getValue(instance.id1);
				instance.copy(fb);
				hash.put(instance.id1 + "" + instance.id2 + instance.tid, instance);
			}
		}
	}
}