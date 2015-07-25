package game.view.blacksmith.view {
    import com.dialog.DialogMgr;
    import com.utils.ArrayUtil;
    import com.view.base.event.EventType;

    import flash.utils.getTimer;

    import game.data.ConfigData;
    import game.data.Goods;
    import game.data.StrengthenData;
    import game.data.StrenthenRateData;
    import game.data.WidgetData;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.net.message.EquipMessage;
    import game.view.blacksmith.render.NewStrengthenGrid;
    import game.view.goodsGuide.EquipInfoDlg;
    import game.view.viewBase.NewStrengthenViewBase;

    import sdk.DataEyeManger;

    import starling.animation.DelayedCall;
    import starling.core.Starling;
    import starling.events.Event;

    /**
     * 强化界面
     * @author hyy
     *
     */
    public class StrengthenView extends NewStrengthenViewBase {
        private var list_stone:Array = [];
        private var curr_equip:WidgetData;
        private var cost_moeny:int;
        private var cost_diamond:int;
        private var cdTime:int;
        private var delayedCall:DelayedCall;

        public function StrengthenView() {
            super();
        }

        override protected function init():void {
            move(472, 86);
//			strengthen_grid.touchable = false;
        }

        override protected function addListenerHandler():void {
            for (var i:int = 0; i < 3; i++) {
                this.addViewListener(this["grid" + i], Event.TRIGGERED, onStoneClick);
            }
            this.addContextListener(EventType.NOTIFY_STRENGTHEN, onStrengthenNotify);
            this.addContextListener(EventType.NOTIFY_STRENGTHEN_CD, onStrengthenCDNotify);
        }

        /**
         * 重置界面
         *
         */
        override public function resetView():void {
            resetStone(false);
            curr_widget = null;
        }

        /**
         * 重置强化石
         * @param isClick
         *
         */
        private function resetStone(isClick:Boolean):void {
            var stoneGoods:Goods;

            for (var i:int = 0, len:int = list_stone.length; i < 3; i++) {
                stoneGoods = list_stone[i];

                this["grid" + i].data = null;

                if (stoneGoods == null)
                    continue;
                isClick && DataEyeManger.instance.useItem(stoneGoods.name, 1, DataEyeManger.STRENGTHEN);
                isClick && dispatch(EventType.UN_STONE_SELECTED, stoneGoods);
            }
            list_stone.length = 0;
            updateRate();
        }

        /**
         * 强化石点击
         * @param evt
         *
         */
        private function onStoneClick(evt:Event):void {
            var grid:NewStrengthenGrid = evt.currentTarget as NewStrengthenGrid;
            var stoneGoods:Goods = grid.data as Goods;

            if (stoneGoods == null)
                return;
            ArrayUtil.deleteArrayByField(list_stone, stoneGoods);

            stoneGoods.pile++;
            dispatch(EventType.UN_STONE_SELECTED, stoneGoods);
            grid.data = null;
            updateRate();
        }

        /**
         * 放入强化石
         * @param goods
         *
         */
        private var click_time:int = 0;

        override public function set data(goods:Goods):void {
            if (goods.tab == 5) {
                goodsInfoView(goods);
                return;
            }

            if (click_time > 0 && getTimer() - click_time < 200)
                return;

            click_time = getTimer();


            if (curr_equip && curr_equip.level >= curr_equip.enhance_limit)
                return addTips("NON_STRENGTHEN");

            if (goods.pile == 0) {
                addTips(getLangue("NOT_ENOUGH_STONE"));
                goodsInfoView(goods);
            } else if (list_stone.length >= 3)
                addTips(getLangue("STRENTHEN_STONE_FULL"));
            else {
                list_stone.push(goods);
                goods.pile--;
            }

            for (var i:int = 0; i < 3; i++) {
                goods = list_stone[i];
                this["grid" + i].data = goods;
            }

            updateRate();
        }

        private function goodsInfoView(goods:Goods):void {
            var tmp_goods:Goods = goods.clone() as Goods;
            tmp_goods.Price = 0;
            DialogMgr.instance.open(EquipInfoDlg, tmp_goods);
        }

        /**
         * 设置强化的装备
         * @param goods
         *
         */
        override public function set curr_widget(goods:WidgetData):void {
            cost_moeny = cost_diamond = 0;
            updateCostMoney(0, 0);
            resetStone(false);
            curr_equip = goods;
            strengthen_grid.data = goods;

            if (goods == null) {
                txt_hp.text = txt_attack.text = "";
                return;
            }
            var strengthenData:StrengthenData = StrengthenData.hash.getValue(goods.sort + "" + (goods.level + 1));

            if (strengthenData) {
                txt_attack.text = "+" + goods.getStrengthenValue("attack", strengthenData.rise);
                txt_hp.text = "+" + goods.getStrengthenValue("hp", strengthenData.rise);
                cost_moeny = curr_equip.strenthenCoinFactor * strengthenData.coin;
            }
            updateCostMoney(cost_moeny, cost_diamond);
            updateRate();
            EquipMessage.sendStrengthenCD(goods.id);
        }

        /**
         * 更新强化几率
         *
         */
        private function updateRate():void {
            var curr_equip_level:int = curr_equip ? curr_equip.level + 1 : 0;
            var strengthenData:StrenthenRateData;
            var goods:Goods;
            var rate:int = 0;

            for (var i:int = 0, len:int = list_stone.length; i < len; i++) {
                goods = list_stone[i];
                strengthenData = StrenthenRateData.hash.getValue(curr_equip_level + "" + goods.type);

                if (strengthenData == null) {
                    warn("找不到强化等级几率", curr_equip_level);
                    continue;
                }
                rate += strengthenData.rate;
            }
            rate *= curr_equip ? curr_equip.strenthenSuccessFactor : 0;
            rate = rate / 10;
            txt_rate.text = (rate > 100 ? 100 : rate) + "%";
        }

        /**
         * 获得提示信息
         * @return
         *
         */
        public function getTipMsg():String {
            if (curr_equip == null || curr_equip.id == 0)
                return getLangue("SELECED_EQUIP_TIPS");

            if (curr_equip.level >= curr_equip.enhance_limit)
                return getLangue("NON_STRENGTHEN");

            if (list_stone.length == 0)
                return getLangue("inputStrengthenStone");

            if (GameMgr.instance.coin < cost_moeny)
                return getLangue("notEnoughCoin");

            if (GameMgr.instance.diamond < cost_diamond)
                return getLangue("diamendNotEnough");

            return "";
        }

        /**
         * 请求强化装备
         *
         */
        public function sendStrengthenEquip():void {
            var tip_msg:String = getTipMsg();

            if (tip_msg != "") {
                addTips(tip_msg);
                return;
            }
            EquipMessage.sendStrengthenEquip(curr_equip.id, list_stone);
        }

        override public function getEquipList(curr_goods:Goods):Array {
            var tmp_list:Array = ArrayUtil.change2Array(StrenthenRateData.stoneList);
            var len:int = tmp_list.length;
            var return_list:Array = [];
            var strengthenData:StrenthenRateData;
            var goods:Goods;

            for (var i:int = 0; i < len; i++) {
                strengthenData = tmp_list[i];
                goods = Goods.goods.getValue(strengthenData.stone);

                if (goods == null) {
                    warn("强化界面找不到物品", strengthenData.stone);
                    continue;
                }
                goods = goods.clone() as Goods;
                goods.pile = WidgetData.pileByType(goods.type);
                return_list.push(goods);
            }
            return return_list;
        }

        private function onStrengthenCDNotify(evt:Event, time:int):void {
            cdTime = time;

            if (delayedCall)
                Starling.juggler.remove(delayedCall);
            delayedCall = null;
            updateTime()
        }

        private function updateTime():void {
            if (parent == null)
                return;
            txt_time.text = cdTime <= 0 ? "" : (cdTime / 60 >> 0) + " : " + (cdTime % 60);
            cost_diamond = Math.ceil(ConfigData.instance.diamond_per_min * (cdTime / 60))
            updateCostMoney(cost_moeny, cost_diamond);
            cdTime--;

            if (cdTime > 0 && parent)
                delayedCall = Starling.juggler.delayCall(updateTime, 1);
        }

        private function onStrengthenNotify(evt:Event, returnObj:Object):void {
            if (returnObj.isSuccess)
                AnimationCreator.instance.createSecneEffect("effect_009", strengthen_grid.x + 89 / 2, strengthen_grid.y + 89 / 2,
                                                            this, AssetMgr.instance);
            resetStone(true);
            curr_widget = curr_equip;
        }
    }
}
