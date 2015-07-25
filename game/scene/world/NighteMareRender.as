package game.scene.world
{
	import com.langue.Langue;

	import game.data.Goods;
	import game.data.WidgetData;
	import game.view.uitils.Res;
	import game.view.viewBase.NighteMareRenderBase;

	public class NighteMareRender extends NighteMareRenderBase
	{
		public function NighteMareRender()
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
			txt_tag.text = Langue.getLangue(hasCount >= goods.pile ? "nightmare_ok" : "nightmare_ko");
			icon.texture = Res.instance.getGoodsPhoto(goods.type);
			txt_name.text = goods.name;
			txt_count.text = hasCount + "";
			txt_count.color = hasCount >= goods.pile ? 0xffffff : 0xff0000;
			txt_needCount.text = "/" + goods.pile;
		}
	}
}