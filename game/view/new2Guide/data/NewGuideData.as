package game.view.new2Guide.data
{
	import com.data.Data;

	import flash.utils.ByteArray;

	import game.view.new2Guide.NewGuide2Manager;


	public class NewGuideData extends Data
	{
		public var client_step : int;
		public var server_step : int;
		public var scene : String = "";
		public var view : String = "";
		public var viewParam : Array;
		public var viewData : String;

		public function NewGuideData()
		{
			super();
		}

		public static function init(data : ByteArray) : void
		{
			NewGuide2Manager.list_guide.length = 0;
			var list : Array = data.readObject() as Array;
			var exp : RegExp = /\{[\d,\,]*\}/gs;
			var ex : RegExp = /\d+/gs;
			var i : int = 0;
			var l : int = list.length;
			var obj : Object;
			var guideData : NewGuideData;
			var key : String;

			for (i = 0; i < l; i++)
			{
				obj = list[i];
				guideData = new NewGuideData();

				for (key in obj)
				{
					if (obj[key] == undefined)
						obj[key] = "";

					if (key == "viewParam")
						guideData[key] = obj[key].split(",");
					else
						guideData[key] = obj[key];
				}

				NewGuide2Manager.list_guide.push(guideData);
			}
		}
	}
}