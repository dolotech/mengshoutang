package game.view.activity.activity
{
    import com.utils.StringUtil;

    import game.dialog.ShowLoader;
    import game.net.data.c.CActivateKey;
    import game.net.data.s.SActivateKey;
    import game.view.activity.IActivity;
    import game.view.viewBase.ActivityCodeViewBase;

    import starling.events.Event;

    /**
     * 礼包兑换
     * @author hyy
     *
     */
    public class ActivityCodeView extends ActivityCodeViewBase implements IActivity
    {
        public function ActivityCodeView()
        {
            super();
        }

        override protected function show():void
        {
            onGetFocusIn();
            this.move(300, 136);
        }

        override protected function addListenerHandler():void
        {
            this.addViewListener(btn_ok, Event.TRIGGERED, onClick);
            this.addContextListener(CActivateKey.CMD + "", onActivateNotify);
        }

        private function onClick():void
        {
            var key:String=StringUtil.trim(txt_input.text);

            if (key == "")
            {
                addTips("chat3");
                return;
            }
            var cmd:CActivateKey=new CActivateKey();
            cmd.key=key;
            sendMessage(cmd);
            ShowLoader.add();
        }

        private function onActivateNotify(evt:Event, info:SActivateKey):void
        {
            switch (info.code)
            {
                case 0:
                    txt_input.text="";
                    break;
//                case 1://编译检查语法如果case值里面执行空不能编译通过打包
//                    break;
//                case 2:
//                    break;
//                case 3:
//                    break;
//                case 4:
//                    break;
                default :
                    break;
            }

            onGetFocusIn();
            addTips("activityCode" + info.code);
            ShowLoader.remove();
        }

        public function set data(data:Object):void
        {

        }

        public function set scrollToPageIndex(value:int):void
        {

        }

        private function onGetFocusIn():void
        {
//			txt_input.selectRange(0, txt_input.text.length);
//			txt_input.setFocus();
        }
    }
}
