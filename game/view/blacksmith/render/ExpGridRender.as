package game.view.blacksmith.render {
    import com.view.base.event.EventType;
    import com.view.base.event.ViewDispatcher;

    import game.data.Goods;
    import game.data.WidgetData;
    import game.view.uitils.Res;

    import starling.events.Event;
    import game.view.viewBase.ExpGridRenderBase;

    public class ExpGridRender extends ExpGridRenderBase {
        public function ExpGridRender() {
            super();
            icon.addEventListener(Event.TRIGGERED, onClick);
        }


        override public function set data(value:Object):void {
            super.data = value;

            if (value == null)
                return;
            var goods:Goods = value as Goods;
            icon.upState = Res.instance.getGoodsPhoto(goods.type);
            txt_add.text = "+" + goods.magicIndex;
            var count:int = WidgetData.pileByType(goods.type);
            txt_count.text = "x" + count;
            txt_count.color = count == 0 ? 0xff0000 : 0xffffff;
        }

        private function onClick():void {
            ViewDispatcher.dispatch(EventType.USE_EXP, data);
        }
    }
}
