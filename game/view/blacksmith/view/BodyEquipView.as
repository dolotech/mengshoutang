package game.view.blacksmith.view {
    import com.utils.ArrayUtil;

    import game.data.Goods;
    import game.data.Val;
    import game.data.WidgetData;
    import game.net.data.vo.MagicBallVO;
    import game.view.blacksmith.BlacksmithDlg;
    import game.view.viewBase.NewBodyEquipViewBase;

    import starling.text.TextField;

    /**
     * 装备物品界面
     * @author hyy
     *
     */
    public class BodyEquipView extends NewBodyEquipViewBase {
        public function BodyEquipView() {
            super();
        }

        override protected function init():void {
            move(476, 82);
            curr_equip.touchable = false;
        }

        /**
         * 重置界面
         *
         */
        override public function resetView():void {
            data = new WidgetData();
        }

        /**
         * 替换装备
         * @param goods
         *
         */
        override public function set data(goods:Goods):void {
            var tmpArray:Array = Val.MAGICBALL;
            var len:int = tmpArray.length;
            var txt1:TextField;
            var txt2:TextField;
            var key:String;
            var value:int;

            for (var i:int = 0; i < len; i++) {
                key = tmpArray[i];
                txt1 = this["txt_" + key] as TextField;
                txt2 = this["txt_" + key + "Add"] as TextField;

                if (goods.type == 0)
                    txt1.text = "";
                value = goods[key] - int(txt1.text);
                txt2.text = value > 0 ? "+" + value : (value == 0 ? "" : value + "");
                txt2.color = value > 0 ? 0x00ff00 : (value == 0 ? 0xffffff : 0xff0000);
            }
        }

        /**
         * 当前装备
         * @param goods
         *
         */
        override public function set curr_widget(goods:WidgetData):void {
            var tmpArray:Array = Val.MAGICBALL;
            var len:int = tmpArray.length;
            var txt:TextField;
            var key:String;
            var value:int;
            resetView();

            for (var i:int = 0; i < len; i++) {
                key = tmpArray[i];
                txt = this["txt_" + key] as TextField;
                value = goods[key];
                txt.text = value + "";
            }
            curr_equip.data = goods;
            curr_equip.txt_name.text = "";
            txt_level.text = goods.limitLevel + "";
            updateGem(goods);
        }

        /**
         * 更新宝珠信息
         * @param widgetData
         *
         */
        private function updateGem(widgetData:WidgetData):void {
            if (widgetData.sockets == null)
                widgetData.sockets = new Vector.<MagicBallVO>();
            var len:int = widgetData.sockets.length;
            var gemData:WidgetData;

            for (var i:int = 0; i < 5; i++) {
                gemData = i < len ? new WidgetData(Goods.goods.getValue(widgetData.sockets[i].id)) : null;

                this["gem" + i].visible = gemData != null;

                if (gemData)
                    this["gem" + i].texture = getTexture(gemData.picture);
                this["gemBg" + i].texture = getTexture(i < widgetData.socketsNum ? ("ui_gongyong_baoshikuang" + (gemData ? gemData.quality : "")) : "ui_gongyong_baoshikuang_lock");
            }
        }


        override public function getEquipList(curr_goods:Goods):Array {
            var tmp_list:Array = ArrayUtil.change2Array(WidgetData.getBySeat(curr_goods.seat));
            var tmp_widget:WidgetData;

            //去掉当前穿的装备
            for (var i:int = tmp_list.length - 1; i >= 0; i--) {
                tmp_widget = tmp_list[i];

                if (tmp_widget == null)
                    continue;

                if ((curr_goods.seat == 1 && tmp_widget.sort != curr_goods.sort) || tmp_widget.equip > 0)
                    tmp_list.splice(i, 1);
            }
            tmp_list.sortOn("Combat", Array.DESCENDING | Array.NUMERIC);
            tmp_list.push({data: getLangue("get_goods"), type: curr_goods.sort, level: BlacksmithDlg.curr_hero.level});
            return tmp_list;
        }

    }
}
