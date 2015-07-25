	package game.base
{
	import com.utils.Assets;
	
	import game.common.JTSession;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import com.utils.Constants;

	/**
	 * 显示容器基类
	 * @author CabbageWrom
	 * 
	 */	
	public class JTSprite extends Sprite
	{
		public var background:DisplayObject = null;
		public function JTSprite()
		{
			super();
		}
		/**
		 * 透明黑色背景
		 * @param isClickColse 是否点击背景关闭此框
		 * @param x 框的X坐标
		 * @param y 框的Y坐票
		 * @param maxWidth 框的宽度，默认为0 （整屏的两倍宽度）
		 * @param maxHeight 框的高度，默认为0（整屏的两倍高度）
		 * 
		 */		
		public function showBackground(isClickColse:Boolean = false,
									   x:Number = 0, y:Number = 0, maxWidth:Number = 0, maxHeight:Number = 0):void
		{
			background && background.removeFromParent(true);
			var stageWidth:Number = JTSession.layerChat.stage.stageWidth * 2;
			var stageHeight:Number = JTSession.layerChat.stage.stageHeight * 2;
			maxHeight *= Constants.scale;
			maxWidth *= Constants.scale;
			background = Assets.getImage(Assets.Alpha_Backgroud);
			background.alpha = .5;
			background.width = maxWidth == 0 ? stageWidth : maxWidth;
			background.height = maxHeight == 0 ?stageHeight : maxHeight;
			background.x = x == 0 ? -(stageWidth - Constants.FullScreenWidth) / 2 : 0;
			background.y = y == 0 ? -(stageHeight - Constants.FullScreenHeight) / 2 : 0;
			this.addChildAt(background, 0);
			if (isClickColse)
			{
				this.background.touchable = true;
				this.background.addEventListener(TouchEvent.TOUCH, onCloseBackgroundHandler);
			}
		}
		
		private function onCloseBackgroundHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if (!touch)
			{
				return;
			}
			var currentTarget:DisplayObject = e.target as DisplayObject;
			if (touch.phase == TouchPhase.ENDED)
			{
				if (currentTarget === this.background)
				{
					onCloseBackground();
				}
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		protected function onCloseBackground():void
		{
			 
		}
		
		/**
		 * 放到屏幕中间
		 * @param _arg1
		 */
		public function setToCenter(x : int = 0, y : int = 0) : void
		{
			this.x = (Constants.FullScreenWidth - this.width) / 2 * Constants.scale;
			this.y = (Constants.FullScreenHeight - this.height) / 2 * Constants.scale;
		}
		
	}
}