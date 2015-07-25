package com.tips
{
	import com.print.print;
	import com.view.View;
	import flash.utils.getTimer;
	
	import flash.geom.Point;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Tips extends Sprite implements ITips
	{
		private var _target : DisplayObject;
		public var _delay : Number = 0;
		
		public function Tips()
		{
			this.touchable = false;
		}
		
		public function set data(value : Object) : void
		{
			
		}
		
		
		public function remove():void
		{
			this.removeFromParent();
			if(_delayedCall)
			{
				Starling.juggler.remove(_delayedCall);
				_delayedCall = null;
			}
			this._target.removeEventListeners(TouchEvent.TOUCH);
			stage && stage.removeEventListeners(TouchEvent.TOUCH);
		}
		
		public function setContain(value : DisplayObject) : void
		{
			if(value == null)
			{
				return;
			}
			this._target = value;
			this._target.addEventListener(TouchEvent.TOUCH, this.onClick);
		}
		
		private function stageClick(e :TouchEvent) : void
		{
			var target:DisplayObject = e.currentTarget as DisplayObject;
			var touch:Touch = e.getTouch(_target.stage);
			
			if(touch)
			{
				if (touch.phase == TouchPhase.BEGAN)
				{
					this.stage.removeEventListener(TouchEvent.TOUCH, stageClick);
					this.removeFromParent();
				}
				
			}
		}
		
		private var _oldTime:int;
		private var _oldPosX:int;
		private var _oldPosY:int;
		private function onClick(e:TouchEvent):void
		{
			var target:DisplayObject = e.currentTarget as DisplayObject;
			var touch:Touch = e.getTouch(_target);
			
			if(touch)
			{
				if(touch.phase == TouchPhase.BEGAN)
				{
					_oldTime = getTimer();
					_oldPosX = touch.globalX;
					_oldPosY =touch.globalY;
				}
				else if(touch.phase == TouchPhase.ENDED)
				{
					if(getTimer() - _oldTime < 1000 && Math.abs(_oldPosX - touch.globalX) < 5 && Math.abs(_oldPosY - touch.globalY) < 5)
					{
							_target.stage.addEventListener(TouchEvent.TOUCH, stageClick);
			
							
							this.alpha = 1;
							_target.stage.addChild(this);
							
							var offsetPoint : Point = this.getoffset(touch.globalX,touch.globalY);
							
							
							x = (touch.globalX + offsetPoint.x);
							y = (touch.globalY + offsetPoint.y);
							
							if(x <= 0)
							{
								x = 0;
							}
							
							if(y <= 0)
							{
								y = 0;
							}
							
							e.stopPropagation();
					}
				}
				else if(touch.phase == TouchPhase.MOVED)
				{
				//	_oldTime = 0;
				}
			}
			
		
		}
		
		private var _delayedCall:DelayedCall;
		
		private function onTouch(e :TouchEvent) : void
		{
			var touch:Touch = e.getTouch(_target);
//  			trace(this,"onTouch",e,touch,_target);
			if (!touch)
			{
				//remove();
				return;
			}
			if(!this.parent && touch.phase == TouchPhase.BEGAN)
			{
				_delayedCall = Starling.juggler.delayCall(delayFun,_delay,touch);				
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				removeFromParent();
				
				if(_delayedCall)
				{
					Starling.juggler.remove(_delayedCall);
					_delayedCall = null;
				}
			}
			else  if(touch.phase == TouchPhase.MOVED)
			{
				//trace(this,"onTouch");
				removeFromParent();
				
				if(_delayedCall)
				{
					Starling.juggler.remove(_delayedCall);
					_delayedCall = null;
				}
			}
			
		}
		
		private function delayFun(touch :Touch) : void
		{
			
			if(!_target.stage)
				return;
			
			if(_delayedCall)
			{
				Starling.juggler.remove(_delayedCall);
				_delayedCall = null;
			}
			this.alpha = 1;
			_target.stage.addChild(this);
			
			var offsetPoint : Point = this.getoffset(touch.globalX,touch.globalY);
			
			
			x = (touch.globalX + offsetPoint.x);
			y = (touch.globalY + offsetPoint.y);
			
			if(x <= 0)
			{
				x = 0;
			}
			
			if(y <= 0)
			{
				y = 0;
			}
		}
		
		public static const GAP:int = 20;
		private function getoffset(globalX:int,globalY:int) : Point
		{
			var mouseoffsetX : Number = 0;
			var mouseoffsetY : Number = 0;
			
			if(globalX > (this._target.stage.stageWidth - this.width - GAP))
			{
				mouseoffsetX = (-GAP - this.width);
			}
			else
			{
				mouseoffsetX = GAP;
			}
			
			if(globalY > (this._target.stage.stageHeight - this.height - GAP))
			{
				mouseoffsetY = (-GAP - this.height);
			}
			else
			{
				mouseoffsetY = GAP;
			}
			return (new Point(mouseoffsetX, mouseoffsetY));
		}
	}
}