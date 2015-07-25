package game.hero.command
{

	import com.dialog.DialogMgr;
	import com.scene.SceneMgr;
	import com.scene.ShakeScreen;
	import com.sound.SoundManager;
	import com.utils.Delegate;

	import game.data.HeroData;
	import game.data.RoleShow;
	import game.data.Val;
	import game.fight.BaojiAnimation;
	import game.fight.DropHPNumber;
	import game.fight.MageBall;
	import game.fight.ShanBiAnimation;
	import game.hero.Hero;
	import game.manager.BattleHeroMgr;
	import game.net.data.IData;
	import game.net.data.vo.BattleTarget;
	import game.scene.BattleScene;

	import treefortress.spriter.SpriterClip;

	/**
	 * 非技能攻击 状态
	 * @author Michael
	 *
	 */
	public class AttackCommand extends Command
	{

		public function AttackCommand(executor:Hero)
		{
			super(executor);
		}

		private function onCompleteHdr(sp:SpriterClip):void
		{
			onComplete.dispatch(this);
		}

		private function hurtCallback():void
		{
			_hero.updateBuff(command.buffid);

			var battleTarget:Vector.<IData>=command.targets;
			var len:int=battleTarget.length;

			for (var i:int=0; i < len; i++)
			{
				var battleT:BattleTarget=battleTarget[i] as BattleTarget;
				var target:Hero=BattleHeroMgr.instance.hash.getValue(battleT.id) as Hero;
				var heroShow:RoleShow=RoleShow.hash.getValue(_hero.data.show);

				if (heroShow.attackEffect)
				{
					var ball:MageBall=new MageBall(_hero.data);
//					DialogMgr.instance.closeAllDialog();
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
		}

		private function moveComplete(sp:MageBall, target:Hero, battleT:BattleTarget):void
		{

			var state:int=battleT.state;

			//		闪避
			if (state & Val.SB)
			{
				var scene:BattleScene=SceneMgr.instance.getCurScene() as BattleScene;
				var s:ShanBiAnimation=new ShanBiAnimation();
				scene.addEffect(s, target.x, target.y - target.height / 2);
				next();
			}
			else
			{
				DialogMgr.instance.closeAllDialog();
				scene=SceneMgr.instance.getCurScene() as BattleScene;
				var underAttackCmd:UnderAttackCommand; //受击音效
				var hp:DropHPNumber;
				var power:int;

				if (battleT.state & Val.FH)
					// if(true)
				{
					if (target.data.currenthp > 0)
					{
						underAttackCmd=new UnderAttackCommand(target);
						underAttackCmd.command=command;
						target.command.addCommand(underAttackCmd);

						var deadState:DeadCommand=new DeadCommand(target);
						target.command.addCommand(deadState);

						target.onHPChange.dispatch(target);

						var gegeneracy:RegeneracyCommand=new RegeneracyCommand(target);
						gegeneracy.battleTarget=battleT;
						gegeneracy.onComplete.addOnce(next);
						target.command.addCommand(gegeneracy);
					}
					else
					{
						var gegeneracyCommand:RegeneracyCommand=new RegeneracyCommand(target);
						gegeneracyCommand.battleTarget=battleT;
						target.command.addCommand(gegeneracyCommand);
						gegeneracyCommand.onComplete.addOnce(next);
					}
				}
				else if (battleT.state & Val.ZL) //治疗
				{
					// 加血文字
					power=battleT.hp - target.data.currenthp;
					scene=SceneMgr.instance.getCurScene() as BattleScene;
					hp=new DropHPNumber("+" + power, battleT, 0x00FF00);
					scene.addEffect(hp, target.x, target.y - target.height / 2);
					target.data.currenthp=battleT.hp;
					target.onHPChange.dispatch(target);
					next();
				}
				else
				{
					power=target.data.currenthp - battleT.hp;
					target.data.currenthp=battleT.hp;

					//暴击
					if (state & Val.BJ)
					{
						var shakeEffect:ShakeScreen=new ShakeScreen(scene, 0.2);
						shakeEffect.start();
						SoundManager.instance.playSound("baoji");
						var baojiAnimation:BaojiAnimation=new BaojiAnimation();
						scene.addEffect(baojiAnimation, target.x, target.y - target.height / 2);

					}
					else
					{
//                        SoundManager.instance.playSound("underattack");
					}

					if (power > 0)
					{
						// 扣血文字
						hp=new DropHPNumber("-" + power, battleT, 0xff0000);
						scene.addEffect(hp, target.x, target.y - target.hitHeight / 2);

						if (target.data.currenthp <= 0)
						{
							target.data.currenthp=0;
						}
					}
					target.onHPChange.dispatch(target);

					underAttackCmd=new UnderAttackCommand(target);
					underAttackCmd.command=command;
					target.command.addCommand(underAttackCmd);
					next();
				}
				target.updateBuff(battleT.buffid);
			}
		}

		private function next(obj:Object=null):void
		{
			_hero.onNextOne.dispatch(_hero);
		}

		override public function execute():void
		{
			_hero.playAttackAnimation();
			_hero.onAnimationComplete(onCompleteHdr);
			_hero.addFrameCallback(hurtCallback);
		}
	}
}
