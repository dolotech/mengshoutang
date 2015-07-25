package
{
	import game.uils.Config;
	
	import sdk.android.DLenovoAndroidDevice;
	
	public class GameStartLenovo extends GameStartAndroidBase
	{
		public function GameStartLenovo()
		{
			super(Config.android_lenovo, DLenovoAndroidDevice);
		}
	}
}