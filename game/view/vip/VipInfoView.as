package game.view.vip
{
	import feathers.controls.Scroller;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.TiledRowsLayout;

	import game.data.VipData;
	import game.manager.GameMgr;
	import game.view.viewBase.VipInfoViewBase;

	import starling.events.Event;

	/**
	 * vip等级详细信息
	 * @author hyy
	 *
	 */
	public class VipInfoView extends VipInfoViewBase
	{
		public function VipInfoView()
		{
			super();
		}

		override protected function init() : void
		{
			btn_left.scaleX = -1;
			const listLayout : TiledColumnsLayout = new TiledColumnsLayout();
			listLayout.useSquareTiles = false;
			listLayout.useVirtualLayout = true;
			listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			listLayout.paging = TiledColumnsLayout.PAGING_HORIZONTAL; //自动排列
			list_vip.layout = listLayout;
			list_vip.snapToPages = true;
			list_vip.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			list_vip.itemRendererFactory = itemRendererFactory;

			function itemRendererFactory() : IListItemRenderer
			{
				const renderer : VipRender = new VipRender();
				renderer.setSize(658, 246);
				return renderer;
			}
			list_vip.dataProvider = new ListCollection(VipData.list);
			list_vip.scrollToPageIndex(GameMgr.instance.vip, -1, 0);
			delayCall(updatePageStatus, 0.1);
		}

		override protected function addListenerHandler() : void
		{
			addViewListener(btn_left, Event.TRIGGERED, onLeftClick);
			addViewListener(btn_right, Event.TRIGGERED, onRightClick);
		}

		/**
		 * 上一页
		 *
		 */
		private function onLeftClick() : void
		{
			if (list_vip.isScrolling)
				return;
			list_vip.throwToPage(list_vip.horizontalPageIndex - 1 < 0 ? 0 : list_vip.horizontalPageIndex - 1, -1, 0.3);
			updatePageStatus();
		}


		/**
		 * 下一页
		 *
		 */
		private function onRightClick() : void
		{
			if (list_vip.isScrolling)
				return;
			list_vip.throwToPage(list_vip.horizontalPageIndex + 1 >= list_vip.horizontalPageCount ? list_vip.horizontalPageIndex : list_vip.horizontalPageIndex + 1, -1, 0.3);
			updatePageStatus();
		}

		private function updatePageStatus() : void
		{
			btn_left.disable = list_vip.horizontalPageIndex == 0;
			btn_right.disable = list_vip.horizontalPageIndex + 1 == list_vip.horizontalPageCount;
		}
	}
}