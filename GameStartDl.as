package
{
	import game.uils.Config;
	
	import sdk.android.DDlAndroidDevice;

	public class GameStartDl extends GameStartAndroidBase
	{
		public function GameStartDl()
		{
			super(Config.android_dl, DDlAndroidDevice);
		}

	}
}