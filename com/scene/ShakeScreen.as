package com.scene
{
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObject;

	/**
	 * 震屏实现
	 * @author joy
	 */
	public class ShakeScreen  implements IAnimatable
	{
		private var _arry:Array = [-16,16,-12,12,-8,8,-4,4];
		private var _count:int;
		private var _delay:Number = 0;
		private var _totalTime:Number = 0;
		private var _stage:DisplayObject;
		/**
		 * 
		 * @param delay
		 */
		public function ShakeScreen(stage:DisplayObject,delay:Number=1)
		{
			_stage = stage;
			_delay = delay;
		}
		
		private var _interval:int;
		/**
		 * 
		 * @param time
		 */
		public function advanceTime(time:Number):void
		{
			_totalTime += time;
			
			if(_totalTime * 1000 - _interval > 50)
			{
				_interval = _totalTime * 1000;
				
				if(_stage)
				{
					if(_totalTime < _delay)
					{
						_stage.y=_arry[_count++ % _arry.length];
					}
					else
					{
						Starling.juggler.remove(this);
						_stage.y = 0;
					}
				}
				else
				{
					Starling.juggler.remove(this);
				}
			}
		}
		
		/**
		 * 
		 */
		public function start():void
		{
			Starling.juggler.add(this);
		}
	}
}