package game.hero.command
{
import game.data.HeroData;
import game.data.RoleShow;
import game.hero.AnimationCreator;
import game.hero.Hero;
import game.manager.BattleAssets;
import game.manager.BattleHeroMgr;

import treefortress.spriter.SpriterClip;

/**
	 * 受击
	 * @author Michael
	 */
	public class UnderAttackCommand extends Command
	{
		/**
		 * 
		 */
		public function   UnderAttackCommand(executor:Hero)
		{
			super(executor);
		}
		private  var underattack:SpriterClip;

		override public function execute():void
		{
            _hero.onAnimationComplete(onCompleteHer);
            _hero.playUnderAttackAnimation();
            var sponsor:Hero = BattleHeroMgr.instance.hash.getValue(command.sponsor);
            var sponsorRole:RoleShow = RoleShow.hash.getValue(sponsor.data.show);
            var effectStr:String =   sponsorRole.underAttackEffect;
            underattack =AnimationCreator.instance.create(effectStr,BattleAssets.instance,true);
            _hero.addChild(underattack);
            underattack.y = - 40;
            underattack.scaleX = _hero.data.team==HeroData.BLUE?-1:1;
            underattack.play(effectStr);
        }

		private function onCompleteHer(obj:Object):void
		{
            if(_hero.data.currenthp <=0 )
            {
                var deadState:DeadCommand = new DeadCommand(_hero);
                _hero.command.addCommand(deadState);
            }

            onComplete.dispatch(this);
		}
	}
}