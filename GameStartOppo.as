package
{
	import game.uils.Config;
	
	import sdk.android.DOppoAndroidDevice;
	
	public class GameStartOppo extends GameStartAndroidBase
	{
		public function GameStartOppo()
		{
			super(Config.android_oppo, DOppoAndroidDevice);
		}
	}
}