package game.view.goodsGuide.view
{
	import com.view.base.event.EventType;
	import com.view.base.event.ViewDispatcher;
	
	import game.data.Goods;
	import game.data.WidgetData;
	import game.manager.AssetMgr;
	import game.view.uitils.Res;
	import game.view.viewBase.GoodsGuideGridBase;

	public class GoodsGuideGrid extends GoodsGuideGridBase
	{
		public function GoodsGuideGrid()
		{
			super();
		}

		override public function set data(value : Object) : void
		{
			super.data = value;

			if (value == null)
				return;
			var goods : Goods = value as Goods;
			var hasCount : int = WidgetData.pileByType(goods.type);
			txt_name.text = hasCount + "/" + goods.need_FusionCount;
			txt_name.color = hasCount >= goods.need_FusionCount ? 0x00ff00 : 0xff0000;
			ico_quality.texture = Res.instance.getQualityPhoto(goods.quality);
			ico_equip.upState = AssetMgr.instance.getTexture(goods.picture);
		}

		override public function set isSelected(value : Boolean) : void
		{
			value && ViewDispatcher.dispatch(EventType.SELECTED_GOODS_GUIDE, this);
		}
	
	}
}