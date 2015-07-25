package game.view.arena
{
	import com.langue.Langue;
	
	import game.data.Goods;
	import game.net.message.GoodsMessage;
	import game.view.goodsGuide.EquipInfoDlg;

	public class ConvertPropsDlg extends EquipInfoDlg
	{
		public function ConvertPropsDlg()
		{
			super();
		}

		override protected function show() : void
		{
			var goods : Goods = _parameter.goods as Goods;
			view_goodsInfo.btn_Swallow.visible = false
			view_goodsInfo.data = goods;
			view_goodsInfo.btn_ok.text = Langue.getLans("arenaMenuText")[1] + _parameter.price;
		}

		override protected function onChangeForgeViewHandler() : void
		{
			var goods : Goods = _parameter.goods as Goods;
			GoodsMessage.onSendBuyPvpEquip(goods.type);
		}
	}
}