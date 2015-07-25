package
{
	import game.uils.Config;
	
	import sdk.android.DHwAndroidDevice;

	public class GameStartHw extends GameStartAndroidBase
	{
		public function GameStartHw()
		{
			super(Config.android_huwei, DHwAndroidDevice);
		}

	}
}