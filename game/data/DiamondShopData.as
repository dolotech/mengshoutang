package game.data
{
	import com.data.Data;

	import flash.utils.ByteArray;

	// 钻石商店表
	public class DiamondShopData extends Data
	{

		public var shopid : int;
		public var idNume : String;
		public var tier : int;
		public var rmb : int;
		public var twd : int;
		public var usd : String;
		public var fun : int;
		public var diamond : int;
		public var rate : int;
		public var rateCen : int;
		public var mcard : int;
		public var double : int;


		public static var list : Array = [];

		public static function init(data : ByteArray) : void
		{
			list.length = 0;
			data.position = 0;
			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;

			for (var i : int = 0; i < len; i++)
			{
				var obj : Object = vector[i];
				var instance : DiamondShopData = new DiamondShopData();

				for (var key : String in obj)
				{
					instance[key] = obj[key];
				}
				list.push(instance);
			}

		}
	}
}