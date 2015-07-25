package game.hero.command
{
	import com.dialog.DialogMgr;
	import com.scene.SceneMgr;

	import game.data.RoleShow;
	import game.fight.DropHPNumber;
	import game.hero.AnimationCreator;
	import game.hero.Hero;
	import game.manager.BattleAssets;
	import game.manager.BattleHeroMgr;
	import game.net.data.IData;
	import game.net.data.vo.BattleTarget;
	import game.scene.BattleScene;

	import treefortress.spriter.SpriterClip;

	/**
	 * 非技能时，目标对象为队友，即为加血，仅且目标只有一个队友
	 * 单体治疗
	 * @author Administrator
	 *
	 */
	public class TreatCommand extends Command
	{
		public function TreatCommand(executor:Hero)
		{
			super(executor);
		}

		override public function execute():void
		{
			_hero.playAttackAnimation();
			_hero.onAnimationComplete(onCompleteHdr);
			_hero.addFrameCallback(hurtCallback);
		}

		private function onCompleteHdr(sp:SpriterClip):void
		{
			onComplete.dispatch(this);
		}

		private var treatEffect:SpriterClip;

		private function hurtCallback():void
		{
			var battleTarget:Vector.<IData>=command.targets;
			var len:int=battleTarget.length;
			for (var i:int=0; i < len; i++)
			{
				var battleT:BattleTarget=battleTarget[i] as BattleTarget;
				var target:Hero=BattleHeroMgr.instance.hash.getValue(battleT.id) as Hero;

				var sponsorRole:RoleShow=RoleShow.hash.getValue(_hero.data.show);
				var effectStr:String=sponsorRole.underAttackEffect;
				treatEffect=AnimationCreator.instance.create(effectStr, BattleAssets.instance, true);
				target.addChild(treatEffect);
				treatEffect.y=-_hero.hitHeight / 2
				treatEffect.play(effectStr);

				// 扣血文字
				var power:int=battleT.hp - target.data.currenthp;
				DialogMgr.instance.closeAllDialog();
				var scene:BattleScene=SceneMgr.instance.getCurScene() as BattleScene;
				var hp:DropHPNumber=new DropHPNumber("+" + power, battleT, 0x00FF00);
				scene.addEffect(hp, target.x, target.y - target.height / 2);

				target.data.currenthp=battleT.hp;
				target.onHPChange.dispatch(target);
			}
			_hero.onNextOne.dispatch(_hero);
		}
	}
}
