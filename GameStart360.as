package
{
	import game.uils.Config;
	
	import sdk.android.D360AndroidDevice;

	public class GameStart360 extends GameStartAndroidBase
	{
		public function GameStart360()
		{
			super(Config.android_360, D360AndroidDevice, false);
		}
	}
}