package
{
	import game.uils.Config;
	
	import sdk.android.DUcAndroidDevice;

	public class GameStartAUc extends GameStartAndroidBase
	{
		public function GameStartAUc()
		{
			super(Config.android_uc, DUcAndroidDevice);
		}
	}
}