package
{
	import game.uils.Config;
	
	import sdk.android.DAndroidDevice;
	import sdk.android.DAndroidHttpServer;

	public class GameStartAndroid extends GameStartAndroidBase
	{
		public function GameStartAndroid()
		{
			super(Config.android, DAndroidDevice);
		}

		override protected function changeYingxiong() : void
		{
			DAndroidHttpServer.getInstance().getSession();
			addChild(new yingxiong());
		}
	}
}