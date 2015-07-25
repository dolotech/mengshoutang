package game.hero.command
{
	import com.cache.Pool;
	import com.dialog.DialogMgr;
	import com.scene.SceneMgr;
	import com.utils.Delegate;

	import game.data.HeroData;
	import game.data.RoleShow;
	import game.data.SkillData;
	import game.fight.MageBall;
	import game.hero.Hero;
	import game.manager.BattleHeroMgr;
	import game.net.data.IData;
	import game.net.data.vo.BattleTarget;
	import game.scene.BattleScene;

	import starling.core.Starling;

	import treefortress.spriter.SpriterClip;

	public class MageBallCommand extends Command
	{
		public function MageBallCommand(executor:Hero)
		{
			super(executor);
		}

		private function hurtCallback():void
		{
			var battleTarget:Vector.<IData>=command.targets;
			var len:int=battleTarget.length;

			for (var i:int=0; i < len; i++)
			{
				var battleT:BattleTarget=battleTarget[i] as BattleTarget;
				var target:Hero=BattleHeroMgr.instance.hash.getValue(battleT.id) as Hero;
				var heroShow:RoleShow=RoleShow.hash.getValue(_hero.data.show);
				var skillData:SkillData=SkillData.getSkill(command.skill);

				if (heroShow.attackEffect && skillData.magicType == 2)
				{
					var ball:MageBall=new MageBall(_hero.data);
					DialogMgr.instance.closeAllDialog();
					var scene:BattleScene=SceneMgr.instance.getCurScene() as BattleScene;
					//                1：头顶
					//                2：中间
					//                3：移动攻击
					scene.addEffect(ball, _hero.x + ((_hero.hitWidth / 2) * _hero.data.team == HeroData.BLUE ? 1 : -1), _hero.y - (heroShow.attackType == 1 ? _hero.hitHeight : _hero.hitHeight / 2));

					ball.moveComplete.addOnce(Delegate.createFunction(moveComplete, target, battleT));
					ball.moveto(target, ((target.hitWidth / 2) * target.data.team == HeroData.BLUE ? 1 : -1), -(heroShow.attackType == 1 ? target.hitHeight : target.hitHeight / 2));
				}
				else
				{
					moveComplete(null, target, battleT);
				}
			}
//			_hero.onNextOne.dispatch(_hero);
		}

		private function moveComplete(sp:MageBall, target:Hero, battleT:BattleTarget):void
		{
			onComplete.dispatch(this);
		}

		override public function execute():void
		{
			_hero.playAttackSound();
			_hero.playSkillAnimation();
			_hero.onAnimationComplete(onCompleteHdr);
			_hero.addFrameCallback(hurtCallback);
		}

		private function onCompleteHdr(sp:SpriterClip):void
		{
			onComplete.dispatch(this);
		}

		private function skillEffectComplete(sp:SpriterClip):void
		{
			Starling.juggler.remove(sp);
			sp.removeFromParent();
			Pool.setObj(sp, sp.name);
		}
	}
}
