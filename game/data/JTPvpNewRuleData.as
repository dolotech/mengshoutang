package game.data
{
	import com.data.Data;
	import com.data.HashMap;

	import flash.utils.ByteArray;

	public class JTPvpNewRuleData extends Data
	{
		public var title1 : String = null;
		public var total_num : String;
		public var rank : int;
		public static var hash : HashMap = null;

		public function JTPvpNewRuleData()
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
				var instance : JTPvpNewRuleData = new JTPvpNewRuleData();
				var dataInfo : Object = list[i];

				for (var key : String in dataInfo)
				{
					instance[key] = dataInfo[key];
					
					if (key == "total_num")
					{
						instance.rank = instance.total_num.split("-").pop();
						
						if (instance.rank == 0)
							instance.rank = 99999999;
					}
				}
				hash.put(instance.id, instance);
			}
		}

		public static function getPvpTemplate(lvl : int) : JTPvpNewRuleData
		{
			return hash.getValue(lvl);
		}
	}
}