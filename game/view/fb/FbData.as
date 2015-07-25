package game.view.fb
{
	import com.singleton.Singleton;
	
	import game.view.data.Data;

	public class FbData extends Data
	{
		public var number:int;
		public static function get instance():FbData
		{
			return Singleton.getInstance(FbData) as FbData;
		}
	}
}