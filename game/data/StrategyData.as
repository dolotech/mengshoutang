package game.data
{
	import com.data.Data;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class StrategyData extends Data
	{
		public static var list : Dictionary;
		public var type : int;
		public var des : String;
		public var starNum : int;

		public function StrategyData()
		{
			super();
		}

		public static function init(data : ByteArray) : void
		{
			list=new Dictionary();
			data.position = 0;
			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;

			for (var i : int = 0; i < len; i++)
			{
				var obj : Object = vector[i];
				var instance : StrategyData = new StrategyData();

				for (var key : String in obj)
				{
					instance[key] = obj[key];
				}

				if (list[instance.type])
					list[instance.type].push(instance);
				else
					list[instance.type] = [instance];
			}
		}
	}
}