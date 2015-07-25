package game.view.new2Guide.view
{
	import com.view.View;

	import starling.display.Quad;
	import com.utils.Constants;

	public class NewGuideMask extends View
	{
		private var mask1 : Quad;
		private var mask2 : Quad;
		private var mask3 : Quad;
		private var mask4 : Quad;

		public function NewGuideMask()
		{
			super(true);
		}

		override protected function init() : void
		{
			for (var i : int = 1; i <= 4; i++)
			{
				this["mask" + i] = new Quad(1, 1, 0x0);
				this.addChild(this["mask" + i]);
			}
			alpha = 0.5;
		}

		public function setMaskRect(x : int, y : int, width : int, height : int) : void
		{
			var sceenWidth : int = Constants.FullScreenWidth / Constants.scale;
			var sceenHeight : int = Constants.FullScreenHeight / Constants.scale;
			updateMaskRect(mask1, 0, 0, sceenWidth, y);
			updateMaskRect(mask2, 0, y, x, height);
			updateMaskRect(mask3, x + width, y, sceenWidth - x - width, height);
			updateMaskRect(mask4, 0, y + height, sceenWidth, sceenHeight - y - height);
		}

		private function updateMaskRect(mask : Quad, x : int, y : int, width : int, height : int) : void
		{
			mask.x = x;
			mask.y = y;
			mask.width = width;
			mask.height = height;
		}
	}
}