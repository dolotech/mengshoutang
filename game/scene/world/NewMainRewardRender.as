package game.scene.world
{
	import com.dialog.DialogMgr;

	import game.data.Goods;
	import game.view.blacksmith.render.NewEquipRender;
	import game.view.goodsGuide.EquipInfoDlg;

	public class NewMainRewardRender extends NewEquipRender
	{
		public function NewMainRewardRender()
		{
			super();
		}

		override public function set data(value:Object):void
		{
			super.data=value;
//          tag_countbg.visible = false;
			txt_count.visible=false;
		}

		override public function set isSelected(value:Boolean):void
		{
			if (value)
			{
				var goods:Goods=data as Goods;
				goods=goods.clone() as Goods;
				goods.Price=0;
				DialogMgr.instance.open(EquipInfoDlg, goods);
			}
		}
	}
}
