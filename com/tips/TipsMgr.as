package com.tips
{
	import com.singleton.Singleton;
	
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.events.Event;


	/**
	 * 
	 * 手指按住，弹出提示框
	 * * @author Michael
	 *
	 */
	public class TipsMgr
	{
		public var hash: Dictionary;
		
		public static function get instance():TipsMgr
		{
			return Singleton.getInstance(TipsMgr) as TipsMgr;
		}
		
		public function TipsMgr()
		{
			super();
			hash = new Dictionary();
		}

		public function create(target : DisplayObject, className : Class, param : Object = null, delay : Number = 0.5) :Tips
		{
			var toolTip : Tips = null;
			
			if(!target)
			{
				return toolTip;
			}
			
			function onAddToStage(e : Event) : void
			{
				create(e.currentTarget as DisplayObject, className, param, delay);
			}
			function onRemoveToStage(e : Event) : void
			{
				remove(e.currentTarget as DisplayObject);
			}

			if(!target.stage)
			{
				target.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			}
			else
			{
				target.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveToStage);

				toolTip  = hash[target];
				if(!toolTip)
				{
					
//					toolTip = Cache.instance.get(flash.utils.getQualifiedClassName(className));
//					trace(flash.utils.getQualifiedClassName(className),toolTip);
					if(!toolTip)
					{
						toolTip = new className();
					}
					hash[target] = toolTip;
					
					toolTip.setContain( target);
				}

				toolTip.data = param;
				toolTip._delay = delay;
			}
			return toolTip;
		}

		public function remove(contain : DisplayObject) : void
		{
			if(!hash[contain])
			{
				return;
			}
			var tips : Tips = (hash[contain] as Tips);

			tips.remove();
			
			contain.removeEventListeners(Event.ADDED_TO_STAGE);
			contain.removeEventListeners(Event.REMOVED_FROM_STAGE);
			delete hash[contain];
			
//			Cache.instance.set(flash.utils.getQualifiedClassName(tips),tips);
		}
	}
}
