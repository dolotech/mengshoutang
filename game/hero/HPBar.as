package game.hero
{
	import game.manager.AssetMgr;

import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;

	/**
	 * 战斗内人物血条 
	 * @author Michael
	 * 
	 */	
	public class HPBar extends Sprite
	{
		private var _bg:Image;
		private var _mask:Image;
		private var _bar:Image;
		private var _original:int;
		public function HPBar()
		{
			super();
			
			_bar = new Image(AssetMgr.instance.getTexture("lifebar2x"));
			_bg = new Image(AssetMgr.instance.getTexture("lifebg2x"));
			_mask = new Image(AssetMgr.instance.getTexture("lifebar2x"));
			
			_bg.x = _mask.x = _bar.x = 1;
			_bg.y = _mask.y = _bar.y = 17;
			_mask.alpha = 0.5;
			
			_original = _bar.width;
			addChild(_bg);
			addChild(_mask);
			addChild(_bar);
		}
		private var _progress:Number;
		public function get progress():Number
		{
			return _progress;
		}
		
		public function set progress(value:Number):void
		{
			if(value < 0 ||value > 1) return;
			_progress = value;
			_bar.width = _original * value >> 0;
			Starling.juggler.tween(_mask,1,{width:_bar.width});
		}
		
		override public function dispose():void
		{
			removeFromParent();
			Starling.juggler.removeTweens(_mask);
			super.dispose();		
		}
	}
}