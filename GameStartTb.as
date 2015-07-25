package
{
	import game.uils.Config;
	
	import sdk.ios.DTbIosDevice;
	
	public class GameStartTb extends GameStartAndroidBase
	{
		public function GameStartTb()
		{
			super(Config.ios_tb, DTbIosDevice);
		}
	}
}