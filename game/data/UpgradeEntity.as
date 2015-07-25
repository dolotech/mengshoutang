package game.data
{
	import game.common.JTGlobalDef;
	import game.fight.LevelupBehavior;
	import game.hero.Hero;
	import game.manager.BattleHeroMgr;
	import game.manager.HeroDataMgr;
	import game.managers.JTFunctionManager;
	import game.net.data.IData;
	import game.net.data.s.SBattle;
	import game.net.data.vo.UpgradeVo;

	import starling.core.Starling;

	public class UpgradeEntity
	{
		public var resName : String;
		public var sBattle : SBattle;
		public var next : int;
		private var _upgrade : Vector.<IData>;

		public function UpgradeEntity(sBattle : SBattle)
		{
			this.sBattle = sBattle;
			_upgrade = sBattle ? sBattle.upgrade : new Vector.<IData>();
		}

		public function upgrade(callback : Function) : void
		{
			var delay : Number = 0;
			var l : int = _upgrade.length;
			var i : int = 0;
			var isUpdateLevel : Boolean = false;

			for (i = 0; i < l; i++)
			{
				var vo : UpgradeVo = _upgrade[i] as UpgradeVo;
				var hero : HeroData = HeroDataMgr.instance.battleHeros.getValue(vo.id);
				var level : int = vo.level - hero.level;
				var expData : ExpData = ExpData.hash.getValue(vo.level) as ExpData;
				var exp : int;

				if (level > 0)
				{
					isUpdateLevel = true;
					exp = (vo.exp + expData.exp) - hero.exp;
				}
				else
				{
					exp = vo.exp - hero.exp;
				}

				var heroData : HeroData = hero.sourceHero;
				var data : Object = {};
				data.id = hero.sourceHero.id;
				data.level = vo.level;
				JTFunctionManager.executeFunction(JTGlobalDef.UPDATA_LEVEL_HEROS, data);
				heroData.exp = vo.exp;
				heroData.level = vo.level;

				if (exp > 0)
				{
					var viewHero : Hero = BattleHeroMgr.instance.hash.getValue(hero.seat);
					var levelup : LevelupBehavior = new LevelupBehavior(viewHero, viewHero.data, level, exp);
				}
			}

			if (isUpdateLevel)
				delay = 2.5;
			else if (exp > 0)
				delay = 1;
			Starling.juggler.delayCall(callback, delay);
		}
	}
}