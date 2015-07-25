package game.view.arena
{
	import game.view.uitils.DisplayMemoryMrg;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	public class ArenafaceFactory extends Sprite
	{
		public function ArenafaceFactory()
		{
			super();
		}
		
		public function createFace(type:String):void
		{
			var face:DisplayObject ;
			if(numChildren > 0)  face = getChildAt(0);
			
			face &&	face.removeFromParent();
			face = null;
			
			//玩家挑战界面
			if(type == "dare")
			{
				face = DisplayMemoryMrg.instance.getMemory(type,DareFace);
			}
			else if(type == "convert")//兑换
			{
				face = DisplayMemoryMrg.instance.getMemory(type,ConvertFace);
			}
			else if(type == "Battlefield")//战报
			{
				face = DisplayMemoryMrg.instance.getMemory(type,BattlefieldFace);
				(face as BattlefieldFace).send();
			}
			else if(type == "rank")//排行
			{
				face = DisplayMemoryMrg.instance.getMemory(type,RankFace);
				(face as RankFace).send();
			}
			else if(type == "Reward")//悬赏
			{
				face = DisplayMemoryMrg.instance.getMemory(type,RewardFace);
				(face as RewardFace).send();
			}
			
			if(face)addChild(face);
		}
	}
}