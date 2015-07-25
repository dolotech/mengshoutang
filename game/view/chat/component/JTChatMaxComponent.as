package game.view.chat.component
{
    import com.components.RollTips;
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.utils.Constants;
    import com.utils.StringUtil;

    import flash.utils.ByteArray;
    import flash.utils.getTimer;

    import feathers.controls.TextInput;
    import feathers.core.PopUpManager;
    import feathers.data.ListCollection;
    import feathers.events.FeathersEventType;

    import game.common.JTFastBuyComponent;
    import game.common.JTGlobalDef;
    import game.common.JTGlobalFunction;
    import game.common.JTLogger;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.managers.JTFunctionManager;
    import game.managers.JTMessageInfoManager;
    import game.net.GameSocket;
    import game.net.data.c.CChatSend;
    import game.net.data.s.SChat;
    import game.view.chat.base.JTUIMaxChat;
    import game.view.comm.menu.MenuButton;
    import game.view.comm.menu.MenuFactory;
    import game.view.userLog.Input;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;
    import starling.textures.Texture;

    /**
     * 聊天界面最大化
     * @author CabbageWrom
     *
     */
    public class JTChatMaxComponent extends JTUIMaxChat
    {
        private var txt_input:TextInput=null;
        private var chatPanel:Sprite=null;

        public static var indexChannel:int=0;
        private var indexInput:int=0; //0世界，1喇叭
        private var ROW_MAX_NUM:int=45;
        private var MAX_INPUT_NUM:int=90;


        private static var instance:JTChatMaxComponent=null;

        public function JTChatMaxComponent()
        {
            super();
            initialize();
        }

        /**
         *喇叭数量更新
         *
         */
        private function onRefreshHornNum():void
        {
            var text:String=worldTxt.text;

            if (text.indexOf(Langue.getLans("chatNumbers")[1]) != -1)
            {
                worldTxt.autoScale=true;
                worldTxt.fontSize=20;
                worldTxt.text=Langue.getLans("chatNumbers")[1] + "(" + GameMgr.instance.horn.toString() + ")";
            }
        }

        private function initialize():void
        {
            JTFunctionManager.executeFunction(JTGlobalDef.STOP_CITY_ANIMATABLE);
            JTFunctionManager.registerFunction(JTGlobalDef.REFRESH_HORN_NUM, onRefreshHornNum);
            JTFunctionManager.registerFunction(JTGlobalDef.CHAT_INPUT_SWITCH, onChangeInputStatus);
            JTFunctionManager.registerFunction(JTGlobalDef.REFRESH_CHAT_PANEL, onRefreshChatPanel);
            initSendButton();
            initChatPanel();
            intiButtons();
            onChangeInputStatus(0);
            this.closeButton.y=this.worldTxt.y;
            this.closeButton.x=-(this.worldTxt.x + 10) * Constants.scale;
            //JTSingleManager.instance.messageInfoManager.testExecuteLogic();
        }

        private var chatMessages:JTMessageList=null;

        private function initChatPanel():void
        {
            chatMessages=new JTMessageList();
            chatMessages.dataProvider=new ListCollection();
            this.addChild(chatMessages);
            showChatMessages(JTMessageInfoManager.getMessages());

        }

        private function onUpdateItemInfo(display:DisplayObject, itemInfo:Object):void
        {
            var textField:TextField=display as TextField;
            textField.text=itemInfo.toString();
        }

        private function onScrollHandler(e:Event):void
        {
            JTLogger.info("[onSelect]fdfffffffffffffffffffffff");
        }

        private function onSelect(e:Event):void
        {
            JTLogger.info("[onSelect]fdfffffffffffffffffffffff");
        }

        private function initSendButton():void
        {
            this.indexInput=JTMessageInfoManager.MSG_WORLD;
            indexChannel=JTMessageInfoManager.MSG_ALL;
            txt_input=new TextInput();
            txt_input.x=234.1;
            txt_input.y=480;
            txt_input.width=456.1;
            txt_input.height=55;
            txt_input.maxChars=ROW_MAX_NUM;
            var inputConfig:Input=new Input;
            inputConfig.isPassword=false;
            inputConfig.passMatch=false;
            inputConfig.defaultText=Langue.getLangue("pleaseInput");
            inputConfig.input=txt_input;
            inputConfig.showDefaultText=true;
            inputConfig.StartFactory();
            this.enterButton.addEventListener(Event.TRIGGERED, onSendChatHandler);
            this.txt_input.addEventListener(FeathersEventType.FOCUS_IN, onMouseFocusIn);
            this.txt_input.addEventListener(FeathersEventType.FOCUS_OUT, onMouseFocusOut);
            this.addChild(txt_input);
            this.setChildIndex(this.enterButton, this.numChildren - 1);
        }

        private function onRefreshChatPanel(result:Object):void
        {
            var chatInfo:SChat=result as SChat;

            if (indexChannel != JTMessageInfoManager.MSG_ALL)
            {
                if (indexChannel != chatInfo.type)
                {
                    return;
                }
            }

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
            //var name:String =  + chatInfo.name + " : "
            var content:String=Langue.getLangue("chat_system") + ":" + chatInfo.content;
            var lines:Array=JTGlobalFunction.parseText(content, 640);
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
            var name:String=Langue.getLangue("chat_world") + chatInfo.name + " : "
            var content:String=name + chatInfo.content;

            var lines:Array=JTGlobalFunction.parseText(content, 650);
            var l:int=lines.length;

            for (var i:int=0; i < l; i++)
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

        private function showHornMessage(chatInfo:SChat):void
        {
            var name:String=Langue.getLangue("chat_notice") + chatInfo.name + " : "
            var content:String=name + chatInfo.content;

            var lines:Array=JTGlobalFunction.parseText(content, 650);
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


        private function onRefreshChatMessage(str:String):void
        {
            var msg:String=str + ":CabbageWrom:" + getTimer();
            chatMessages.restItemRender(msg + Math.random() * 100000 + 1);
            //JTLogger.info(msg);
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

        private function bytesToString(bytes:ByteArray):Vector.<String>
        {
            var lines:Vector.<String>=new Vector.<String>();
            bytes.position=0;
            var msg:String=bytes.readUTF();
            var rows:int=Math.ceil(msg.length / ROW_MAX_NUM);
            var i:int=0;
            var l:int=msg.length;
            var length:int=0;
            var line:String=null;

            for (i=0; i < l; i++)
            {
                var str:String=msg.charAt(i)

                if (length < 40)
                {
                    if (StringUtil.isDoubleChar(str))
                    {
                        length+=2;
                    }
                    else
                    {
                        length+=1;
                    }
                    line+=str;
                }
                else
                {
                    lines.push(line);
                    line=null;
                    length=0;
                }
            }
            return lines;
        }

        private function onSendChatHandler(e:Event):void
        {
            var message:String=StringUtil.trim(txt_input.text);

            if (message == "" || message.length == 0 || message == Langue.getLangue("chatBeyondMax") || message == Langue.getLangue("pleaseInput"))
            {
                RollTips.add(Langue.getLangue("cannotBeEmpty"));
            }
            else
            {
                if (JTGlobalFunction.toStringBytes(message).bytesAvailable > MAX_INPUT_NUM)
                {
                    RollTips.add(Langue.getLangue("chatBeyondMax"));
                    txt_input.text="";
                    return;
                }

                if (this.indexInput == JTMessageInfoManager.MSG_HORN)
                {
                    if (GameMgr.instance.horn <= 0)
                    {
                        DialogMgr.instance.open(JTFastBuyComponent, JTFastBuyComponent.FAST_BUY_HORN);
                    }
                    else
                    {
                        var sendHornPackage:CChatSend=new CChatSend();
                        sendHornPackage.content=message;
                        sendHornPackage.type=JTMessageInfoManager.MSG_HORN;
                        GameSocket.instance.sendData(sendHornPackage);
                        txt_input.text="";
                    }
                    return;
                }
                var chatController:JTChatControllerComponent=JTChatControllerComponent.instance;

                if (!chatController)
                {
                    JTLogger.error("[JTChatMaxComponent.onSendChatHandler]ChatController is Empty!");
                }
                var running:Boolean=chatController.timerRunning();

                if (!running)
                {
                    var sendMsgPackage:CChatSend=new CChatSend();
                    sendMsgPackage.content=message;
                    sendMsgPackage.type=this.indexInput;
                    GameSocket.instance.sendData(sendMsgPackage);
                    txt_input.text="";
                }
                setChatRestrictTime();
            }
        }

        private function setChatRestrictTime():void
        {
            var chatController:JTChatControllerComponent=JTChatControllerComponent.instance;

            if (!chatController)
            {
                JTLogger.error("[JTChatMaxComponent.onSendChatHandler]ChatController is Empty!");
            }
            var interval:int=chatController.getInterval();
            var running:Boolean=chatController.timerRunning();

            if (running)
            {
                RollTips.add(interval.toString() + Langue.getLangue("sendMsgTime"));
                return;
            }
            else
            {
                chatController.resetTimer();
            }
        }

        private function onMouseFocusIn():void
        {
            if (txt_input.text == Langue.getLangue("pleaseInput"))
            {
                txt_input.text="";
            }
        }

        private function onMouseFocusOut():void
        {
            if (txt_input.text == "")
            {
                txt_input.text=Langue.getLangue("pleaseInput");
            }
        }

        private function onChangeInputStatus(result:Object):void
        {
            this.indexInput=int(result + 1);
            var l:Array=Langue.getLans("chatNumbers");
            worldTxt.text=l[indexInput - 1];

            if (l[indexInput - 1] == Langue.getLans("chatNumbers")[1])
            {
                worldTxt.autoScale=true;
                worldTxt.fontSize=18;
                worldTxt.text+="(" + GameMgr.instance.horn.toString() + ")";
            }
            else
            {
                worldTxt.autoScale=false;
                worldTxt.fontSize=25;
            }
            JTButtonPullUI.close();

        }

        private function addChatButtons(e:Event):void
        {
            if (!getChildByName("btns"))
            {
                JTButtonPullUI.open(this, selectButton);
            }
            else
            {
                JTButtonPullUI.close();
            }
        }

        private function intiButtons():void
        {
            var onFocus:ISignal=new Signal();
            var factory:MenuFactory;
            factory=new MenuFactory();
            factory.onFocus=onFocus;
            var defaultSkin:Texture=AssetMgr.instance.getTexture("ui_button_chat_selected2");
            var downSkin:Texture=AssetMgr.instance.getTexture("ui_button_chat_selected");
            addChild(factory);
            factory.factory([{"defaultSkin": defaultSkin, "downSkin": downSkin, x: 772, y: 38, size: 20, color: 0xffffff, text: Langue.getLans("ChatButtonName")[0], onClick: onChangeChatMessages, name: "btn_all"}, {"defaultSkin": defaultSkin, "downSkin": downSkin, x: 772, y: 131, size: 20, color: 0xffffff, text: Langue.getLans("ChatButtonName")[1], onClick: onChangeChatMessages, name: "btn_system"}, {"defaultSkin": defaultSkin, "downSkin": downSkin, x: 772, y: 224, size: 20, color: 0xffffff, text: Langue.getLans("ChatButtonName")[2], onClick: onChangeChatMessages, name: "btn_horn"}]);
            var btn_menu:MenuButton=factory.getChildAt(0) as MenuButton;
            btn_menu.select();
            selectButton.addEventListener(Event.TRIGGERED, addChatButtons);
            closeButton.addEventListener(Event.TRIGGERED, onCloseHandler);
        }

        private function onCloseHandler(e:Event):void
        {
            close();
        }

        private function onChangeChatMessages(e:Event):void
        {
            var target:DisplayObject=e.target as DisplayObject;
            var targetName:String=target.name;

            switch (targetName)
            {
                case "btn_all":
                {
                    indexChannel=JTMessageInfoManager.MSG_ALL;
                    showChatMessages(JTMessageInfoManager.getMessages());
                    break;
                }
                case "btn_system":
                {
                    indexChannel=JTMessageInfoManager.MSG_SYSTEMNOTICE;
                    showChatMessages(JTMessageInfoManager.getTypeMessages(JTMessageInfoManager.MSG_SYSTEMNOTICE));
                    break;
                }
                case "btn_horn":
                {
                    indexChannel=JTMessageInfoManager.MSG_HORN;
                    showChatMessages(JTMessageInfoManager.getTypeMessages(JTMessageInfoManager.MSG_HORN));
                    break;
                }
                default:
                    break;
            }
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
            chatMessages.restItemRender(null);
        }

        override public function dispose():void
        {
            this.selectButton.removeEventListener(Event.TRIGGERED, addChatButtons);
            this.closeButton.removeEventListener(Event.TRIGGERED, onCloseHandler);
            this.enterButton.removeEventListener(Event.TRIGGERED, onSendChatHandler);
            this.txt_input.removeEventListener(FeathersEventType.FOCUS_IN, onMouseFocusIn);
            this.txt_input.removeEventListener(FeathersEventType.FOCUS_OUT, onMouseFocusOut);
            JTFunctionManager.executeFunction(JTGlobalDef.PLAY_CITY_ANIMATABLE);
            JTFunctionManager.executeFunction(JTGlobalDef.MAX_SWITCHOVER_MIN);
            JTFunctionManager.removeFunction(JTGlobalDef.REFRESH_HORN_NUM, onRefreshHornNum);
            JTFunctionManager.removeFunction(JTGlobalDef.CHAT_INPUT_SWITCH, onChangeInputStatus);
            JTFunctionManager.removeFunction(JTGlobalDef.REFRESH_CHAT_PANEL, onRefreshChatPanel);
            super.dispose();

            if (chatMessages)
            {
                chatMessages.dispose();
                chatMessages=null;
            }

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
                instance=new JTChatMaxComponent();
                JTGlobalFunction.autoAdaptiveSize(instance);
                parent.addChild(instance);
                PopUpManager.centerPopUp(instance);
                instance.x+=55 * Constants.scale;
                /*instance.x = (Constants.FullScreenWidth - instance.width) / 2;
                 instance.y = (Constants.FullScreenHeight - instance.height) / 2;*/
            }
        }

        override public function showBackground(isClickColse:Boolean=true, x:Number=0, y:Number=0, maxWidth:Number=0, maxHeight:Number=0):void
        {
            super.showBackground(isClickColse, x, y, maxWidth, maxHeight);
        }

        override protected function onCloseBackground():void
        {
            close();
        }

        public static function close():void
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
import game.manager.AssetMgr;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;

class JTImageText extends Sprite
{
    private var label:TextField=null;
    private var _text:String=null;
    private var image:Image=null;

    public function JTImageText():void
    {
        image=new Image(AssetMgr.instance.getTexture("ui_icon_chat1"));
        this.addChild(image);
        label=new TextField(image.width, image.height, "");
        label.fontSize=20;
        label.touchable=false;
        this.touchable=false
        this.addChild(label);
    }

    public function get text():String
    {
        return _text;
    }

    public function set text(value:String):void
    {
        label.text=value;
    }
}

class JTTextField extends TextField
{
    public function JTTextField(width:int=696, height:int=28, text:String="", fontName:String="myFont", fontSize:Number=12, color:uint=0x0, bold:Boolean=false)
    {
        super(width, height, text);
        this.isHtml=true;
        hAlign='left';
        this.x=40;
    }
}
