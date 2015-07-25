package game.view.vip {
    import com.view.base.event.EventType;

    import game.data.VipData;
    import game.manager.GameMgr;
    import game.view.viewBase.VipDlgBase;

    import starling.events.Event;
    import com.utils.Constants;

    /**
     * VIP界面
     * @author hyy
     *
     */
    public class VipDlg extends VipDlgBase {
        public static const VIP:int = 0;
        public static const CHARGE:int = 1;
        private var chargeView:VipChargeView
        private var vipInfoView:VipInfoView;

        public function VipDlg() {
            super();
        }

        override protected function init():void {
            enableTween = true;
            _closeButton = btn_close;

            exp_curr.smoothing = Constants.NONE;
            exp_send.smoothing = Constants.NONE;

            setToCenter();
            clickBackroundClose();
        }

        override protected function addListenerHandler():void {
            super.addListenerHandler();
            addViewListener(btn_look, Event.TRIGGERED, onLookClick);
            addContextListener(EventType.UPDATE_MONEY, updateMoney);
            addContextListener(EventType.UPDATE_VIP, updateVip);
        }

        override protected function openTweenComplete():void {
            chargeView = new VipChargeView();
            addChild(chargeView);
            chargeView.x = 66;
            chargeView.y = 280;

            vipInfoView = new VipInfoView();
            addChild(vipInfoView);
            vipInfoView.x = 60;
            vipInfoView.y = 290;

            btn_look.text = _parameter == null || _parameter == VIP ? getLangue("look_vip") : getLangue("look_charge");
            updateMoney();
            onLookClick();
            updateVip(null, GameMgr.instance.vipData);
        }

        /**
         * 更新金币
         *
         */
        private function updateMoney():void {
            txt_money.text = GameMgr.instance.diamond + "";
        }

        /**
         * 查看VIP或者充值
         * @param evt
         *
         */
        private function onLookClick():void {
            var isLookVip:Boolean = btn_look.text == getLangue("look_charge");
            btn_look.text = isLookVip ? getLangue("look_vip") : getLangue("look_charge");
            chargeView.visible = isLookVip;
            vipInfoView.visible = !isLookVip;
        }

        /**
         * 更新VIP等级
         * @param vipLevel
         *
         */
        private function updateVip(evt:Event, vipData:VipData):void {
            txt_vip.text = vipData.id.toString();
            var nextVipData:VipData = VipData.list[vipData.id + 1];
            var currVipData:VipData = vipData.baseVip;
            var free:int = vipData.free >= currVipData.free ? currVipData.free : vipData.free;
            txt_needMoney.text = nextVipData ? (nextVipData.diamond - vipData.diamond - free) + "" : "N/A";
            txt_currlv.text = vipData.id.toString();
            txt_nextlv.text = nextVipData ? (nextVipData.id).toString() : "";
            txt_currMoney.text = vipData.diamond + "";
//            txt_sendMoney.text = free + "/" + currVipData.free;
            exp_curr.width = nextVipData ? (vipData.diamond / nextVipData.diamond * 550) : 0;

            if (exp_curr.width > 550)
                exp_curr.width = 550;
            exp_send.width = nextVipData ? (free / nextVipData.diamond * 550) : 0;
            exp_send.x = exp_curr.x + exp_curr.width;
        }
    }
}
