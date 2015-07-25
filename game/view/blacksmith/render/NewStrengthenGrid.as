package game.view.blacksmith.render {
    import game.data.Goods;
    import game.manager.AssetMgr;
    import game.view.viewBase.NewStrengthenGridBase;

    public class NewStrengthenGrid extends NewStrengthenGridBase {
        public function NewStrengthenGrid() {
            super();
        }

        override public function set data(value:Object):void {
            super.data = value;
            var goods:Goods = value as Goods;
            ico_goods.visible = value != null;
            ico_goods.touchable = value != null;
            txt_name.text = goods ? goods.name : "";
            tag.visible = goods == null;

            //装备图标
            if (goods && goods.picture)
                ico_goods.texture = AssetMgr.instance.getTexture(goods.picture);
        }

        override public function set isSelected(value:Boolean):void {
            //super.isSelected = value;
        }
    }
}
