package game.scene
{
	import com.utils.Delegate;
	
	import game.data.FightDlgData;
	import game.data.HeroData;
	import game.fight.BattleWordsBehavior;
	import game.hero.Hero;
	import game.manager.BattleHeroMgr;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	/**
	 * 战斗内对话
	 * @author joy
	 */
	public class BattleWords
	{
		/**
		 * 
		 * @对话播放完成
		 */
		public var  onComplete:ISignal;
		private var _container:DisplayObjectContainer;
		/**
		 * 
		 */
		public function BattleWords(container:DisplayObjectContainer)
		{
			onComplete = new Signal(BattleWords);	
			_container = container;
		}
		
		/**
		 *BOSS,弹出对话
		 */
		public function said(level:int):void
		{
			/*
			// 从怪物中随机选中一个，冒泡说话
			var vector:Vector.<Hero> = new Vector.<Hero>();
			var i:int = 0;
			BattleHeroMgr.instance.hash.eachValue(addHeroToStage);
			function addHeroToStage(hero:Hero):void
			{
				if(hero.data.team == HeroData.BLUE)
				{
					vector[i++] = hero;					
				}
			}
			
			var hero:Hero = vector[vector.length * Math.random() >> 0];
			var vo:BattleWordVO = BattleWordVO.getRandom(hero.data.type);
			
			var behavior:BattleWordsBehavior = new BattleWordsBehavior(vo);
			behavior.x = hero.x;
			behavior.y = hero.y - hero.height;
			_container.addChild(behavior);
			Starling.juggler.delayCall(Delegate.createFunction(complete,behavior),BattleWordsBehavior.DELAY);*/
			
			var fightDlgData:Array = (FightDlgData.Grouping[level] as Array)
				if(fightDlgData)fightDlgData = fightDlgData.concat();
			upDialog(fightDlgData);
			
			
		}
		
		private function upDialog(fightDlgData:Array):void
		{
			if(fightDlgData == null || fightDlgData.length == 0)complete(null);
			else 
			{
				var i:int = 0 ; 
				var length:int = fightDlgData.length;
				var posArr:Array = (fightDlgData[0] as FightDlgData).pos.split(",");
			
				var vector:Vector.<Hero> = new Vector.<Hero>();
				BattleHeroMgr.instance.hash.eachValue(addHeroToStage);
				function addHeroToStage(hero:Hero):void
				{
					if(hero.data.team == HeroData.RED)
					{
						vector[i++] = hero;					
					}
				}
				for (var j:int = 0 ; j < posArr.length ; j ++)
				{
					var hero:Hero ;
					for (var k:int = 0 ; k < vector.length ; k ++)
					{
						if((vector[k] as Hero).data.seat == int(posArr[j]) + 20)
						{
							hero = vector[k];
							break;
						}
					}
					
					var behavior:BattleWordsBehavior = new BattleWordsBehavior((fightDlgData[0] as FightDlgData).caption);
				
					_container.addChild(behavior);
					if(hero)
					{
					behavior.x = (hero.x - behavior.width - hero.hitWidth/3) ;
					behavior.y = (hero.y - behavior.height - hero.hitHeight/3);
					}
					Starling.juggler.delayCall(Delegate.createFunction(onComplete,behavior),BattleWordsBehavior.DELAY);
				}
				var count:int;
				function onComplete(behavior:DisplayObject):void
				{
					behavior.removeFromParent(true);
					count == posArr.length;
					fightDlgData.splice(0,1);
					upDialog(fightDlgData);
				}
			}
		}
		
		private function complete(behavior:DisplayObject):void
		{
			behavior && behavior.removeFromParent(true);
			onComplete.dispatch(this)
		}
	}
}