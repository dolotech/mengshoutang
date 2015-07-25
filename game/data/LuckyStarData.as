package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	
	import flash.utils.ByteArray;
	
	public class LuckyStarData extends Data
	{
		/**
		 *物品编号 
		 */		
		public var type:int ;
		
		/**
		 *物品 位置
		 */		
		public var pos:int;
		/**
		 *物品数量 
		 */		
		public var num:int;
		/**
		 *物品价值 
		 */		
		public var value:int;
		/**
		 *品质 
		 */		
		public var quality:int;
		
		public var type1:int;
		
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
				var instance : LuckyStarData = new LuckyStarData();
				
				for (var key:String in obj)
				{
					if(key == "num" && String(obj[key]).indexOf("{") !=-1)
					{
						var ex:RegExp = /\d+/gs;
						var str:String  = obj[key];
						var arr:Array = str.match(ex);
						instance.quality = arr[1];
						instance.type1 = arr[0];
					}
					else instance[key] = obj[key];
				}
				
				hash.put(instance.id+""+instance.pos,instance);
			}
			LuckGoods(1);
		}
		
		/**
		 * 
		 * @param id  期号
		 * @return 
		 * 
		 */			
		public static function  LuckGoods(id:int):Vector.<LuckyStarData>
		{
			var i:int = 1;
			var vect:Array = [];
			var len:int = LuckyStarData.hash.keys().length;
			var value:LuckyStarData;
			var key:String ;
			for (var k:int = 0 ;k < len ; k ++)
			{
				key = LuckyStarData.hash.keys()[k];
				value = LuckyStarData.hash.getValue(key);
				
				if(value.id == id )
				{
					vect[i-1] = {pos:value.pos,data:value};
					i++;
					
				}
			}
			var vect1:Vector.<LuckyStarData> = new Vector.<LuckyStarData>;
			
			vect.sortOn(["pos"],Array.NUMERIC );
			len = vect.length;
			for (k = 0 ; k < len ; k ++)
			{
				vect1[k] = vect[k].data;
			}
			
			return vect1;
		}
		
		/**
		 * 获取抽奖道具
		 * @param issue 期号
		 * @param type 物品type
		 * @param pos 位置
		 * @return 
		 * 
		 */		
		public static function getLuckItemInfo(issue:int, type:int, pos:int):LuckyStarData
		{
			var i:int = 0;
			var vect:Array = [];
			var keys:Vector.<*> = LuckyStarData.hash.keys();
			var length:int = keys.length;
			var luck:LuckyStarData = null;
			for (i = 0; i < length ; i ++)
			{
				var key:String = keys[i];
				var luckInfo:LuckyStarData = LuckyStarData.hash.getValue(key) as LuckyStarData;
				if (luckInfo.id != issue)
				{
					continue;
				}
				if (luckInfo.type != type)
				{
					continue;
				}
				if (luckInfo.pos != pos)
				{
					continue;	
				}
				luck = luckInfo;
				break;
			}
			return luck;
		}
	}
}