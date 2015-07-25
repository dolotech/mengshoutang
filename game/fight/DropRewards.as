package game.fight
{
	import flash.geom.Point;
	
	import game.data.WidgetData;
	import game.view.widget.BagWidget;
	import game.view.widget.Widget;
	
	import starling.animation.Transitions;
	import starling.core.Starling;

	/**
	 * 战斗内，掉落奖励 
	 * @author Michael
	 * 
	 */	
	public class DropRewards extends SPEntity
	{
		
		private var _widgets:Vector.<WidgetData>;
		public function DropRewards(vector:Vector.<WidgetData>)
		{
			_widgets = vector;
			
		}
		
		
		
		override public function added():void
		{
			var len:int = _widgets.length;
			for(var i:int = 0;i<len;i++)
			{
				var postion:Point = Position.instance.getPoint(i+21);
				var widget:Widget = new BagWidget(_widgets[i],false);
				widget.x = postion.x;
				widget.y = postion.y - 200;
				
				addChild(widget);
				widget.touchable = false;
				Starling.juggler.tween(widget,0.2,{y:postion.y,transition: Transitions.EASE_OUT_BACK});
			}
		}
	}
}