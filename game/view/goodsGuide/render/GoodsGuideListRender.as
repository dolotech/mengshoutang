package game.view.goodsGuide.render
{
    import com.langue.Langue;
    import com.view.base.event.EventType;
    import com.view.base.event.ViewDispatcher;

    import game.data.ForgeData;
    import game.data.Goods;
    import game.data.Val;
    import game.data.WidgetData;
    import game.manager.AssetMgr;
    import game.view.goodsGuide.GoodsEquipOrForgeDlg;
    import game.view.uitils.Res;
    import game.view.viewBase.GoodsGuideListRenderBase;

    import starling.filters.ColorMatrixFilter;

    public class GoodsGuideListRender extends GoodsGuideListRenderBase
    {
        public var isDrak:Boolean=true;

        public function GoodsGuideListRender()
        {
            super();
            tag_selected.visible=false;
        }

        override public function set data(value:Object):void
        {
            super.data=value;

            if (value == null)
                return;
            var goods:Goods=value as Goods;
            txt_name.text=goods.name;
            txt_part.text=Langue.getLans("Equip_type")[goods.sort - 1];
            var drop_type:String;
            var forgeData:ForgeData=ForgeData.hash.getValue(goods.type);

            if (forgeData)
                drop_type="forgeGoods";
            else if (goods.drop_location == Val.DROP_PVP || goods.drop_location == Val.DROP_PVP_GET)
                drop_type="pvp";
            else if (goods.drop_location)
            {
                var isFb:Boolean;
                var tmpArr:Array=goods.drop_location.split(",");

                for (var i:int=0, len:int=tmpArr.length; i < len; i++)
                {
                    if (int(tmpArr[i]) > 1000)
                        isFb=true;
                }
                drop_type=isFb ? "fb" : "mainLine";
            }
            else
                drop_type="system";

            txt_drop.text=Langue.getLangue(drop_type);

            if (goods.limitLevel > 0)
                txt_level.text=goods.limitLevel + Langue.getLangue("level");
            ico_equip.upState=AssetMgr.instance.getTexture(goods.picture);

            if (!goods.isPack && goods.name == "金币" || goods.name == "钻石")
            {
                ico_quality.texture=AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang0");
            }
            else
            {
                ico_quality.texture=Res.instance.getQualityPhoto(goods.quality);
            }
            ico_equip.x=ico_quality.x + ((ico_quality.width - ico_equip.width) >> 1);
            ico_equip.y=ico_quality.y + ((ico_quality.height - ico_equip.height) >> 1);

            if (GoodsEquipOrForgeDlg.curr_hero)
            {
                txt_level.color=GoodsEquipOrForgeDlg.curr_hero.level >= goods.limitLevel ? 0x00ff00 : 0xff0000;
                var curr_equip:WidgetData=WidgetData.hash.getValue(GoodsEquipOrForgeDlg.curr_hero.seat5);

                if (curr_equip && curr_equip.type == goods.type)
                {
                    ico_quality.visible=true;
                    filter=null;
                }
                else if (isDrak && WidgetData.getCanEquipWidgetByType(goods.type) == null)
                {
                    ico_quality.visible=false;
                    filter=new ColorMatrixFilter(Val.filter);
                }
                else
                {
                    filter=null;
                }
            }

            if (goods is WidgetData && goods.tab == 5)
                txt_strengthen.text=goods.level > 0 ? "+" + goods.level : "";
            else
                txt_strengthen.text="";
            txt_des1.visible=txt_part.visible=goods.tab == 5;
        }

        override public function set isSelected(value:Boolean):void
        {
            super.isSelected=value;
            tag_selected.visible=value;

            if (value)
                ViewDispatcher.dispatch(EventType.SELECTED_TITLE_GOODS_GUIDE, data);
        }

    }
}
