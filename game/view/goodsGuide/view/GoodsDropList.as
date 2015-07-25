package game.view.goodsGuide.view
{
	import com.utils.Constants;
	
	import feathers.controls.Scroller;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	
	import game.data.Goods;
	import game.view.goodsGuide.render.GoodsDropGuideRender;
	import game.view.viewBase.GoodsGuideListBase;

	/**
	 * 掉落列表
	 * @author hyy
	 *
	 */
	public class GoodsDropList extends GoodsGuideListBase
	{
		public function GoodsDropList()
		{
			super();
		}

		override protected function init() : void
		{
			const listdropLayout : TiledRowsLayout = new TiledRowsLayout();
			listdropLayout.useSquareTiles = false;
			listdropLayout.useVirtualLayout = true;
			listdropLayout.tileVerticalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
			listdropLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			listdropLayout.paddingTop = 10;
			list_equip.layout = listdropLayout;
			list_equip.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			list_equip.itemRendererFactory = itemDropRendererFactory;

			function itemDropRendererFactory() : IListItemRenderer
			{
				const renderer : GoodsDropGuideRender = new GoodsDropGuideRender();
				renderer.setSize(286, 102);
				return renderer;
			}
		}

		public function set data(goods : Goods) : void
		{
			list_equip.dataProvider = new ListCollection(goods.getDropLocationList());
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