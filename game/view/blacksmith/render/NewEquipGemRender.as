package game.view.blacksmith.render {
    import game.data.WidgetData;
    import game.manager.AssetMgr;
    import game.view.viewBase.NewEquipGemRenderBase;

    /**
     * 宝珠拆卸
     * @author hyy
     *
     */
    public class NewEquipGemRender extends NewEquipGemRenderBase {
        public function NewEquipGemRender() {
            super();
        }

        override public function set data(value:Object):void {
            super.data = value;
            var goods:WidgetData = value as WidgetData;
            txt_name.text = goods ? goods.gem_type : "";
            txt_value.text = goods && goods.gem_value > 0 ? "+" + goods.gem_value : "";
            gemBg.touchable = value != null;

            if (goods && goods.picture)
                ico_gem.texture = AssetMgr.instance.getTexture(goods.picture);
            ico_gem.visible = goods && goods.picture;
            gemBg.texture = AssetMgr.instance.getTexture(goods ? ("ui_gongyong_baoshikuang" + (goods.quality > 0 ? goods.quality : "")) : "ui_gongyong_baoshikuang_lock");
            txt_tips.visible = goods && goods.picture == null;
        }
    }
}
