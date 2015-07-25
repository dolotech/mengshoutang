package game.view.gameover
{
	import game.common.JTGlobalDef;
	import game.data.ExpData;
	import game.data.HeroData;
	import game.hero.AnimationCreator;
	import game.manager.AssetMgr;
	import game.manager.GameMgr;
	import game.manager.HeroDataMgr;
	import game.managers.JTFunctionManager;
	import game.net.data.vo.UpgradeVo;
	import game.view.heroHall.render.HeroIconRender;
	import game.view.viewBase.WinHeroIcoRenderBase;

	import starling.core.Starling;

	import treefortress.spriter.SpriterClip;

	public class WinHeroIcoRender extends WinHeroIcoRenderBase
	{
		private var animation:SpriterClip;
		private var ico:HeroIconRender;

		public function WinHeroIcoRender()
		{
			super();
			ico=new HeroIconRender();
			addQuiackChild(ico);
			ico.touchable=false;
			ico.x=5;
		}

		override public function set data(value:Object):void
		{
			super.data=value;
			var vo:UpgradeVo=value as UpgradeVo;

			if (vo == null)
				return;
			var heroData:HeroData=HeroDataMgr.instance.battleHeros.getValue(vo.id);
			heroData=HeroDataMgr.instance.hash.getValue(heroData.sourceHero.id);
			var isUpgrade:Boolean=vo.level != heroData.level;
			var currData:ExpData=ExpData.hash.getValue(heroData.level) as ExpData;
			var nextData:ExpData=ExpData.hash.getValue(vo.level) as ExpData;
			exp.width=96 * getPercentage(heroData.exp, currData.exp);
			ico.data=heroData;
			ico.tag_battle.visible=false;
			heroData.level=vo.level;
			heroData.exp=vo.exp;
			exp.width=0;
			Starling.juggler.delayCall(showExp, 0.5);

			//更新玩家升级后的数值
			if (isUpgrade)
			{
				var data:Object={};
				data.id=heroData.id;
				data.level=vo.level;
				JTFunctionManager.executeFunction(JTGlobalDef.UPDATA_LEVEL_HEROS, data);
			}

			function showExp():void
			{
				if (GameMgr.instance.tollgateData)
					txt_exp.text=ExpData.hash.getValue(vo.level + 1) ? "Exp +" + GameMgr.instance.tollgateData.exp : "Max";
				else
					txt_exp.text="0";

				Starling.juggler.tween(exp, isUpgrade ? 0.3 : 0.6, {delay: 0.3, width: isUpgrade ? 96 : 96 * getPercentage(heroData.exp, nextData.exp), onComplete: onComplete});
			}

			function onComplete():void
			{
				if (isUpgrade)
				{
					exp.width=0;
					ico.data=heroData;
					ico.tag_battle.visible=false;
					Starling.juggler.tween(exp, 0.5, {width: 91 * getPercentage(heroData.exp, nextData.exp)});
				}
				showUpdateAnimaion();
			}

			function showUpdateAnimaion():void
			{
				if (isUpgrade)
				{
					animation=AnimationCreator.instance.create("effect_shengjixiaoguo", AssetMgr.instance);
					animation.play("effect_shengjixiaoguo");
					animation.animation.looping=false;
					addChild(animation);
					Starling.juggler.add(animation);
				}
			}
		}

		private function getPercentage(exp:int, max_exp:int):Number
		{
			var percentage:Number=exp / max_exp;
			if (percentage > 1 || percentage < 0)
				percentage=1;
			return percentage;
		}

		override public function dispose():void
		{
			super.dispose();
			animation && animation.removeFromParent(true);
		}
	}
}
