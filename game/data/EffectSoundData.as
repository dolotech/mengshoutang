/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-10-17
 * Time: 下午6:50
 * To change this template use File | Settings | File Templates.
 */
package game.data
{
	import com.data.Data;
	import com.data.HashMap;

	import flash.utils.ByteArray;

	public class EffectSoundData extends Data
	{
		public var sound : String;

		public function EffectSoundData()
		{
			super();
		}


		/**
		 *
		 * @default
		 */
		public static var hash : HashMap;

		/**
		 *
		 * @param data
		 */
		public static function init(data : ByteArray) : void
		{
			hash = new HashMap();
			initData(data, hash, EffectSoundData, "name");
		}
	}
}
