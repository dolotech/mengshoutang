package game.view.strategy
{
	import feathers.controls.Scroller;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.TiledRowsLayout;

	import game.data.StrategyData;
	import game.view.viewBase.StrategyDlgBase;

	import starling.events.Event;

	/**
	 * 攻略界面引导
	 * @author hyy
	 *
	 */
	public class StrategyDlg extends StrategyDlgBase
	{
		public function StrategyDlg()
		{
			super();
		}

		override protected function init() : void
		{
			enableTween = true;
			_closeButton = btn_close;
			isVisible = false;
			const listLayout : TiledColumnsLayout = new TiledColumnsLayout();
			listLayout.gap = 7;
			listLayout.useSquareTiles = false;
			listLayout.useVirtualLayout = true;
			listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			list_btn.layout = listLayout;
			list_btn.paddingLeft = 0;
			list_btn.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			list_btn.itemRendererFactory = itemRendererFactory;

			function itemRendererFactory() : IListItemRenderer
			{
				const renderer : StrategyRender = new StrategyRender();
				renderer.setSize(223, 292);
				return renderer;
			}
			setToCenter();
			//点击关闭界面
			clickBackroundClose();
		}

		override protected function addListenerHandler() : void
		{
			super.addListenerHandler();
			this.addViewListener(tabMenu, Event.CHANGE, onTabMenuClick);
		}

		override protected function openTweenComplete():void
		{
			tabMenu.selectedIndex = 0;
		}

		private function onTabMenuClick(evt : Event) : void
		{
			var list : Array = StrategyData.list[tabMenu.selectedIndex + 1];

			if (list)
				list_btn.dataProvider = new ListCollection(list);
		}
	}
}