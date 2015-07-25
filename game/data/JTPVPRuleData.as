package game.data
{
	import com.data.Data;
	import com.data.HashMap;

	import flash.utils.ByteArray;

	public class JTPVPRuleData extends Data
	{
		public var num : int = 0;
		public var up : int = 0;
		public var down : int = 0;
		public var produce : String;
		public var exp : int;
		public static var hash : HashMap = null;

		public function JTPVPRuleData()
		{
			super();
		}


		public static function init(data : ByteArray) : void
		{
			hash = new HashMap();
			var list : Array = data.readObject() as Array;
			var i : int = 0;
			var l : int = list.length;

			for (i = 0; i < l; i++)
			{
				var instance : JTPVPRuleData = new JTPVPRuleData();
				var dataInfo : Object = list[i];

				for (var key : String in dataInfo)
				{
					instance[key] = dataInfo[key];
				}
				hash.put(instance.id, instance);
			}
		}
	}
}