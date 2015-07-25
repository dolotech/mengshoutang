package game.view.vip {
    import com.dialog.DialogMgr;

    import game.data.Goods;
    import game.data.HeroData;
    import game.manager.AssetMgr;
    import game.view.goodsGuide.EquipInfoDlg;
    import game.view.uitils.Res;
    import game.view.viewBase.VipRewardRenderBase;

    public class VipRewardRender extends VipRewardRenderBase {
        public function VipRewardRender() {
            super();
            ico_bg.touchable = true;
        }

        override public function set data(value:Object):void {
            super.data = value;

            if (value == null)
                return;

            if (value is Goods) {
                var goods:Goods = value as Goods;
                txt_name.text = goods.name;
                txt_count.text = "x" + goods.pile;
                ico_goods.texture = AssetMgr.instance.getTexture(goods.picture);
                ico_bg.texture = Res.instance.getQualityPhoto(goods.quality);
            } else if (value is HeroData) {
                var heroData:HeroData = value as HeroData;
                txt_name.text = heroData.name;
                txt_count.text = "x1";
                ico_goods.texture = Res.instance.getHeroIcoPhoto(heroData.show);
                ico_bg.texture = Res.instance.getQualityPhoto(heroData.quality);
            }
        }

        override public function set isSelected(value:Boolean):void {
            if (value) {
                var goods:Goods = data as Goods;
                goods = goods.clone() as Goods;
                goods.Price = 0;
                DialogMgr.instance.open(EquipInfoDlg, goods);
            }
        }

    }
}
