package game.view.blacksmith.view {
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.view.base.event.EventType;

    import game.data.Goods;
    import game.data.MagicorbsData;
    import game.data.WidgetData;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.net.data.vo.MagicBallVO;
    import game.net.message.EquipMessage;
    import game.view.blacksmith.render.NewEquipGemRender;
    import game.view.loginReward.ResignDlg;
    import game.view.viewBase.NewEquipGemViewBase;

    import starling.events.Event;

    /**
     * 宝珠拆卸
     * @author hyy
     *
     */
    public class EquipGemView extends NewEquipGemViewBase {
        private var list_gem:Array = [];
        private const MAX_COUNT:int = 5;
        private var list_bag:Array;
        private var curr_equip:WidgetData;

        public function EquipGemView() {
            super();
        }

        override protected function init():void {
            this.move(530, 95);
            ico_weapon.touchable = false;
        }

        override protected function addListenerHandler():void {
            for (var i:int = 0; i < MAX_COUNT; i++) {
                this.addViewListener(this["gem" + i], Event.TRIGGERED, onGemClick);
            }
            this.addContextListener(EventType.UPDATE_EQUIP_GEM, onUpdateGemNotify)
        }

        private function onUpdateGemNotify():void {
            AnimationCreator.instance.createSecneEffect("effect_022", ico_weapon.x + 89 / 2, ico_weapon.y + 89 / 2, this,
                                                        AssetMgr.instance);
            curr_widget = curr_equip;
        }

        /**
         * 卸载宝石
         * @param evt
         *
         */
        private function onGemClick(evt:Event):void {
            var grid:NewEquipGemRender = evt.currentTarget as NewEquipGemRender;
            var gemGoods:Goods = grid.data as Goods;

            if (gemGoods == null || gemGoods.type == 0)
                return;
            var tip:ResignDlg = DialogMgr.instance.open(ResignDlg) as ResignDlg;
            tip.text = getLangue("REPLACE_ENCHANTING_ROUND").replace("*", MagicorbsData.dic_cost[gemGoods.quality]);
            tip.onResign.addOnce(isOkClick);

            function isOkClick():void {
                EquipMessage.sendUnGem(curr_equip.id, gemGoods.type);
            }
        }

        /**
         * 装备宝珠
         * @param goods
         *
         */
        override public function set data(goods:Goods):void {
            if (!checkInput(goods))
                return;
            var magic:MagicorbsData = MagicorbsData.hash.getValue(goods.quality);
            var isShow:Boolean = DialogMgr.instance.isShow(ResignDlg);
            var tip:ResignDlg = DialogMgr.instance.open(ResignDlg) as ResignDlg;
            tip.text = getLangue("REPLACE_ENCHANTING").replace("*", magic.coinCount1);
            !isShow && tip.onResign.addOnce(isOkClick);
            function isOkClick():void {
                if (goods.tab == 2 && goods.sort == 4) {
                    EquipMessage.sendInputGem(curr_equip.id, goods.id);
                }
            }
        }

        /**
         * 玩家装备设置
         * @param goods
         *
         */
        override public function set curr_widget(widgetData:WidgetData):void {
            curr_equip = widgetData;
            list_gem.length = 0;
            ico_weapon.data = widgetData;

            if (widgetData.sockets == null)
                widgetData.sockets = new Vector.<MagicBallVO>();
            var len:int = widgetData.sockets.length;
            var gemData:WidgetData;

            for (var i:int = 0; i < MAX_COUNT; i++) {
                if (i < len) {
                    gemData = new WidgetData(Goods.goods.getValue(widgetData.sockets[i].id));
                    gemData.gem_value = widgetData.sockets[i].value;
                    gemData.gem_type = Langue.getLans("MAGICBALL")[gemData.magicIndex - 1];
                } else if (i < widgetData.socketsNum) {
                    gemData = new WidgetData();
                }
                this["gem" + i].data = gemData;
                list_gem[i] = gemData;
                gemData = null;
            }
        }

        /**
         * 检测是否可以镶嵌
         * @param goods
         * @return
         *
         */
        private function checkInput(goods:Goods):Boolean {
            if (curr_equip == null || curr_equip.id == 0) {
                addTips("SELECED_EQUIP_TIPS");
                return false;
            }

            if (goods.pile == 0) {
                addTips("NOT_ENOUGH_GEM");
                return false;
            }

            if (gemSocketNum == 0) {
                addTips("GEM_STONE_FULL");
                return false;
            }

            var hasSameGem:Boolean = false;
            var hasNullSocket:Boolean = false;
            var tmp_gem:Goods;

            for (var i:int = 0; i < MAX_COUNT; i++) {
                tmp_gem = list_gem[i];

                //空的才能放入
                if (tmp_gem) {
                    if (tmp_gem.type == 0)
                        hasNullSocket = true;

                    if (tmp_gem.name == goods.name)
                        hasSameGem = true;
                }
            }

            if (hasSameGem) {
                addTips("NOT_SAME_GEM");
                return false;
            }
            return hasNullSocket;
        }

        /**
         * 可以放入的插槽数
         * @return
         *
         */
        private function get gemSocketNum():int {
            var index:int = 0;

            for (var i:int = 0; i < MAX_COUNT; i++) {
                if (list_gem[i] && list_gem[i].type == 0)
                    index++;
            }
            return index;
        }

        private function getBagGem(gem:Goods):Goods {
            var len:int = list_bag.length;
            var tmp_goods:Goods;

            for (var i:int = 0; i < len; i++) {
                tmp_goods = list_bag[i];

                if (tmp_goods.type == gem.type) {
                    return tmp_goods;
                }
            }
            gem.pile = 0;
            return gem;
        }

        override public function getEquipList(curr_goods:Goods):Array {
            list_bag = WidgetData.getBySort(4, 2);
            list_bag.sortOn(["quality", "level", "type"], Array.DESCENDING);
            return list_bag;
        }
    }
}
