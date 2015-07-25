package game.view.shop {


    import com.langue.Langue;
    import com.utils.ObjectUtil;

    import game.data.ShopData;
    import game.manager.AssetMgr;
    import game.view.viewBase.ShopItemBase;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;

    import starling.display.Image;
    import starling.events.Event;
    import starling.textures.Texture;

    public class ShopItemRender extends ShopItemBase {
        public var onBuy:ISignal = new Signal(ShopData);
        private var _shopData:ShopData;
        private var _image:Image;

        public function ShopItemRender() {
            super();
            cost.text = Langue.getLangue("PRICE");
            setSize(270, 372);
            container.touchable = false;
            for (var i:int = 0; i < numChildren - 1; i++) {
                getChildAt(i).touchable = false;
            }
            buy.touchable = true;
        }

        override public function set data(value:Object):void {
            _shopData = value as ShopData;
            if (!_shopData)
                return;

            goodsName.text = _shopData.name;
            desc.text = _shopData.desc;
            var num:int = Math.ceil(_shopData.count * _shopData.cost);
            costValue.text = num + "";
            goodsIcon.texture = AssetMgr.instance.getTexture(_shopData.picture);
            var texture:Texture = AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang0");
            if (!_image) {
                _image = new Image(texture);
                ObjectUtil.setToCenter(container, _image);
                addQuiackChild(_image);
                addQuiackChild(count);
                _image.touchable = false;
            } else {
                _image.texture = texture;
            }
            var quality:int = _shopData.quality - 1;
            quality < 0 ? quality = 0 : null;
            texture = AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + quality);
            container.upState = texture;
            container.downState = texture;
//		if(_shopData.count.toString().length > 4)
//            count.fontName = "方正综艺简体";

            count.text = "×" + _shopData.count;
            super.data = value;
        }

        override public function dispose():void {
            onBuy.removeAll();
            super.dispose();
        }

        private function onBuyButton(event:Event):void {
            onBuy.dispatch(_shopData);
        }
    }
}
