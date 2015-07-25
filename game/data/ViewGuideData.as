package game.data
{
	import com.data.Data;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import game.view.viewGuide.ViewGuideManager;

	public class ViewGuideData extends Data
	{
		public function ViewGuideData()
		{
			super();
		}
		public var tollgateId : int;
		public var scene : String = "";
		public var view : String = "";
		public var viewData : String = "";
		public var viewParam : Array;


		public static function init(data : ByteArray) : void
		{
			ViewGuideManager.list_guide = new Dictionary();
			var list : Array = data.readObject() as Array;
			var exp : RegExp = /\{[\d,\,]*\}/gs;
			var ex : RegExp = /\d+/gs;
			var i : int = 0;
			var l : int = list.length;
			var obj : Object;
			var guideData : ViewGuideData;
			var key : String;

			for (i = 0; i < l; i++)
			{
				obj = list[i];
				guideData = new ViewGuideData();

				for (key in obj)
				{
					if (obj[key] == undefined)
						obj[key] = "";

					if (key == "viewParam")
						guideData[key] = obj[key].split(",");
					else
						guideData[key] = obj[key];
				}

				if (ViewGuideManager.list_guide[guideData.tollgateId])
					ViewGuideManager.list_guide[guideData.tollgateId].push(guideData);
				else
					ViewGuideManager.list_guide[guideData.tollgateId] = [guideData];
			}
		}
	}
}