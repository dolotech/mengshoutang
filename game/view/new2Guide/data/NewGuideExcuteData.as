package game.view.new2Guide.data
{
	import com.data.Data;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import game.view.new2Guide.NewGuide2Manager;

	public class NewGuideExcuteData extends Data
	{
		public var tag : String;
		public var guide : String;
		public var excute : String;
		public var dialog : String;
		public var animation : String;
		public var arrow : String;
		public var sendStep : int;

		public static function init(data : ByteArray) : void
		{
			NewGuide2Manager.list_excute = new Dictionary();
			var list : Array = data.readObject() as Array;
			var exp : RegExp = /\{[\d,\,]*\}/gs;
			var ex : RegExp = /\d+/gs;
			var i : int = 0;
			var l : int = list.length;
			var obj : Object;
			var guideData : NewGuideExcuteData;
			var key : String;

			for (i = 0; i < l; i++)
			{
				obj = list[i];

				guideData = new NewGuideExcuteData();

				for (key in obj)
				{
					if (key == null)
						continue;

					if (obj[key] == undefined)
						obj[key] = "";
					guideData[key] = obj[key];
				}

				NewGuide2Manager.list_excute[guideData.tag] = guideData;
			}
		}
	}
}