package game.data
{
	import com.data.Data;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class StoryData extends Data
	{
		public var index : int; //关卡
		public var target : int; //关卡
		public var pos : int; //1是好人，2是坏人
		public var caption : String; //对话内容


		public function StoryData()
		{
			super();
		}



		public static var dic : Dictionary; //保存分组对话

		public static function init(data : ByteArray) : void
		{
			dic = new Dictionary();
			data.position = 0;
			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;

			for (var i : int = 0; i < len; i++)
			{
				var obj : Object = vector[i];
				var instance : StoryData = new StoryData();

				for (var key : String in obj)
				{
					instance[key] = obj[key];
				}

				if (dic[instance.index] == null)
					dic[instance.index] = [];
				dic[instance.index].push(instance);
			}
		}
	}
}