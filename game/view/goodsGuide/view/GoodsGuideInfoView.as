package game.view.goodsGuide.view {
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.utils.Constants;

    import game.data.Goods;
    import game.data.HeroData;
    import game.data.WidgetData;
    import game.view.magicorbs.MagicOrb;
    import game.view.viewBase.GoodsGuideInfoViewBase;

    import starling.events.Event;
    import starling.text.TextField;

    /**
     * 物品引导详细信息
     * @author hyy
     *
     */
    public class GoodsGuideInfoView extends GoodsGuideInfoViewBase {
        private var _data:Goods;
        public var curr_data:HeroData;

        public function GoodsGuideInfoView() {
            super();
            grid.touchable = false;
            btn_Swallow.addEventListener(Event.TRIGGERED, opSwallow);
        }

        public function set data(goods:Goods):void {
            _data = goods;
            grid.isDrak = false;
            grid.data = goods;

            var tmpArray:Array = ["attack", "hp", "defend", "puncture", "hit", "dodge", "crit", "critPercentage", "anitCrit",
                                  "toughness"];
            var len:int = tmpArray.length;
            var txt:TextField;
            var key:String;

            for (var i:int = 0; i < len; i++) {
                key = tmpArray[i];
                txt = view_equip.getChildByName("txt_" + key) as TextField;
                txt.text = goods[key];
            }
            view_equip.visible = goods.tab == 5;
            txt_des.visible = !view_equip.visible;
            txt_des.text = goods.desc;
            if (!goods.isPack) {
                if (goods.name == "金币" || goods.name == "钻石") {
                    txt_price.text = "";
                    grid.txt_drop.text = "";
                    grid.txt_get.text = "";
                } else {
                    txt_price.text = goods.Price + "";
                }
            } else {

                txt_price.text = goods.Price * goods.pile + "" ;
            }
            TextField(view_equip.getChildByName("txt_solt")).text = goods.maxSocket + "";
            TextField(view_equip.getChildByName("txt_power")).text = goods.power + "";
            updateBtnStatus();
        }

        public function updateBtnStatus():void {
            if (curr_data) {
                var equip:WidgetData = WidgetData.getCanEquipWidgetByType(_data.type);
                var curr_equip:WidgetData = WidgetData.hash.getValue(curr_data.seat5);
                var btnText:String;

                //背包里面没有此装备
                if ((equip == null && (curr_equip && _data.type != curr_equip.type)) || (equip == null && curr_equip == null))
                    btnText = "forge";
                //当前英雄没有装备称号，并且有可以装备的物品
                else if (curr_data.seat5 == 0 && equip && equip.equip == 0)
                    btnText = "EQUIP";
                //当前英雄装备了称号，并且有其他称号可以装备
                else if (curr_data.seat5 > 0 && equip && equip.equip == 0 && equip.type != curr_equip.type)
                    btnText = "replace";
                else if (curr_data.seat5 > 0)
                    btnText = "noreplceNull";
                btn_ok.text = Langue.getLangue(btnText);
            } else {
                btn_ok.text = Langue.getLangue("SELL");
            }

            if (_data.tab == 2 && _data.sort == 4) {
                btn_ok.x = 21;
            } else {
                btn_Swallow.visible = false;
                btn_ok.x = 100;
            }
        }

        /**
         *跳转吞噬界面
         * @author lfr
         */
        private function opSwallow():void {
            if (_data.tab == 2 && _data.sort == 4) {
//				openAssignDialog(MagicOrb, _data);
                DialogMgr.instance.open(MagicOrb, [MagicOrb.TUSHI, _data]); //登录奖励
            }
        }

//		private function openAssignDialog(ClassName : Class, param : Object = null) : void
//		{
//			this.dispatch(CityIcon.CREATE_DIALOG, {"cls": ClassName, "data": param});
//		}

        public function get data():Goods {
            return _data;
        }

        override public function dispose():void {
            btn_Swallow.removeEventListener(Event.TRIGGERED, opSwallow);
            super.dispose();
            curr_data = null;
        }

        /**
         * 放到屏幕中间
         * @param _arg1
         */
        override public function setToCenter(x:int = 0, y:int = 0):void {
            this.x = (Constants.virtualWidth - this.width) * .5;
            this.y = (Constants.virtualHeight - this.height) * .5;
        }
    }
}
