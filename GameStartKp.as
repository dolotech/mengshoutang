package
{
	import game.uils.Config;
	
	import sdk.android.DKpAndroidDevice;
	
	/**
	 * 酷派 
	 * @author hyy
	 * 
	 */
	public class GameStartKp extends GameStartAndroidBase
	{
		public function GameStartKp()
		{
			super(Config.android_kp, DKpAndroidDevice);
		}
	}
}