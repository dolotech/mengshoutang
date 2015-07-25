package game.fight
{
	import game.data.HeroData;
	import game.hero.AnimationCreator;
	import game.manager.AssetMgr;
import game.manager.BattleAssets;

import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.text.TextField;
	
	import treefortress.spriter.SpriterClip;
	
	/**
	 *   战斗结束，角色升级动画表现
	 * @author Michael
	 */
	public class LevelupBehavior
	{
		private var _hero:HeroData;
		private var _level:int;
		private var _exp:int;
		private var _container:DisplayObjectContainer;
		/**
		 * 
		 * @param entity
		 */
		public function LevelupBehavior(entity:DisplayObjectContainer,data:HeroData,level:int,exp:int)
		{   
			_level = level;
			_exp = exp;
			_hero = data;
			_container = entity;
			_expTxt = new TextField(150, 50, "" + exp, "myFont",35, 0xffff66, false);
			_expTxt.x = -_expTxt.width / 2;
			_expTxt.y = -entity.height / 2 + 40;
			
			entity.addChild(_expTxt);	
			Starling.juggler.tween(_expTxt, 1, {y:_expTxt.y-100 ,alpha:0.2, onComplete:complete});
		}
		
		private var _expTxt:TextField;
		private var _ani:SpriterClip;
		private function complete():void
		{
			if(_level> 0)
			{
				// 升级特效
				_ani= AnimationCreator.instance.create("effect_52004",BattleAssets.instance);
				Starling.juggler.add(_ani);
				_ani.play("effect_52004");
				_ani.animation.looping = true;
				_ani.animationComplete.addOnce(aniComplete);
				_container.addChild(_ani);
			}
			
			Starling.juggler.removeTweens(_expTxt);
			_expTxt.removeFromParent(true);	
		}
		
		private function aniComplete(obj:Object = null):void
		{
			_ani.removeFromParent(true);
			Starling.juggler.remove(_ani);
		}
	}
}