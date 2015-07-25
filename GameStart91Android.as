package
{
	import game.uils.Config;
	
	import sdk.android.D91AndroidDevice;

	public class GameStart91Android extends GameStartAndroidBase
	{
		public function GameStart91Android()
		{
			super(Config.android_91, D91AndroidDevice);
		}
	}
}