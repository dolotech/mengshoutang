package game.data
{
	import com.data.HashMap;

	import flash.utils.ByteArray;


	/**
	 * 怪物数据
	 * @author joy
	 */
	public class MonsterData extends HeroData
	{
		/**
		 *
		 */
		public function MonsterData()
		{
			super();
		}

		public static var monster : HashMap;

		public static function init(data : ByteArray) : void
		{
			monster = new HashMap();
			initData(data, monster, MonsterData, "type");
		}
	}
}
