package com.view.base.event
{
	import com.singleton.Singleton;
	
	import starling.events.EventDispatcher;

	public class ViewDispatcher extends EventDispatcher
	{
		public function ViewDispatcher()
		{
			super();
		}
		
		public static function get instance() : ViewDispatcher{
			return Singleton.getInstance(ViewDispatcher) as ViewDispatcher;
		}

		/**
		 * 派发事件
		 * @param type
		 * @param obj
		 *
		 */
		public function dispatch(type : String, obj : * = null) : void{
			instance.dispatchEventWith(type, false, obj);
		}

		/**
		 * 派发事件
		 * @param type
		 * @param obj
		 *
		 */
		public static function dispatch(type : String, obj : * = null) : void{
			instance.dispatch(type, obj);
		}
		
	}
}