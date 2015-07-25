package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 镶嵌数据
	 * @author Administrator
	 */
	public class EmbedData extends Data
	{
		/**
		 * 宝石类型
		 
		 * @default 
		 */
		public var type:int;
		/**
		 * 镶嵌装备类型
		 * @default 
		 */
		public var sort:int;
		/**
		 * 成功率
		 * @default 
		 */
		public var successRate:int;
		/**
		 * 支付类型
		 * @default 
		 */
		public var spendType:int;
		/**
		 * 花费
		 * @default 
		 */
		public var count:int;
		
		/**
		 * 
		 * @default 
		 */
		public static var hash:HashMap;
		
		/**
		 * 
		 */
		public function EmbedData()
		{
			super();
		}
		
		public static var secondHash:HashMap;
		
		/**
		 *
		 * @param data
		 */
		public static function init(data:ByteArray):void
		{
			hash=new HashMap();
			data.position=0;
			secondHash = new HashMap();
			
			var vector:Array=data.readObject() as Array;
			var len:int=vector.length;
			for (var i:int=0; i < len; i++)
			{
				var obj:Object=vector[i];
				var instance:EmbedData=new EmbedData();
				
				for (var key:String in obj)
				{
					instance[key]=obj[key];
				}
				
				
				var arr:Array = secondHash.getValue(instance.sort);
				if(!arr)
				{
					arr = [];
					secondHash.put(instance.sort,arr);
				}
				if(arr.indexOf(instance.type) == -1)
				{
					arr.push(instance.type);
				}
				
				hash.put(instance.type + ""+instance.sort, instance);
			}
		}

		
	}
}