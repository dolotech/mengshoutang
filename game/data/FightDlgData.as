package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class FightDlgData extends Data
	{
		
		public var level:int;//关卡等级,这个关卡弹出对话，一般是BOSS
		public var pos:String;//位置
		public var caption:String;//对话内容
		
		
		public function FightDlgData()
		{
			super();
		}
		
		
		public static var hash:HashMap;
		
		public static var Grouping:Dictionary;//保存分组对话
		
		public static function init(data:ByteArray):void
		{
			hash = new HashMap();
			Grouping = new Dictionary();
			data.position = 0;
			var vector:Array = data.readObject() as Array;
			var len:int = vector.length;
			for(var i : int = 0; i < len; i++)
			{
				var obj:Object = vector[i];
				var instance : FightDlgData = new FightDlgData();
				for (var key:String in obj)
				{
					instance[key] = obj[key];
				}
				hash.put(instance.id,instance);
				if(Grouping[instance.level] == null)
				{
					Grouping [instance.level] = new Array();
				}
				Grouping [instance.level].push(instance);
			}
		}
	}
}