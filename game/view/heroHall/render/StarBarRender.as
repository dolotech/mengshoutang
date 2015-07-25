package game.view.heroHall.render
{
	import game.manager.AssetMgr;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	/**
	 * 星级条
	 * @author Samuel
	 *
	 */
	public class StarBarRender extends Sprite
	{
		public function StarBarRender()
		{
			super();
		}

		/**
		 * 传入星级
		 * @param value
		 *
		 */
		public function updataStar(value:uint, scale:Number=1):void
		{
			while (this.numChildren > 0)
			{
				this.getChildAt(0).removeFromParent(true);
			}
			if (value > 0)
			{
				var star:Image=null;
				var textrue:Texture=AssetMgr.instance.getTexture("ui_yingxiongxingjie");
				for (var i:int=0; i < value; i++)
				{
					star=new Image(textrue);
					star.scaleX=scale;
					star.scaleY=scale;
					star.x=i * star.width;
					star.touchable=false;
					addQuiackChild(star);
				}
			}
			this.touchable=false;

		}
		
		public function offsetXY(offsetX:Number,offsetY:Number):void{
			this.x = offsetX;
			this.y = offsetY;
		}

		override public function dispose():void
		{
			while (this.numChildren > 0)
			{
				this.getChildAt(0).removeFromParent(true);
			}
			super.dispose();
		}

	}
}
