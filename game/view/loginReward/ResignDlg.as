package game.view.loginReward
{
    import com.langue.Langue;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;

    import starling.display.DisplayObjectContainer;
    import starling.events.Event;

    /**
     * 购买疲劳
     * @author hyy
     *
     */
    public class ResignDlg extends ResignDlgBase
    {
        public var onResign:ISignal;
        public var onClose:ISignal;

        public function ResignDlg()
        {
            super();
            enableTween=true;
            onResign=new Signal();
            onClose=new Signal();
            _closeButton=btn_close;

            initText();
            initOKButtonEvent();
        }

        public function set tile(value:String):void
        {
            txt_title.text=value;
        }

        public function set text(value:String):void
        {
            txt_info.text=value;
        }

        override protected function show():void
        {
            setToCenter();
        }

        public static function setResignCost(cost:int):void
        {
            _resignDiamondCost=cost;
        }

        private function reduceDiamond():void
        {
            _resignDiamondCost;
        }

        private function initText():void
        {
            txt_close.text=Langue.getLangue("signRewardResignMsgCloseText");
            txt_ok.text=Langue.getLangue("signRewardResignMsgOKText");
            txt_title.text=Langue.getLangue("signRewardResignMsgTitleText");
            txt_info.text=Langue.getLangue("signRewardResignMsgInfoText").replace("cost", String(_resignDiamondCost));
        }

        private function initOKButtonEvent():void
        {
            btn_ok.addEventListener(Event.TRIGGERED, onOKButtonClick);
            btn_close.addEventListener(Event.TRIGGERED, onCloseButtonClick);
        }
        private static var _resignDiamondCost:int=0;

        //通知HeroDlg,英雄大厅，更新英雄
        protected function onOKButtonClick(e:Event):void
        {
            onResign.dispatch();
            close();
        }

        protected function onCloseButtonClick(e:Event):void
        {
            onClose.dispatch();
            close();
        }

        override public function open(container:DisplayObjectContainer, parameter:Object=null, okFun:Function=null, cancelFun:Function=null):void
        {
            super.open(container, parameter, okFun, cancelFun);
        }

        override public function dispose():void
        {
            onResign.removeAll();
            onClose.removeAll();
            super.dispose();
        }

    }
}
