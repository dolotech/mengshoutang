package game.view.pageList
{
	import com.utils.TouchProxy;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	/**
	 * 手势
	 * @author litao
	 * 
	 */
	public class Gesture
	{
		private var _target:DisplayObject;

		public var _regist:DisplayObject;
		
		
		public function Gesture(regist:DisplayObject)
		{
			onGesture = new Signal();
			this._regist = regist;
			if(!regist.stage)
				regist.addEventListener(Event.ADDED_TO_STAGE,toStage);
			else toStage();
		}
		public function set target(target:DisplayObject):void
		{
			_target = target;

		}
		
		private function toStage(e:Event = null):void
		{
			if(_regist.hasEventListener(Event.ADDED_TO_STAGE))
				_regist.removeEventListener(Event.ADDED_TO_STAGE,toStage);
			var touch:TouchProxy = new TouchProxy(_regist);
			_regist = null;
			touch.onClick.add(onClick);
			touch.onDown.add(onDown);
			touch.onMove.add(onMove);
			touch.onUp.add(onUp);
		}
		
		
		
		public var onGesture:ISignal ;
		
		
		private var downPoint:Point = new Point();
		private var downTime:Number;
		private var isDown:Boolean;
		private var movePoint:Point = new Point();
		public var isMove:Boolean = true;
		private static var isFirstUp:Boolean = true;
		
		private var moveTime:Number = 0.7;
		public function comBack():void
		{
			Starling.juggler.tween(_target,moveTime,{x:_target.pivotX,onComplete:back});
			function back():void
			{
				isMove = true;
			}
		}
		
		
		private function onUp(e:Touch):void
		{
			if(isFirstUp)
			{
				isFirstUp = false;
				return;
			}
			if(!isMove)return;
			isDown = false;
			
			clickPoint.x = e.globalX;
		
	
			var w:Number = clickPoint.x - downPoint.x;
			if(w > 0)
			{
				if(w >= 100)
				{
					onGesture.dispatch("right");
				}
				else
				{
					onGesture.dispatch("back");
					Starling.juggler.tween(_target,moveTime,{x:_target.pivotX});
				}
			}
			else 
			{
				if(w <= - 100)
				{
					onGesture.dispatch("left");
				}
				else 
				{
					onGesture.dispatch("back");
					Starling.juggler.tween(_target,moveTime,{x:_target.pivotX});
				}
			}

		}
		public var currentMove:Boolean;
		private function onMove(e:Touch):void
		{	
			if(!isMove)return;
			var x:Number = e.globalX - (movePoint.x == 0 ?e.globalX:movePoint.x );
			_target.x += x;
			movePoint.x = e.globalX;
			if(_target.x > 20 || _target.x <- 20)
				currentMove = true;
			if(_target.x < 0)
				onGesture.dispatch("LeftMove");	
			else onGesture.dispatch("RightMove");	
		}
		
		private function onDown(e:Touch):void
		{
			isDown = true;
			downPoint.x = e.globalX;
			downPoint.y = e.globalY;
			movePoint.x = e.globalX;
			downTime = getTimer();
		}
		private var clickPoint:Point = new Point();
		private var clickTime:Number;
		
		private function onClick(e:Touch):void
		{
			if(!isMove)return;
			isDown = false;
			clickPoint.x = e.globalX;
			
			
			var w:Number = clickPoint.x - downPoint.x;
			if(w > 0)
			{
				if(w >= 100)
				{
					onGesture.dispatch("right");
				}
				else
				{
					onGesture.dispatch("back");
					Starling.juggler.tween(_target,moveTime,{x:_target.pivotX});
				}
				currentMove = false;
			}
			else 
			{
				if(w <= - 100)
				{
					onGesture.dispatch("left");
				}
				else 
				{
					onGesture.dispatch("back");
					Starling.juggler.tween(_target,moveTime,{x:_target.pivotX});
				}
				currentMove = false;
			}
			
		}
		
		public function dispose():void
		{
			onGesture.removeAll();
		}
		
	}
}