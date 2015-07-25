package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	
	import flash.utils.ByteArray;

	/**
	 * 
	 * @author Administrator
	 */
	public class StrengthenData extends Data
	{
		/**
		 * 
		 * @default 材料类型
		 */
		public var type:int;
		/**
		 * 
		 * @default 强化级别
		 */
		public var level:int;
		/**
		 * 
		 * @default 金币消耗
		 */
		public var coin:int;
		/**
		 * 
		 * @default 材料编号
		 */
		public var material:int;
		/**
		 * 
		 * @default 疲劳时间
		 */
		public var tired:int;
		/**
		 * 
		 * @default 成功率
		 */
		public var successRate:int;
		/**
		 * 
		 * @default 材料数量
		 */
		public var count:int;

		/**
		 *  @default 疲劳惩罚价格
		 */		
		public var price:int;
		
		/**
		 * 强化比率
		 */		
		public var rise:Number;
		/**
		 *
		 * @default
		 */
		public static var hash:HashMap;

		/**
		 * 
		 */
		public function StrengthenData()
		{
			super();
		}
		

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
				var instance:StrengthenData=new StrengthenData();

				for (var key:String in obj)
				{
					instance[key]=obj[key];
				}

				hash.put(instance.type + "" + instance.level, instance);
			}
		}
	}
}
