package game.view.city 
{
	import flash.geom.Rectangle;
	import game.manager.AssetMgr;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Cloud extends Sprite    implements IAnimatable
	{
		private var _image:Image;
		private var _w:int;
		private var _h:int;
		public static const SPEED:Number = 0.5;
		public static const Y:int = 230;
		public static const DELAY:int = 10;
		
		public function Cloud(w:int,h:int,assets:String) 
		{
			super();
			_image = new Image(AssetMgr.instance.getTexture(assets));
			_image.y = Math.random() * Y;
			_image.x = Math.random() *w;
			_w = w;
			_h = h;
			addChild(_image);
			play();
			this.clipRect = new Rectangle(0,0,_w,_h);
		}
		
		public function play():void
		{
			Starling.juggler.add(this);
		}
		
		public function stop():void
		{
			Starling.juggler.remove(this);
		}
		
		
		public function advanceTime(time : Number) : void
		{
			if (_image.x > _w)
			{
				_image.x = - _image.width;
				_image.y = Math.random() * Y >> 0;
				stop();
				
				Starling.juggler.delayCall(play,Math.random() * DELAY );
			}
			
			
			_image.x += SPEED;
		}
	}
}