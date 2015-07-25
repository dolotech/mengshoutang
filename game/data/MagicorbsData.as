package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	import com.langue.Langue;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * 魔法宝珠黑市数据
	 * @author Administrator
	 *
	 */
	public class MagicorbsData extends Data
	{
		public static var dic_cost : Dictionary;
		public var level : int;
		public var coinType : int;
		public var coinCount : int;

		public var coinType1 : int;
		public var coinCount1 : int;

		public function MagicorbsData()
		{
			super();
		}
		public static var hash : HashMap;

		public static function init(data : ByteArray) : void
		{
			hash = new HashMap();
			data.position = 0;

			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;

			for (var i : int = 0; i < len; i++)
			{
				var obj : Object = vector[i];
				var instance : MagicorbsData = new MagicorbsData();

				for (var key : String in obj)
				{
					instance[key] = obj[key];
				}
				hash.put(instance.level, instance);
			}
		}

		public static function parseCost(data : ByteArray) : void
		{
			data.position = 0;
			dic_cost = new Dictionary();
			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;

			for (var i : int = 0; i < len; i++)
			{
				var obj : Object = vector[i];
				dic_cost[obj.id] = obj.num + (obj.type == 1 ? Langue.getLangue("buyMoney") : Langue.getLangue("buyDiamond"));
			}
		}
	}
}