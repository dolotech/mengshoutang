package game.view.closeDlgBackroud
{
	import com.utils.Constants;
	import com.view.Clickable;

	import starling.display.Quad;

	public class CloseDlgBackground extends Clickable
	{
		public function CloseDlgBackground(alpha : Number = 0.1)
		{
			var q : Quad = new Quad(Constants.FullScreenWidth / Constants.scale, Constants.FullScreenHeight / Constants.scale, 0x000);
			q.alpha = alpha;
			this.addChildAt(q, 0);
			//this.click_target = q;
		}
	}
}