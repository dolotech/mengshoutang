package game.data
{
	import com.data.Data;
	import com.data.HashMap;
	
	import flash.utils.ByteArray;
	
	public class GamePhotoData extends Data
	{
		public var picture : int;
		public static var hashMapPhoto : HashMap;
		public function GamePhotoData()
		{
			super();
		}
		
		/**
		 *
		 * @default
		 */
		
		public static function init(data : ByteArray) : void
		{
			hashMapPhoto = new HashMap();
			data.position = 0;
			var vector : Array = data.readObject() as Array;
			var len : int = vector.length;
			
			for (var i : int = 0; i < len; i++)
			{
				var obj : Object = vector[i];
				var instance : GamePhotoData = new GamePhotoData();
				
				for (var key : String in obj)
				{
					instance[key] = obj[key];
				}				
				hashMapPhoto.put(instance.id, instance);
			}
		}
	}
}