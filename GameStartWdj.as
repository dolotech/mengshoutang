package
{
	import game.uils.Config;

	import sdk.android.DWdjDevice;

	/**
	 * 豌豆荚
	 * @author hyy
	 *
	 */
	public class GameStartWdj extends GameStartAndroidBase
	{
		public function GameStartWdj()
		{
			super(Config.android_wdj, DWdjDevice, isFlashScreen);
		}
	}
}