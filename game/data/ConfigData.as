package game.data
{
    import com.data.Data;
    import com.singleton.Singleton;
    
    import flash.utils.ByteArray;

    /**
     * 游戏全局常量配置表
     * @author Administrator
     *
     */
    public class ConfigData extends Data
    {
        public var tired_max:int;
        public var init_gold:int;
        public var init_diamond:int;
        public var refresh_price:int;
        public var refresh_time:int;
        public var total_exp:int;
        public var charge:int;
        public var qifu:int;
        public var qifuxiaohao:int;
        public var fb_cd:int;
        public var free_times:int;
        public var fb_max1:int;
        public var fb_max2:int;
        public var fb_max3:int;
        public var fb_cd1:int;
        public var fb_cd2:int;
        public var fb_cd3:int;
        public var arenaCd:int;
        public var arenaBuy:int;
        public var arena_revenge:int;
        public var starCumulative:int;
        public var diamond_per_min:Number;
        public var starBack:int;
        public var tired_power:int;
        public var arena_start:int;
        public var daily:int;
        public var version_update:String;
        public var version:String;
        public var arenaBattleMax:int;
        public var materialPageMax:int;
        public var propsPageMax:int;
        public var equipPageMax:int;
        public var maxHero:int;


        public var purgeGuide:int;
        public var tavernGuide:int;
        public var fbGuide:int;
        public var arenaGuide:int;
        public var weixinShare:int;
        public var luckyGuide:int=20;

        public var herosoul_cd:int;
        public var herosoul_refresh:int;
        public var herosoul_cq:int;
        public var herosoul_coin_cd:int;
        public var herosoul_coin_count:int;
        public var herosoul_cq_times:int;

        public var facebook_url:String;

        /**
         *  聊天间隔
         */
        public var chatTime:int;

        /**
         * 程序版本号
         */
        public static var main_version:int=0;
        /**
         * 数据版本号
         */
        public static var data_version:int;

        public static function get instance():ConfigData
        {
            return Singleton.getInstance(ConfigData) as ConfigData;
        }

        /**
         *
         * @param data
         */
        public static function init(data:ByteArray):void
        {
            data.position=0;
            var instance:ConfigData=ConfigData.instance;
            var vector:Array=data.readObject() as Array;
            var len:int=vector.length;

            try
            {
                for (var i:int=0; i < len; i++)
                {
                    var obj:Object=vector[i];
                    var key:String=obj["id"];
                    instance[key]=obj["val"];
                }
            }
            catch (e:Error)
            {
                throw new Error("没有该字段:" + "key");
            }
        }



    }
}
