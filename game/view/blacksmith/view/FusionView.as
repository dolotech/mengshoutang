package game.view.blacksmith.view {
    import com.utils.ArrayUtil;

    import feathers.controls.Scroller;
    import feathers.data.ListCollection;
    import feathers.layout.TiledColumnsLayout;
    import feathers.layout.TiledRowsLayout;

    import game.data.ForgeData;
    import game.data.Goods;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.net.message.EquipMessage;
    import game.view.blacksmith.render.NewEquipRender;
    import game.view.viewBase.NewFusionViewBase;

    /**
     * 合成界面
     * @author hyy
     *
     */
    public class FusionView extends NewFusionViewBase {
        private var curr_forgeData:ForgeData
        private var forge_list:Array = [];

        public function FusionView() {
            super();
        }

        override protected function init():void {
            const listLayout:TiledColumnsLayout = new TiledColumnsLayout();
            listLayout.useSquareTiles = false;
            listLayout.useVirtualLayout = true;
            listLayout.paddingTop = 5;
            listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
            list_equip.layout = listLayout;
            list_equip.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
            list_equip.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
            list_equip.itemRendererFactory = tileListItemRendererFactory;
            addChild(list_equip);

            function tileListItemRendererFactory():NewEquipRender {
                var itemRender:NewEquipRender = new NewEquipRender(false);
                itemRender.setSize(102, 120);
                return itemRender;
            }
            move(476, 82);
        }

        /**
         * 重置界面
         *
         */
        override public function resetView():void {
            var tmp_list:Array = [];

            for (var i:int = 0; i < 4; i++) {
                tmp_list.push(new Goods());
            }

            list_equip.dataProvider = new ListCollection(tmp_list);
            fusion_equipGrid.data = null;
            curr_forgeData = null;
        }

        public function onReturnForgeEquip(isSuccess:Boolean):void {
            data = curr_forgeData;
            list_equip.dataViewPort.dataProvider_refreshItemHandler();

            if (isSuccess)
                AnimationCreator.instance.createSecneEffect("effect_020", fusion_equipGrid.x + 89 / 2, fusion_equipGrid.y + 89 / 2,
                                                            this, AssetMgr.instance);
        }

        override public function set data(goods:Goods):void {
            curr_forgeData = ForgeData.hash.getValue(goods.type);

            if (curr_forgeData == null)
                return;
            curr_forgeData = curr_forgeData.clone() as ForgeData;
            curr_forgeData.isLookInfo = true;

            forge_list = curr_forgeData.getForgeList();
            fusion_equipGrid.data = curr_forgeData;
//			fusion_equipGrid.selectedTagStatus = false;
            list_equip.dataProvider = new ListCollection(forge_list);
            updateCostMoney(curr_forgeData.price, 0);
            getTipMsg();
        }

        /**
         * 获得提示信息
         * @return
         *
         */
        public function getTipMsg():String {
            if (!curr_forgeData)
                return getLangue("SELECTED_FORAGE_PROP");

            if (curr_forgeData.moneyTyep == 1 && GameMgr.instance.coin < curr_forgeData.price)
                return getLangue("notEnoughCoin");

            if (curr_forgeData.moneyTyep == 2 && GameMgr.instance.diamond < curr_forgeData.price)
                return getLangue("diamendNotEnough");

            if (!curr_forgeData.isCanForge)
                return getLangue("NOT_ENOUGH");
            return "";
        }



        override public function getEquipList(curr_goods:Goods):Array {
            var tmp_list:Array = [];
            var forgeData:ForgeData;
            var forgeList:Array = ArrayUtil.change2Array(ForgeData.foreVect);
            var maxSort:int = curr_goods.sort <= 7 ? 1 : 2;
            var miniSort:int = curr_goods.sort <= 7 ? curr_goods.sort : curr_goods.sort - 12;

            for (var i:int = forgeList.length - 1; i >= 0; i--) {
                forgeData = forgeList[i];

                if (forgeData.materials == null) {
                    warn("合成表没有填写合成物品:" + forgeData.id);
                    continue;
                }
                forgeData.getForgeList();

                if (forgeData.maxSort == maxSort && forgeData.miniSort == miniSort) {
                    if (forgeData == null) {
                        warn("找不到合成物品", forgeData.id);
                        continue;
                    }
                    tmp_list.push(forgeData);
                }
            }
            tmp_list.sortOn(["phase", "quality"], [Array.NUMERIC, Array.NUMERIC]);
            return tmp_list;
        }

        public function sendForgeGoods():void {
            var tip_msg:String = getTipMsg();

            if (tip_msg != "") {
                addTips(tip_msg);
                return;
            }
            curr_forgeData.unEquip();
            EquipMessage.sendForgeGoods(curr_forgeData.id);
        }
    }
}
