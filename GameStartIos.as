package
{
	import game.uils.Config;
	
	import sdk.ios.DGameCenter;

	public class GameStartIos extends GameStartIosBase
	{
		public function GameStartIos()
		{
			super(Config.ios, DGameCenter);
		}
	}
}