package game.base
{
	import game.view.chat.base.JTUIBackGround;
	
	public class JTPanel extends JTSprite
	{
		public function JTPanel()
		{
			super();
		}
		/**
		 * 整屏黑背景
		 * @param isClickColse
		 * @param x
		 * @param y
		 * @param maxWidth
		 * @param maxHeight
		 * 
		 */

		override public function showBackground(isClickColse:Boolean=false, x:Number=0, y:Number=0, maxWidth:Number=0, maxHeight:Number=0):void
		{
			JTUIBackGround.isTouchable = true;
			background = new JTUIBackGround();
			background.x = 0;
			background.y = 0;
			this.addChildAt(background, 0);
		}
	}
}