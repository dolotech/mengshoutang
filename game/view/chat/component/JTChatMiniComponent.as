package game.view.chat.component
{
    import com.utils.Constants;

    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;

    import game.common.JTGlobalDef;
    import game.common.JTGlobalFunction;
    import game.common.JTLogger;
    import game.managers.JTFunctionManager;
    import game.managers.JTMessageInfoManager;
    import game.net.data.s.SChat;
    import game.view.chat.base.JTUIMiniChat;
    import game.view.dispark.DisparkControl;
    import game.view.dispark.data.ConfigDisparkStep;

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    /**
     * 聊天界面最小化
     * @author Administrator
     *
     */
    public class JTChatMiniComponent extends JTUIMiniChat
    {
        private var chatPanel:Sprite=null;

        private var messageList:Vector.<String>=null;
        private var ROW_MAX_NUM:int=34;

        private static var instance:JTChatMiniComponent=null;
        private var rangle:Rectangle=null;

        public function JTChatMiniComponent()
        {
            super();
            initialize();
            this.rangle=btn_maxButton.getBounds(this.btn_maxButton);
        }

        override public function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
        {
            if (rangle != null && !rangle.containsPoint(localPoint))
                return null;
            else
                return super.hitTest(localPoint, forTouch);
        }

        private function initialize():void
        {
            initMinChatPanel();
            initTextList();
//			showChatMessages(JTMessageInfoManager.getMessages());
            JTGlobalFunction.autoAdaptiveSize(this);
        }

        private function initMinChatPanel():void
        {
            this.messageList=new Vector.<String>();
            this.btn_maxButton && btn_maxButton.addEventListener(Event.TRIGGERED, onSwitchoverMaxChat);
            //功能引导存对象
            DisparkControl.dicDisplay["btn_chat"]=this.btn_maxButton;
//			JTFunctionManager.registerFunction(JTGlobalDef.REFRESH_CHAT_PANEL, onRefreshChatPanel);
        }

        private function showChatMessages(msgs:Vector.<SChat>):void
        {
            clearMessages();
            var i:int=0;
            var l:int=msgs.length;

            for (i=0; i < l; i++)
            {
                onRefreshChatPanel(msgs.shift());
            }
        }

        private function clearMessages():void
        {
            messageList.length=0;
            onUpdateChatPanel(messageList);
        }

        private function initTextList():void
        {
            chatPanel=new Sprite();
            var i:int=0;
            var l:int=4;

            for (i=0; i < l; i++)
            {
                var txt_chat:TextField=new TextField(this.mc_chatpanel9Scale.width, (this.mc_chatpanel9Scale.height / l - 2), "", "", (12 * Constants.scale));
                txt_chat.y=i * txt_chat.height + 5;
                txt_chat.x=this.mc_chatpanel9Scale.x;
                txt_chat.isHtml=true;
                txt_chat.hAlign='left';
                txt_chat.name="txt" + (l - i - 1);
                chatPanel.addChild(txt_chat);
            }
            chatPanel.clipRect=new Rectangle(0, 0, Constants.FullScreenWidth, Constants.FullScreenHeight);
            chatPanel.x=4;
            chatPanel.y=4;
            this.addChild(chatPanel);
            this.setChildIndex(this.btn_maxButton, this.numChildren - 1);
        }

        private function onRefreshChatPanel(result:Object):void
        {
            var chatInfo:SChat=result as SChat;

            switch (chatInfo.type)
            {
                case JTMessageInfoManager.MSG_HORN:
                {
                    showHornMessage(chatInfo);
                    break;
                }
                case JTMessageInfoManager.MSG_SOCIETY:
                {
                    break;
                }
                case JTMessageInfoManager.MSG_SYSTEMNOTICE:
                {
                    showSystemMessage(chatInfo);
                    break;
                }
                case JTMessageInfoManager.MSG_WORLD:
                {
                    showWorldMessage(chatInfo);
                    break;
                }
                default:
                {
                    JTLogger.error("[JTChatMaxComponent.onRefreshChatPanel]Can't Find The Msg Type!");
                    break;
                }
            }
        }

        /**
         *
         * @param chatInfo
         *
         */
        private function showSystemMessage(chatInfo:SChat):void
        {
            var content:String="【系统】:" + chatInfo.content;

            var lines:Array=JTGlobalFunction.parseText(content, 400);
            var i:int=0;
            var l:int=lines.length;

            for (i=0; i < l; i++)
            {
                var line:String=lines.shift();

                if (chatInfo.id != 0)
                {
                    var index:int=line.indexOf(chatInfo.name);
                    var list:Array=line.split(chatInfo.name);

                    if (index != -1)
                    {
                        onRefreshChatMessage(JTGlobalFunction.toHTMLStyle("#EC2B2B", list[0]) + JTGlobalFunction.toHTMLStyle("#33FCFC", chatInfo.name) + JTGlobalFunction.toHTMLStyle("#EC2B2B", list[1]));
                    }
                    else
                    {
                        onRefreshChatMessage(JTGlobalFunction.toHTMLStyle("#EC2B2B", line));
                    }
                    continue;
                }

                if (i == 0)
                {
                    onRefreshChatMessage(JTGlobalFunction.toHTMLStyle("#EC2B2B", line));
                    continue;
                }
                onRefreshChatMessage(JTGlobalFunction.toHTMLStyle("#EC2B2B", line));
            }
        }

        private function showWorldMessage(chatInfo:SChat):void
        {
            var name:String="【世界】" + chatInfo.name + " : "
            var content:String=name + chatInfo.content;

            var lines:Array=JTGlobalFunction.parseText(content, 400);
            var i:int=0;
            var l:int=lines.length;

            for (i=0; i < l; i++)
            {
                var line:String=lines.shift();
                var index:int=line.indexOf(name);

                if (index != -1)
                {
                    var list:Array=line.split(name);
                    onRefreshChatMessage(JTGlobalFunction.toHTMLStyle("#33FCFC", name) + JTGlobalFunction.toHTMLStyle("#FFFFCCI", list[1]));
                }
                else
                {
                    onRefreshChatMessage(JTGlobalFunction.toHTMLStyle("#FFFFCCI", line));
                }
            }
        }

        private var byteArray:ByteArray=null;

        private function parseStrLength(str:String):uint
        {
            if (!byteArray)
                byteArray=new ByteArray();
            byteArray.clear();
            byteArray.writeMultiByte(str, "utf-8");
            return byteArray.length;
        }

        private function showHornMessage(chatInfo:SChat):void
        {
            var name:String="【喇叭】" + chatInfo.name + " : "
            var content:String=name + chatInfo.content;

            var lines:Array=JTGlobalFunction.parseText(content, 400);
            var i:int=0;
            var l:int=lines.length;

            for (i=0; i < l; i++)
            {
                var line:String=lines.shift();
                var index:int=line.indexOf(name);

                if (index != -1)
                {
                    var list:Array=line.split(name);
                    onRefreshChatMessage(JTGlobalFunction.toHTMLStyle("#33FCFC", name) + JTGlobalFunction.toHTMLStyle("#ff9900", list[1]));
                }
                else
                {
                    onRefreshChatMessage(JTGlobalFunction.toHTMLStyle("#ff9900", line));
                }
            }
        }

        public function onRefreshChatMessage(str:String):void
        {
            messageList.unshift(str);
            onUpdateChatPanel(messageList);
        }

        private function onUpdateChatPanel(messageList:Vector.<String>):void
        {
            var i:int=0;
            var numChildren:int=chatPanel.numChildren;
            var l:int=messageList.length;

            for (i=0; i < numChildren; i++)
            {
                var txt_item:TextField=chatPanel.getChildByName("txt" + i) as TextField;

                if (i > l - 1)
                {
                    txt_item.text="";
                    continue;
                }
                txt_item.text=messageList[i];
            }
        }

        private function onSwitchoverMaxChat(e:Event):void
        {
            if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep6)) //聊天功能是否开启
                return;
            //智能判断是否删除功能开放提示图标（聊天）
            DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep6);

            JTFunctionManager.executeFunction(JTGlobalDef.MIN_SWITCHOVER_MAX);
        }

        override public function dispose():void
        {
            super.dispose();
            btn_maxButton && btn_maxButton.removeEventListener(Event.TRIGGERED, onSwitchoverMaxChat);
            JTFunctionManager.removeFunction(JTGlobalDef.REFRESH_CHAT_PANEL, onRefreshChatPanel);

            if (instance.parent)
            {
                instance.removeFromParent();
                instance=null;
            }
        }

        public static function open(parent:Sprite):void
        {
            if (!instance)
            {
                instance=new JTChatMiniComponent();
                parent.addChild(instance);
                instance.y=Constants.FullScreenHeight - instance.height - 80;
            }
        }

        public static function colse():void
        {
            if (instance)
            {
                instance.removeFromParent();
                instance.dispose();
                instance=null;
            }
        }

    }
}
