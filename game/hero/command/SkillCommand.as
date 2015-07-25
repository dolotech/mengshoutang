package game.hero.command
{
	import com.dialog.DialogMgr;
	import com.scene.SceneMgr;
	import com.scene.ShakeScreen;
	import com.sound.SoundManager;
	import com.utils.Delegate;

	import flash.geom.Point;

	import game.data.EffectSoundData;
	import game.data.HeroData;
	import game.data.SkillData;
	import game.data.Val;
	import game.fight.BaojiAnimation;
	import game.fight.DropHPNumber;
	import game.fight.Position;
	import game.fight.ShanBiAnimation;
	import game.hero.AnimationCreator;
	import game.hero.Hero;
	import game.manager.BattleAssets;
	import game.manager.BattleHeroMgr;
	import game.net.data.IData;
	import game.net.data.vo.BattleTarget;
	import game.net.data.vo.BattleVo;
	import game.scene.BattleScene;

	import treefortress.spriter.SpriterClip;

	/**
	 *     技能施放
	 * @author Administrator
	 */
	public class SkillCommand extends Command
	{
		public function SkillCommand(executor:Hero)
		{
			super(executor);
		}

		override public function execute():void
		{
			_hero.onAnimationComplete(completeHdr);
			_hero.playSkillAnimation(); //播放攻击动画

			hurtCallback();
		}

		private function completeHdr(sp:SpriterClip):void
		{
			onComplete.dispatch(this);
		}

		private function hurtCallback():void
		{
			var battleTarget:Vector.<IData>=command.targets;
			var skillData:SkillData=SkillData.getSkill(command.skill);
			_hero.updateBuff(command.buffid);
			/*1：角色中间
			2：角色脚底
			3：阵型中间
			4：当前排中间
			5：当前列第一个位置
			6：角色头顶

			如果是范围攻击，则位置只为3,4,5*/
			if (skillData.skillEffectPosition == 3 || skillData.skillEffectPosition == 4 || skillData.skillEffectPosition == 5)
			{
				// sort用于纵向技能
				battleTarget.sort(sort);
				function sort(a:BattleTarget, b:BattleTarget):Number {
					if (a.id < b.id) {
						return -1;
					} else {
						return 1;
					}
				}
				var skillEffect:SpriterClip=AnimationCreator.instance.create(skillData.skillEffect, BattleAssets.instance,
					true);
				skillEffect.play(skillData.skillEffect);
				skillEffect.addCallback(skillcb, skillData.callbackFrame);

				playSound(skillData);
				DialogMgr.instance.closeAllDialog();
				var scene:BattleScene=SceneMgr.instance.getCurScene() as BattleScene;


				var battle:BattleTarget=battleTarget[0] as BattleTarget;
				var point:Point;
				switch (skillData.skillEffectPosition)
				{
					case 3:
						point=Position.instance.getPoint((battle.id / 10 >> 0) * 10 + 5);
						break;
					case 4: // 行
						var mul:int=(battle.id % 10) / 3 >> 0;
						mul=mul > 2 ? 2 : mul;
						point=Position.instance.getPoint((battle.id / 10 >> 0) * 10 + 2 + (mul * 3));
						break;
					case 5: // 列
						point=Position.instance.getPoint(battle.id);
						break;
					default:
						break;
				}
				skillEffect.scaleX=_hero.data.team == HeroData.BLUE ? 1 : -1;
				scene.addEffect(skillEffect, point.x, point.y - _hero.hitHeight / 2);
			}
			else
			{
				var len:int=battleTarget.length;
				for (var i:int=0; i < len; i++)
				{
					var battleT:BattleTarget=battleTarget[i] as BattleTarget;
					var target:Hero=BattleHeroMgr.instance.hash.getValue(battleT.id) as Hero;

					switch (skillData.skillEffectPosition)
					{
						case 1:
						case 2:
						case 6:
							target.skillEffectCallback.addOnce(Delegate.createFunction(skillCallback, command, battleT));
							target.addEffect(skillData);
							break;
						default:
							break;
					}
				}
			}
		}

		private function playSound(skillData:SkillData):void
		{
			var sound:EffectSoundData=EffectSoundData.hash.getValue(skillData.skillEffect);
			if (sound && sound.name)
			{
				SoundManager.instance.playSound(sound.sound);
			}
		}

		private function skillcb():void
		{
			var battleTarget:Vector.<IData>=command.targets;
			var len:int=battleTarget.length;
			for (var i:int=0; i < len; i++)
			{
				var battleT:BattleTarget=battleTarget[i] as BattleTarget;
				var target:Hero=BattleHeroMgr.instance.hash.getValue(battleT.id) as Hero;
				skillCallback(target, command, battleT);
			}
		}

		private function next(obj:Object=null):void
		{
			if (_bool)
				return;
			_bool=true;
			_hero.onNextOne.dispatch(_hero);
		}
		private var _bool:Boolean;

		private function skillCallback(target:Hero, command:BattleVo, battleT:BattleTarget):void
		{
			var state:int=battleT.state;
			// 治疗，加BUF,复活不播放受击动画
			/*
			# 被实施者状态:
			#  &1   - 暴击
			#  &2   - 闪避
			#  &4   - 复活
			#  &8   - 治疗
			*/
			//		闪避
			if (state & Val.SB)
			{
				var scene:BattleScene=SceneMgr.instance.getCurScene() as BattleScene;
				var s:ShanBiAnimation=new ShanBiAnimation();
				scene.addEffect(s, target.x, target.y - target.height / 2);
			}
			else
			{
				target.updateBuff(battleT.buffid);
				DialogMgr.instance.closeAllDialog();
				scene=SceneMgr.instance.getCurScene() as BattleScene;
				var hp:DropHPNumber;
				var power:int;
				var underAttackCmd:UnderAttackCommand; // 受击音效
				if (battleT.state & Val.FH)
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
				else if (battleT.state & Val.ZL)
				{
					// 加血文字
					power=battleT.hp - target.data.currenthp;
					var sum:String=power < 0 ? "-" : "+";
					if (power < 0)
						power=Math.abs(power);
					var color:uint=(sum == "-") ? 0xff0000 : 0x00ff00;

					scene=SceneMgr.instance.getCurScene() as BattleScene;
					hp=new DropHPNumber(sum + power, battleT, color);
					scene.addEffect(hp, target.x, target.y - target.height / 2);
					target.data.currenthp=battleT.hp;
					target.onHPChange.dispatch(target);
				}
				else
				{
					if (_hero.data.team != target.data.team)
					{
						power=target.data.currenthp - battleT.hp;
						target.data.currenthp=battleT.hp;

						//暴击
						if (state & Val.BJ)
						{
							var shakeEffect:ShakeScreen=new ShakeScreen(scene, 0.2);
							shakeEffect.start();
							SoundManager.instance.playSound("baoji");
//                          target.addAnimation(new AttackName(Langue.getLans("ENCHANTING_TYPE")[6],0,-target.hitHeight),0,0);
							var baojiAnimation:BaojiAnimation=new BaojiAnimation();
							scene.addEffect(baojiAnimation, target.x, target.y - target.height / 2);
						}
						else
						{
//                            SoundManager.instance.playSound("underattack");
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
						underAttackCmd=new UnderAttackCommand(target);
						underAttackCmd.command=command;
						target.command.addCommand(underAttackCmd);
						target.onHPChange.dispatch(target);
					}
				}
			}
			if (!(battleT.state & Val.FH))
			{
				next();
			}
		}
	}
}
