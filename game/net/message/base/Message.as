package game.net.message.base
{
    import com.components.RollTips;
    import com.langue.Langue;
    import com.view.base.event.EventMap;
    import com.view.base.event.ViewDispatcher;

    import flash.utils.Dictionary;

    import game.common.JTLogger;

    import game.dialog.ShowLoader;
    import game.net.GameSocket;
    import game.net.data.IData;

    import starling.events.Event;

    public class Message extends Notify
    {
        protected var dispatcher:ViewDispatcher
        protected var eventMap:EventMap;

        public function Message()
        {
            dispatcher=ViewDispatcher.instance;
            eventMap=new EventMap();
            addListenerHandler();
            init();
        }

        protected function init():void
        {

        }

        protected function addListenerHandler():void
        {

        }

        public function addHandler(eventString:*, listener:Function):void
        {
            eventMap.mapListener(dispatcher, eventString + "", removeMessageLoader);

            function removeMessageLoader(view:Event, data:IData):void
            {
                var numArgs:int=listener.length;
                if (numArgs == 0)
                    listener();
                else if (numArgs == 1)
                    listener(data);
                else if (numArgs == 2)
                    listener(view, data);

                if (data)
                    removeLoader(data.getCmd());
            }
        }

        public function dispose():void
        {
            if (eventMap)
                eventMap.unmapListeners();
            eventMap=null;
            dispatcher=null;
        }

        /**
         * 派发事件
         * @param type
         * @param obj
         *
         */
        public function dispatch(type:String, obj:*=null):void
        {
            dispatcher.dispatch(type, obj);
        }

        public static function dispatch(type:String, obj:*=null):void
        {
            ViewDispatcher.instance.dispatch(type, obj);
        }

        public function addTips(info:String):void
        {
            var msg:String=getLangue(info);
            RollTips.add(msg ? msg : info);
        }

        public static function addTips(info:String):void
        {
            var msg:String=Langue.getLangue(info);
            RollTips.add(msg ? msg : info);
        }

        public function warin(... args):void
        {
            JTLogger.warn(args.join(""));
        }

        public function getLangue(id:String):String
        {
            return Langue.getLangue(id);
        }


        public static function getLangue(id:String):String
        {
            return Langue.getLangue(id);
        }

        public static function sendMessage(data:IData, isShowloader:Boolean=true):void
        {
            if (isShowloader)
                showLoader(data.getCmd());
            GameSocket.instance.sendData(data);
        }

        /**
         * 清理缓存时处理
         *
         */
        public function clear():void
        {

        }

        private static var dic_loader:Dictionary=new Dictionary();

        /**
         * 显示加载进度条
         *
         */
        public static function showLoader(cmd:int=0):void
        {
            dic_loader[cmd]=true;
            ShowLoader.add(Langue.getLangue("load_connect"));
        }

        /**
         * 移除加载进度条
         *
         */
        public static function removeLoader(cmd:int=0):void
        {
            if (dic_loader[cmd])
            {
                dic_loader[cmd]=false;
                ShowLoader.remove();
            }
        }
    }
}
