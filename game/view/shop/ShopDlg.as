package game.view.shop {
    import com.components.RollTips;
    import com.components.TabButton;
    import com.components.TabMenu;
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.utils.Constants;
    import com.utils.StringUtil;

    import feathers.controls.List;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ListCollection;
    import feathers.layout.TiledColumnsLayout;
    import feathers.layout.TiledRowsLayout;

    import game.data.ShopData;
    import game.dialog.DialogBackground;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.net.message.GoodsMessage;
    import game.view.dispark.DisparkControl;
    import game.view.dispark.data.ConfigDisparkStep;
    import game.view.viewBase.ShopDlgBase;
    import game.view.vip.VipDlg;

    import starling.display.DisplayObjectContainer;
    import starling.events.Event;
    import starling.textures.Texture;

    /**
     * 商城
     * @author Administrator
     */
    public class ShopDlg extends ShopDlgBase {
        public function ShopDlg() {
            isVisible = true;
            _closeButton = btn_close;
            diamond.text = StringUtil.changePrice(GameMgr.instance.diamond);
            coin.text = GameMgr.instance.coin + "";
            initChargeButtonEvent();

            background = new DialogBackground();
        }

        private function initChargeButtonEvent():void {
            Recharge.addEventListener(Event.TRIGGERED, onChargeButtonClick);
        }

        private function onChargeButtonClick(e:Event):void {
            DialogMgr.instance.open(VipDlg, VipDlg.CHARGE);
        }

        private var _list:List;
        private var _menu:TabMenu;
        private var tabButtons:Vector.<TabButton>;

        override public function dispose():void {
            _list && _list.dispose();
            super.dispose();
        }


        override public function open(container:DisplayObjectContainer, parameter:Object = null, okFun:Function = null, cancelFun:Function = null):void {
            super.open(container, parameter, okFun, cancelFun);

//        var q:Quad = new Quad(this.stage.width, this.stage.height, 0x000);
//        this.addChildAt(q, 0);

            const listLayout:TiledColumnsLayout = new TiledColumnsLayout();
            listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
            listLayout.useVirtualLayout = true;
            listLayout.useSquareTiles = false;
            _list = new List();
            _list.x = 56;
            _list.y = 153;
            _list.width = 847;
            _list.height = 384;

            _list.layout = listLayout;
            _list.itemRendererFactory = tileListItemRendererFactory;
            _list.addEventListener(Event.CHANGE, onSelected);
            addChild(_list);

            updateMoney();
            GameMgr.instance.onUpateMoney.add(updateMoney);

            createMenu();

            setToCenter();
        }

        /**
         *
         * @return
         */
        protected function tileListItemRendererFactory():IListItemRenderer {
            var item:ShopItemRender = new ShopItemRender();
            return item as IListItemRenderer;
        }

        private function createMenu():void {
            const NOMAL_TEXTURE:Texture = AssetMgr.instance.getTexture("ui_gongyong_yibanmubanhentiao_anniu2");
            const DOWN_TEXTURE:Texture = AssetMgr.instance.getTexture("ui_gongyong_yibanmubanhentiao_anniu1");
            /* 1:强化石
             2:宝珠
             3:其他*/
            var tabButton0:TabButton = new TabButton(NOMAL_TEXTURE, DOWN_TEXTURE);
            tabButton0.text = Langue.getLangue("shop_all");
            tabButton0.fontColor = 0xffffff;
            tabButton0.fontSize = 30;
            var tabButton1:TabButton = new TabButton(NOMAL_TEXTURE, DOWN_TEXTURE);
            tabButton1.x = 125;
            tabButton1.text = Langue.getLangue("STRENTHEN_STONE");
            tabButton1.fontColor = 0xffffff;
            tabButton1.fontSize = 30;
            var tabButton3:TabButton = new TabButton(NOMAL_TEXTURE, DOWN_TEXTURE);
            tabButton3.x = 255;
            tabButton3.fontColor = 0xffffff;
            tabButton3.fontSize = 30;
            tabButton3.text = Langue.getLangue("OTHERS");
            tabButtons = new <TabButton>[tabButton0, tabButton1, tabButton3];
            _menu = new TabMenu(tabButtons);
            _menu.x = 53;
            _menu.y = 548;
            addChild(_menu);
            _menu.addEventListener(Event.CHANGE, onTabMenu);

            _menu.selectedIndex = 0;
        }

        private function updateMoney():void {
            StringUtil.changePriceText(GameMgr.instance.coin, coin, k);
            StringUtil.changePriceText(GameMgr.instance.diamond, diamond, k1, false);
        }

        private function onSelected(e:Event):void {
            if (_list.selectedIndex == -1)
                return;

            var shop:ShopData = _list.selectedItem as ShopData;
            if (GameMgr.instance.diamond < Math.ceil(shop.count * shop.cost)) {
                RollTips.add(Langue.getLangue("diamendNotEnough"));
                _list.selectedIndex = -1;
                return;
            }

            GoodsMessage.onSendBuyItem(_list.selectedItem.id);
            _list.selectedIndex = -1;
        }

        private function onTabMenu(e:Event):void {
            if (_menu.selectedIndex == 0) {
                _list.dataProvider = new ListCollection(ShopData.hash.values());
                return;
            }
            var index:int = _menu.selectedIndex;
            if (index == 2)
                index = 3;
            var vector:Vector.<*> = ShopData.hash.values();
            var tmpArr:Vector.<ShopData> = new <ShopData>[];
            var len:int = vector.length;
            var k:int = 0;
            for (var i:int = 0; i < len; i++) {
                var shopData:ShopData = vector[i] as ShopData;
                if (shopData.shopType == (index)) {
                    tmpArr[k++] = shopData;
                }
            }
            const collection:ListCollection = new ListCollection(tmpArr);
            _list.dataProvider = collection;
        }

        override public function close():void {
            //智能判断是否删除功能开放提示图标（商城）
            DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep11);
            super.close();
        }

        override public function get height():Number {
            return 610 * (Constants.isScaleWidth ? Constants.scale_x : Constants.scale);
        }
    }
}
