package game.scene.world
{
	import com.utils.Constants;
	import com.view.Clickable;

	import starling.display.Quad;

	public class NewMapRender extends Clickable
	{
		private var mask : Quad;

		public function NewMapRender()
		{
			super(false);
			mask = new Quad(Constants.virtualWidth, Constants.virtualHeight);
			mask.alpha = 0;
			addChildAt(mask, 0);
			click_target = mask;
		}

		override public function dispose() : void
		{
			super.dispose();
			mask && mask.dispose();
		}
	}
}