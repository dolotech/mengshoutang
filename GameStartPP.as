package
{
	import game.uils.Config;
	
	import sdk.ios.DPpIosDevice;
	
	public class GameStartPP extends GameStartAndroidBase
	{
		public function GameStartPP()
		{
			super(Config.android_pp, DPpIosDevice);
		}
	}
}