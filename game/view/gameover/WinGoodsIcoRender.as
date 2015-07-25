package game.view.gameover {
    import game.data.Goods;
    import game.view.uitils.Res;
    import game.view.viewBase.WinGoodsIcoRenderBase;

    public class WinGoodsIcoRender extends WinGoodsIcoRenderBase {
        public function WinGoodsIcoRender() {
            super();
        }

        override public function set data(value:Object):void {
            super.data = value;
            var goods:Goods = value as Goods;

            if (goods == null)
                return;
            icon_quality.texture = Res.instance.getWinQualityPhoto(goods.quality);
            icon.texture = Res.instance.getGoodsPhoto(goods.type);
        }
    }
}
