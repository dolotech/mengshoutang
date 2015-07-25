package
{
	import game.uils.Config;
	
	import sdk.android.DBdAndroidDevice;

	public class GameStartBaidu extends GameStartAndroidBase
	{
		public function GameStartBaidu()
		{
			super(Config.android_bd, DBdAndroidDevice);
		}
	}
}