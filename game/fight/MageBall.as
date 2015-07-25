package game.fight
{
	import com.cache.Pool;
	
	import game.data.HeroData;
	import game.data.RoleShow;
	import game.hero.AnimationCreator;
	import game.hero.MoveableEntity;
	import game.manager.BattleAssets;
	
	import starling.core.Starling;
	
	import treefortress.spriter.SpriterClip;

	/**
	 * 飞向目标的魔法球
	 * @author Michael
	 *
	 */
	public class MageBall extends MoveableEntity
	{
		private var _spriteClip:SpriterClip;
		private var _heroData:HeroData;

		/**
		 * 
		 */
		public function MageBall(heroData:HeroData)
		{
			super();
			_heroData = heroData;
			speed=2.2;

            hitWidth = 1;
            hitHeight = 1;

            added();
		}

		private function added():void
		{
            var heroShow:RoleShow = RoleShow.hash.getValue(_heroData.show);

			_spriteClip = Pool.getObj(heroShow.attackEffect)
			if(!_spriteClip)
			{
				_spriteClip = AnimationCreator.instance.create(heroShow.attackEffect,BattleAssets.instance);
                _spriteClip.name =                heroShow.attackEffect;
			}
			Starling.juggler.add(_spriteClip);
			_spriteClip.play(heroShow.attackEffect);
			_spriteClip.scaleX = _heroData.team==HeroData.BLUE?1:-1;
			_spriteClip.animation.looping = true;
			this.addChild(_spriteClip);
            moveComplete.addOnce(onComplete);
		}
        private function onComplete(mageBall:MageBall):void
        {
            _spriteClip.removeFromParent();
            Starling.juggler.remove(_spriteClip);
            Pool.setObj(_spriteClip, _spriteClip.name)
            this.removeFromParent(true);
        }
	}
}