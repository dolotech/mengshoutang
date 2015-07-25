package game.net
{
    import game.data.FBCDData;
    import game.net.message.ConnectMessage;
    import game.net.message.EquipMessage;
    import game.net.message.GameMessage;
    import game.net.message.GoodsMessage;
    import game.net.message.MailMessage;
    import game.net.message.RoleInfomationMessage;
    import game.net.message.TaskMessage;
    import game.net.message.base.Message;

    /**
     * 全局的事件处理
     * @author Administrator
     *
     */
    public class GlobalMessage
    {
        public function GlobalMessage()
        {
        }

        private static var instance:GlobalMessage;

        public static function getInstance():GlobalMessage
        {
            if (instance == null)
            {
                instance=new GlobalMessage();
                instance.init();
            }
            return instance;
        }

        private var list:Vector.<Message>=new Vector.<Message>();

        private function init():void
        {
            registered(MailMessage);
            registered(ConnectMessage);
            registered(RoleInfomationMessage);
            registered(EquipMessage);
            registered(GoodsMessage);
            registered(GameMessage);
            registered(TaskMessage);
        }

        private function registered(dataClass:Class):void
        {
            list.push(new dataClass());
        }

        /**
         * 清理缓存时处理
         *
         */
        public function clear():void
        {
            var len:int=list.length;

            for (var i:int=0; i < len; i++)
            {
                list[i].clear();
            }
            FBCDData.clear();
        }
    }
}
