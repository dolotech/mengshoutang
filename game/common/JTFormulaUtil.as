package game.common
{
	import game.data.JTPVPRuleData;
	import game.data.JTPvpNewRuleData;
	import game.view.uitils.FunManager;

	/**
	 * 公式
	 * @author CabbageWrom
	 *
	 */
	public class JTFormulaUtil
	{
		/**
		 *
		 * @param value
		 * @param level
		 * @return
		 *
		 */
		public static function getUpProperty(value : int, level : int) : int
		{
			var property : int = Math.floor(value + value * level / 25);
			return property;
		}

		/**
		 * 获取下一级净化的值
		 * @param baseValue  基础值
		 * @param curArg  现在变化值
		 * @param nextArg 下星变化值
		 * @return 返回下一级的值
		 *
		 */
		public static function getNextPurgeDeff(baseValue : int, curArg : Number, nextArg : Number) : int
		{
			var property : int = Math.ceil(baseValue / curArg * nextArg);
			return property;
		}

		/**
		 *
		 * @param value 基础属性
		 * @param cValue 当前星级加成
		 * @param nValue 下一星级加成
		 * @return 返回属性
		 *
		 */
		public static function getNextStarDeff(baseValue : int, cValue : Number) : int
		{
			var property : int = Math.ceil(baseValue * cValue / 100);
			return property;
		}


		/**
		 *获取排行榜荣誉值
		 * @param level
		 * @param rank
		 * @return
		 *
		 */
		public static function getRankHonor(rank : int) : int
		{
			var honor : int = 0;
			var level : int = 6;
			var list : * = JTPvpNewRuleData.hash.values();
			var len : int = list.length;
			var render : JTPvpNewRuleData;

			for (var i : int = 0; i < len; i++)
			{
				render = list[i];

				if (rank <= render.rank)
				{
					level = i + 1;
					break;
				}
			}
			var data : JTPVPRuleData = JTPVPRuleData.hash.getValue(level);
			return data.exp;
		}
	}
}
