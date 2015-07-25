package game.managers
{
    import game.common.JTLogger;

    /**
     * 单例管理器——伪单
     * 所有网络数据管理器
     * @author CabbageWrom
     *
     */
    public class JTSingleManager
    {
        public static var instance:JTSingleManager=null;

        public var messageInfoManager:JTMessageInfoManager=null;
        public var rankListInfoManager:JTRankListInfoManager=null;
        public var tollgateInfoManager:JTTollgateInfoManager=null;
        public var pvpInfoManager:JTPvpInfoManager=null;

        public function JTSingleManager()
        {
            init();
        }

        private function init():void
        {
            pvpInfoManager=new JTPvpInfoManager();
            messageInfoManager=new JTMessageInfoManager();
            rankListInfoManager=new JTRankListInfoManager();
            tollgateInfoManager=new JTTollgateInfoManager();
        }

        public static function initialize():void
        {
            if (!instance)
            {
                instance=new JTSingleManager();
            }
        }

        /**
         *清除所有数据
         *
         */
        public static function clears():void
        {
            if (!instance)
            {
                JTLogger.error("[JTSingleManager.clears]dataManager is Empty!");
            }
            instance.messageInfoManager.clears();
            instance.rankListInfoManager.clears();
            instance.rankListInfoManager.clears();
            instance.pvpInfoManager.clears();
        }

        public static function destory():void
        {
            instance.messageInfoManager.destory();
            instance.rankListInfoManager.destory();
            instance.rankListInfoManager.destory();
            instance.pvpInfoManager.destory();
        }
    }
}
