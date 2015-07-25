package game.view.goodsGuide.view
{
	import com.utils.Constants;

	import feathers.controls.Scroller;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;

	import game.view.goodsGuide.render.GoodsGuideListRender;
	import game.view.viewBase.GoodsGuideListBase;

	import starling.animation.Transitions;

	/**
	 * 物品列表引导
	 * @author hyy
	 *
	 */
	public class GoodsGuideList extends GoodsGuideListBase
	{
		public var list : Array;
		public var index : int = 0;

		public function GoodsGuideList()
		{
			super();
		}

		override protected function init() : void
		{
			this.enableTween = true;
			const listLayout : TiledRowsLayout = new TiledRowsLayout();
			listLayout.useSquareTiles = false;
			listLayout.useVirtualLayout = true;
			listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			listLayout.paddingLeft = 6;
			listLayout.paddingTop = 4;
			list_equip.layout = listLayout;
			list_equip.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			list_equip.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			list_equip.itemRendererFactory = itemRendererFactory;

			function itemRendererFactory() : IListItemRenderer
			{
				const renderer : GoodsGuideListRender = new GoodsGuideListRender();
				renderer.setSize(330, 110);
				return renderer;
			}
			transition = Transitions.EASE_OUT;
		}

		override protected function openTweenComplete() : void
		{
			list_equip.dataProvider = new ListCollection(list);
			list_equip.selectedIndex = index;
		}


		/**
		 * 放到屏幕中间
		 * @param _arg1
		 */
		override public function setToCenter(x : int = 0, y : int = 0) : void
		{
			this.x = (Constants.virtualWidth - this.width) * .5;
			this.y = (Constants.virtualHeight - this.height) * .5;
		}
	}
}