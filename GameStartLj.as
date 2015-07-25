package
{
	import game.uils.Config;
	
	import sdk.DLjDevice;

	public class GameStartLj extends GameStartAndroidBase
	{
		public function GameStartLj()
		{
			super(Config.android_360, DLjDevice);
		}
	}
}