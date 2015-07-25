package game.view.blacksmith.render
{
	import com.dialog.DialogMgr;
	import com.langue.Langue;
	import com.view.base.event.EventType;
	import com.view.base.event.ViewDispatcher;

	import game.data.ForgeData;
	import game.data.Goods;
	import game.data.WidgetData;
	import game.manager.AssetMgr;
	import game.view.blacksmith.BlacksmithDlg;
	import game.view.goodsGuide.GetBestEquipDlg;
	import game.view.viewBase.NewEquipRenderBase;

	public class NewEquipRender extends NewEquipRenderBase
	{
		private var canSelect:Boolean;

		public function NewEquipRender(canSelect:Boolean=false)
		{
			this.canSelect=canSelect;
			super();
		}

		override public function set data(value:Object):void
		{
			super.data=value;
			var goods:Goods=value as Goods;
			txt_needLevel.text="";

			if (value && goods == null && value.data == Langue.getLangue("get_goods"))
				txt_get.text=Langue.getLangue("get_goods");
			else
				txt_get.text="";

			if (goods == null || goods.type == 0)
			{
				txt_count.text="";
				txt_name.text="";
//                tag_countbg.visible = false;
				tag_isEquip.visible=false;
				ico_equip.visible=false;
				tag_fusion.visible=false;
				selectedTagStatus=false;
				tag_bg.upState=tag_bg.downState=AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang0");
				return;
			}

			//装备
			var widgetData:WidgetData=value as WidgetData;
			tag_isEquip.visible=widgetData ? widgetData.equip != 0 : false;
			//合成
			var forgeData:ForgeData=value as ForgeData;
			tag_fusion.visible=forgeData ? forgeData.isCanForge : false;

			//装备
			if (goods.tab == 5 && widgetData)
			{
				//强化等级
				txt_count.color=0xffffff;
				txt_count.text=(widgetData.level > 0 ? "+" + widgetData.level : "");
//				tag_countbg.visible=widgetData.level > 0;

				if (BlacksmithDlg.curr_hero && BlacksmithDlg.curr_hero.level < widgetData.limitLevel)
					txt_needLevel.text="lv:" + widgetData.limitLevel;
			}
			//合成，装备
			else if (goods.tab == 5 && forgeData)
			{
				txt_count.text="";
//				tag_countbg.visible=false;
			}
			//道具
			else if (goods.need_FusionCount == 0)
			{

				if (goods.tab == 2 && goods.sort == 4)
				{
					txt_count.text="Lv " + goods.level;
					txt_count.color=goods.level > 0 ? 0x00ff00 : 0xff0000;
//					tag_countbg.visible=true;
				}
				else
				{
					txt_count.text="x " + goods.pile;
					txt_count.color=goods.pile > 0 ? 0x00ff00 : 0xff0000;
//					tag_countbg.visible=true;
				}
			}
			//合成 道具
			else
			{
				txt_count.text=goods.pile + "/" + goods.need_FusionCount;
				txt_count.color=goods.pile >= goods.need_FusionCount ? 0x00ff00 : 0xff0000;
//				tag_countbg.visible=goods.need_FusionCount > 0;
			}
			txt_name.text=goods.name;

			//装备图标
			if (goods.picture)
				ico_equip.texture=AssetMgr.instance.getTexture(goods.picture);
			ico_equip.visible=goods.picture != null;
			//装备品质
			tag_bg.upState=tag_bg.downState=AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (goods.quality > 0 ? (goods.quality - 1) : 0));
			selectedTagStatus=false;
		}

		override public function set isSelected(value:Boolean):void
		{
			if ((owner && owner.isScrolling) || data == null)
				return;
			selectedTagStatus=value;
			value && onSelectedHanlder();
			super.isSelected=value;
		}

		public function set selectedTagStatus(value:Boolean):void
		{
			if (txt_get.text != "")
				value=false;
			tag_selected.visible=canSelect && value;
		}

		private function onSelectedHanlder():void
		{
			//获得最好的物品
			if (data && !(data is Goods) && data.data == Langue.getLangue("get_goods"))
			{
				DialogMgr.instance.open(GetBestEquipDlg, [data]);
				return;
			}

			if (data && data.type > 0)
				ViewDispatcher.dispatch(EventType.UPDATE_BAGEQUIP_SELECTED, data);
		}
	}
}
