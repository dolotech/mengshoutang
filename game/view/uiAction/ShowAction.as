package game.view.uiAction
{
	import starling.core.Starling;
	import starling.display.DisplayObject;

	public class ShowAction
	{
		public function ShowAction()
		{
			
		}
		
		public static function upDown(target:Object,properties:Object,startY:int = -150,time:Number = 0.5):void
		{
			target.y = startY;
	
			Starling.juggler.tween(target,time,properties);
		}
		
		public static function around(target:DisplayObject,properties:Object,round:String= "left",time:Number =0.5):void
		{
			if(round == "left")
			{
				target.x = -(target.width+20);
			}
			else if(round == "right")
			{
				target.x = target.stage.stageWidth + 20;
			}
			Starling.juggler.tween(target,time,properties);
		}
		
		
	}
}