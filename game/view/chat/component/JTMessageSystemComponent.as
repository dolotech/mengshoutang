package game.view.chat.component
{
    import com.scene.SceneMgr;
    import com.utils.Constants;
    import com.utils.ObjectUtil;

    import flash.geom.Rectangle;
    import flash.text.TextFieldAutoSize;

    import game.common.JTGlobalFunction;
    import game.common.JTSession;
    import game.managers.JTMessageInfoManager;
    import game.net.data.s.SChat;
    import game.scene.GameLoadingScene;
    import game.view.chat.base.JTUIMessageNotice;

    import starling.core.Starling;

    /**
     * 系统消息横条
     * @author CabbageWrom
     *
     */
    public class JTMessageSystemComponent extends JTUIMessageNotice
    {
        public static const SYSTEM:int=0;
        private static var notice:JTMessageSystemComponent=null;
        private static var messages:Vector.<SChat>=new Vector.<SChat>();
        private var isTween:Boolean=false;

        public function JTMessageSystemComponent()
        {
            super();
            initialize();
        }

        /**
         * 初始化消息
         * @param msg
         *
         */
        public function initMessage(msg:SChat):void
        {

            this.isTween=true;
            this.alpha=1;
            var content:String="【系统公告】：" + msg.content;
            content=JTGlobalFunction.parseStrToItem(content, true);
            content=JTGlobalFunction.assemblySysMsgColor(content, msg.name);

            if (msg.id == SYSTEM)
            {
                this.txt_noticeTxt.text="<font color='#EC2B2B' face='方正综艺简体' size='24'><b>" + content + "</b></font>";
            }
            else if (content.indexOf(msg.name) != -1)
            {
                this.txt_noticeTxt.text=content;
            }
            Starling.juggler.tween(this.txt_noticeTxt, 15, {x: -txt_noticeTxt.width, onComplete: onFinshTween});

        }

        private function initialize():void
        {
            this.txt_noticeTxt.isHtml=true;
            this.touchable=false;
            this.alpha=0;
            this.clipRect=new Rectangle((Constants.virtualWidth - 723) >> 1, 91.15, 723, this.height);
            this.txt_noticeTxt.autoSize=TextFieldAutoSize.CENTER;
            this.txt_noticeTxt.x=Constants.virtualWidth;
        }

        private function onReset():void
        {
            this.alpha=0;
            this.isTween=false;
            this.txt_noticeTxt.x=Constants.virtualWidth;
            Starling.juggler.removeTweens(this.txt_noticeTxt);
        }

        private function onFinshTween():void
        {
            JTMessageSystemComponent.close();

            if (messages.length > 0)
            {
                open(messages.shift());
            }
        }

        public static function checkMsg():void
        {
            if (messages.length > 0)
            {
                open(messages.shift());
            }
        }

        public static function open(msg:SChat):void
        {
            if (SceneMgr.instance.getCurScene() is GameLoadingScene)
            {
                messages.push(msg);
                return;
            }

            if (!notice)
            {
                notice=new JTMessageSystemComponent();
                JTGlobalFunction.autoAdaptiveSize(notice);
                JTSession.layerGlobal.addChild(notice);
            }

            if (messages.length > 0 || notice.alpha)
            {
                if (notice.isTween)
                    messages.push(msg);
                else
                    notice.initMessage(messages.shift());
            }
            else
            {
                notice.initMessage(msg);
            }
        }

        public static function close():void
        {
            if (!notice)
            {
                return;
            }

            if (notice.alpha)
            {
                notice.onReset();
            }
        }
    }
}
