package game.managers
{
    import com.components.RollTips;
    import com.langue.Langue;
    import com.langue.WordFilter;
    import com.mvc.interfaces.INotification;

    import flash.utils.Dictionary;

    import game.common.JTGlobalDef;
    import game.common.JTLogger;
    import game.manager.GameMgr;
    import game.net.data.s.SChat;
    import game.net.data.s.SChatSend;
    import game.net.data.s.SGet_game_horn;
    import game.view.chat.component.JTChatMaxComponent;
    import game.view.chat.component.JTMessageHornComponent;
    import game.view.chat.component.JTMessageSystemComponent;

    /**
     * 消息管理器
     * @author CabbageWrom
     *
     */
    public class JTMessageInfoManager extends JTDataInfoManager
    {
        public static const MSG_WORLD:int=1; //世界消息
        public static const MSG_HORN:int=2; //喇叭消息
        public static const MSG_SYSTEMNOTICE:int=3; //系统消息
        public static const MSG_SOCIETY:int=4; //公会消息

        public static const MSG_ALL:int=100; // 所有消息

        public var map:Dictionary=null;
        private const MAX_MSG_NUM:int=50;
        private const MAX_CHAT_NUM:int=100;

        public function JTMessageInfoManager()
        {
            super();
            map=new Dictionary(false);
        }

        override public function handleNotification(gameInfo:INotification):void
        {
            var downProtocol:String=gameInfo.getName();

            switch (downProtocol)
            {
                case SChat.CMD.toString():
                {
                    var msg:SChat=gameInfo as SChat;

                    if (msg.content.indexOf("#") == 0)
                        return;
                    var vip:String=msg.attr > 0 ? Langue.getLangue("vip") + msg.attr : "";
                    var role_name:String=msg.name;
                    msg.name=vip + role_name;
                    msg.content=msg.content.replace(role_name, msg.name);
                    var message:JTMessageInfo=new JTMessageInfo();
                    message.attr=msg.attr;
                    message.content=msg.content;
                    message.id=msg.id;
                    message.name=msg.name;
                    message.type=msg.type
                    msgRestrict(message);
                    executeLogic(message);
                    break;
                }
                case SGet_game_horn.CMD.toString():
                {
                    var hornInfo:SGet_game_horn=(gameInfo as SGet_game_horn);
                    GameMgr.instance.horn=hornInfo.horn;
                    JTFunctionManager.executeFunction(JTGlobalDef.REFRESH_HORN_NUM);
                    break;
                }
                case SChatSend.CMD.toString():
                {
                    var sendChat:SChatSend=gameInfo as SChatSend;
                    var status:int=sendChat.code;

                    switch (status)
                    {
                        case 1:
                        {
                            RollTips.add(Langue.getLangue("chat1"));
                            break;
                        }
                        case 2:
                        {
                            RollTips.add(Langue.getLangue("chat2"));
                            break;
                        }
                        case 3:
                        {
                            RollTips.add(Langue.getLangue("chat3"));
                            break;
                        }
                        case 4:
                        {
                            RollTips.add(Langue.getLangue("chat4"));
                            break;
                        }
                        default:
                            break;
                    }
                    break;

                }
                default:
                    break;
            }
        }

        /**
         * 消息限制
         * @param msg
         *
         */
        private function msgRestrict(msg:SChat):void
        {
            var type:String=msg.type.toString();

            if (!map[type])
            {
                map[type]=new Vector.<JTMessageInfo>();
            }
            var messages:Vector.<JTMessageInfo>=map[type];

            switch (type)
            {
                case MSG_HORN.toString():
                {
                    msg.content=WordFilter.instance.filter(msg.content);
                    break;
                }
                case MSG_SOCIETY.toString():
                {
                    msg.content=WordFilter.instance.filter(msg.content);
                    break;
                }
                case MSG_SYSTEMNOTICE.toString():
                {
                    msg.content=WordFilter.instance.filter(msg.content);
                    break;
                }
                case MSG_WORLD.toString():
                {
                    msg.content=WordFilter.instance.filter(msg.content);
                    break;
                }
                default:
                {
                    JTLogger.error("[JTChatMaxComponent.onRefreshChatPanel]Can't Find The Msg Type!");
                    break;
                }
            }
            var max_num:int=int(type) == MSG_HORN || int(type) == MSG_SYSTEMNOTICE ? MAX_MSG_NUM : MAX_CHAT_NUM

            if (messages.push(msg) > max_num)
            {
                messages.shift();
            }
        }

        override public function removeObserver():void
        {
            super.removeObserver();
        }

        /**
         *清除数据
         *
         */
        override public function clears():void
        {
            this.map=new Dictionary(false);
        }

        private function executeLogic(msg:SChat):void
        {
            var type:int=msg.type;

            if (type == JTMessageInfoManager.MSG_HORN)
            {
                JTMessageHornComponent.open(msg);
            }
            else if (type == JTMessageInfoManager.MSG_SYSTEMNOTICE)
            {
                JTMessageSystemComponent.open(msg);
            }
            if (type != JTMessageInfoManager.MSG_SYSTEMNOTICE || JTChatMaxComponent.indexChannel == JTMessageInfoManager.MSG_SYSTEMNOTICE && type == JTMessageInfoManager.MSG_SYSTEMNOTICE) //系统消息不用更新到世界里面
                JTFunctionManager.executeFunction(JTGlobalDef.REFRESH_CHAT_PANEL, msg);
        }

        public function testExecuteLogic():void
        {
            for (var i:int=0; i < 20; i++)
            {
                var schatInfo:SChat=new SChat();
                schatInfo.type=MSG_WORLD;
                schatInfo.content=i.toString();
                schatInfo.name="Winter";
                JTFunctionManager.executeFunction(JTGlobalDef.REFRESH_CHAT_PANEL, schatInfo);
            }
        }

        public function getValues():Array
        {
            var lines:Array=[];

            for each (var property:Object in map)
            {
                var list:Vector.<JTMessageInfo>=property as Vector.<JTMessageInfo>;
                var i:int=0;
                var l:int=list.length;

                for (i=0; i < l; i++)
                {
                    lines.push(list[i]);
                }
            }
            lines.sortOn("time", Array.NUMERIC);
            return lines;
        }

        public function getMap():Dictionary
        {
            return map;
        }

        /**
         * 获取指定类型的消息列表  ----浅复制
         * @param type 消息类型
         * @return 返回该类型的数组
         *
         */
        public static function getTypeMessages(type:int):Vector.<SChat>
        {
            var map:Object=JTSingleManager.instance.messageInfoManager.map;
            var messages:Vector.<SChat>=new Vector.<SChat>();
            var sourceMsgs:Vector.<JTMessageInfo>=map[type.toString()] ? map[type.toString()] : new Vector.<JTMessageInfo>();
            var i:int=0;
            var l:int=sourceMsgs.length;

            for (i=0; i < l; i++)
            {
                var messageInfo:JTMessageInfo=sourceMsgs[i] as JTMessageInfo;
                messages.push(messageInfo);
            }
            return messages;
        }

        /**
         * 获取全部消息列表(除了系统消息)----浅复制
         * @return 返回整消息列表
         *
         */
        public static function getMessages():Vector.<SChat>
        {
            var msgs:Vector.<SChat>=new Vector.<SChat>();
            var list:Array=JTSingleManager.instance.messageInfoManager.getValues();
            var i:int=0;
            var l:int=list.length;

            for (i=0; i < l; i++)
            {
                var messageInfo:JTMessageInfo=list.shift() as JTMessageInfo;
                if (messageInfo.type != JTMessageInfoManager.MSG_SYSTEMNOTICE)
                    msgs.push(messageInfo);
            }
            return msgs;
        }

        override public function listNotificationName():Vector.<String>
        {
            this.pushProcotol(SChatSend.CMD);
            this.pushProcotol(SChat.CMD);
            this.pushProcotol(SGet_game_horn.CMD);
            return super.listNotificationName();
        }
    }
}
import flash.utils.getTimer;

import game.net.data.s.SChat;

class JTMessageInfo extends SChat
{
    public var time:Number=0;

    public function JTMessageInfo()
    {
        super();
        this.time=getTimer();
    }
}
