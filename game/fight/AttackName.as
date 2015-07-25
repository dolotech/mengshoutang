package game.fight
{
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class AttackName extends Sprite
	{
		private var _txt:TextField;
		public function AttackName(nameStr:String,x:int,y:int)
		{
//			_txt = new TextField(100,50,""+ nameStr,'Quardi',35,0xffff66,false);
			_txt = new TextField(100,50,""+ nameStr,'',35,0xffff66,false);
			_txt.x =  -_txt.width/2;
			_txt.y =  -_txt.height/2;
			this.x = x;
			this.y = y;
			this.addChild(_txt);	
			Starling.juggler.tween(_txt,1,{y:_txt.y-100,alpha:0.2,onComplete:complete});
		}
		
		private function complete():void
		{
			Starling.juggler.removeTweens(_txt);
			
			_txt.removeFromParent(true);
			this.removeFromParent(true);
		}
	}
}