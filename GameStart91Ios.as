package
{
	import game.uils.Config;
	
	import sdk.ios.D91IosDevice;

	public class GameStart91Ios extends GameStartIosBase
	{
		public function GameStart91Ios()
		{
			super(Config.ios_91, D91IosDevice);
		}
	}
}