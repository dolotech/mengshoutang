package
{
	import game.uils.Config;
	
	import sdk.android.DXmAndroidDevice;
	
	public class GameStartXm extends GameStartAndroidBase
	{
		public function GameStartXm()
		{
			super(Config.android_xm, DXmAndroidDevice);
		}
		
	}
}