package game.view.vip
{
	import com.view.base.event.EventType;
	
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.TiledRowsLayout;
	
	import game.data.VipData;
	import game.manager.GameMgr;
	import game.net.message.RoleInfomationMessage;
	import game.view.viewBase.VipRewardDlgBase;
	
	import starling.events.Event;

	/**
	 * vip特权礼包
	 * @author hyy
	 *
	 */
	public class VipRewardDlg extends VipRewardDlgBase
	{
		public function VipRewardDlg()
		{
			super();
		}

		override protected function init() : void
		{
			enableTween=true;
			_closeButton = btn_close;
			clickBackroundClose();
			const listLayout : TiledColumnsLayout = new TiledColumnsLayout();
			listLayout.useSquareTiles = false;
			listLayout.useVirtualLayout = true;
			listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			list_reward.layout = listLayout;
			list_reward.itemRendererFactory = itemRendererFactory;

			function itemRendererFactory() : IListItemRenderer
			{
				const renderer : VipRewardRender = new VipRewardRender();
				renderer.setSize(124, 158);
				return renderer;
			}

			for (var i : int = 1; i <= 5; i++)
			{
				this["tab_" + i].text = getLangue("vip_reward") + i;
			}
		}

		override protected function addListenerHandler() : void
		{
			super.addListenerHandler();
			addViewListener(tabMenu_hero, Event.CHANGE, onTabMenuSelected);
			addViewListener(btn_get, Event.TRIGGERED, onClick);
			addContextListener(EventType.UPDATE_VIP, updateVip);
		}

		override protected function show() : void
		{
			setToCenter();
			updateVip(null, GameMgr.instance.vipData);
			//自动选择玩家可以领取的礼包
			var selectedIndex : int = GameMgr.instance.vipData.baseVip.dayPrize - 1;
			selectedIndex = selectedIndex < 0 ? 0 : selectedIndex;
			tabMenu_hero.selectedIndex = selectedIndex;
		}

		/**
		 * 更新VIP等级
		 * @param vipLevel
		 *
		 */
		private function updateVip(evt : Event, vipData : VipData) : void
		{
			var isGet : Boolean = vipData.dayPrize > 0;

			if (vipData.baseVip.dayPrize != (tabMenu_hero.selectedIndex + 1))
				isGet = true;
			btn_get.disable = isGet;
		}

		/**
		 * tab选择
		 * @param evt
		 *
		 */
		private function onTabMenuSelected(evt : Event) : void
		{
			var list_goods : Array = VipData.list_dayReward[tabMenu_hero.selectedIndex + 1];
			list_reward.dataProvider = new ListCollection(list_goods);
			updateVip(null, GameMgr.instance.vipData);
		}

		/**
		 * 领取奖励
		 *
		 */
		private function onClick() : void
		{
			RoleInfomationMessage.sendGetVipReward();
		}
	}
}