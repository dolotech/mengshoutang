package game.view.new2Guide.data
{
	import com.data.Data;
	import com.mobileLib.utils.ConverURL;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import game.manager.AssetMgr;

	public class NewDialogData extends Data
	{
		public static var list_dialog : Dictionary;

		public var type : int;
		public var align : int;
		public var text : String;
		public var des : String;
		public var photo : String;

		public function NewDialogData()
		{
			super();
		}

		public static function loadAllRes(assetMgr : AssetMgr) : void
		{
			for each (var data : NewDialogData in list_dialog)
			{
				assetMgr.enqueue(ConverURL.conver("portrait/" + data.photo));
			}
		}

		public static function removeAllRes(assetMgr : AssetMgr) : void
		{
			for each (var data : NewDialogData in list_dialog)
			{
				assetMgr.removeUi(data.photo, "portrait/" + data.photo + "/");
			}
		}

		public static function init(data : ByteArray) : void
		{
			list_dialog = new Dictionary();
			var list : Array = data.readObject() as Array;
			var exp : RegExp = /\{[\d,\,]*\}/gs;
			var ex : RegExp = /\d+/gs;
			var i : int = 0;
			var l : int = list.length;
			var obj : Object;
			var guideData : NewDialogData;
			var key : String;

			for (i = 0; i < l; i++)
			{
				obj = list[i];
				guideData = new NewDialogData();

				for (key in obj)
				{
					if (key.indexOf("\r") >= 0)
						key = key.replace("\r", "");
					guideData[key] = obj[key];
				}
				list_dialog[guideData.id] = guideData;
			}
		}
	}
}