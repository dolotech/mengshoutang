package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	
	import flash.utils.ByteArray;
	
	public class HeroPriceData extends Data
	{
		public var rarity:int;
		public var quality:int;
		public var price:int;
		public var type:int;
		
		public function HeroPriceData()
		{
			super();
		}
		
		
		
		/**
		 *
		 * @default
		 */
		public static var hash:HashMap;
		
		/**
		 *
		 * @param data
		 */
		public static function init(data:ByteArray):void
		{
			hash=new HashMap();
			data.position=0;
			
			var vector:Array=data.readObject() as Array;
			var len:int=vector.length;
			for (var i:int=0; i < len; i++)
			{
				var obj:Object=vector[i];
				var instance:HeroPriceData=new HeroPriceData();
				
				for (var key:String in obj)
				{
					var value:String=obj[key];
					instance[key]=value;
				}
				hash.put(instance.rarity +""+ instance.quality, instance);
			}
		}
		
		
	}
}