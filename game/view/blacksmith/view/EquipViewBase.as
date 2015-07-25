package game.view.blacksmith.view
{
	import com.view.View;

	import game.data.Goods;
	import game.data.WidgetData;

	/**
	 * 铁匠铺几个界面的基类
	 * @author hyy
	 *
	 */
	public class EquipViewBase extends View
	{
		public var m_updateCostMoney : Function;

		public function EquipViewBase(isAutoInit : Boolean = true)
		{
			super(isAutoInit);
		}

		override protected function show() : void
		{
			resetView();
		}

		/**
		 * 重置界面
		 *
		 */
		public function resetView() : void
		{

		}

		public function set data(goods : Goods) : void
		{

		}

		public function getEquipList(curr_goods : Goods) : Array
		{
			return null;
		}

		/**
		 * 玩家装备设置
		 * @param goods
		 *
		 */
		public function set curr_widget(goods : WidgetData) : void
		{

		}

		public function updateCostMoney(money : int, diamond : int) : void
		{
			if (m_updateCostMoney != null)
				m_updateCostMoney(money, diamond);
		}

		override public function dispose() : void
		{
			super.dispose();
			m_updateCostMoney = null;
		}
	}
}