package game.data
{


    /**
     *
     * @author Administrator
     */
    public class Val
    {
        public static const OK:String="确定";
        public static const GOTO:String="继续";
        public static const CANCEL:String="取消";
        public static const exit:String="退出";
        public static const exit_msg:String="是否确定退出游戏?";
        public static const tips_title:String="提示";
        public static const ServerClose:String="服务器即将关闭!";
        public static const elsewhereLogin:String="您的账号已经在别处登录!";
        public static const update_data:String="数据需要更新,请重新进入游戏!";
        public static const connect_tips:String="正在连接中...请稍等";
        public static const connect_again:String="您的网络好像不太稳定哦，请确认后重新连接";
        public static const close_app:String="更新完毕，请重新进入游戏！";
        public static const loader_server:String="正在拼命更新资源:";
        public static const loader:String="正在拼命加载本地的图片无需耗流量";
        public static const NET_CONNECT_ERROR:String="网络连接失败,请检测你的网络!";
        public static const LOAD_NO_WIFT:String="您的当前网络不是wifi,是否确认继续更新?";

        public static const DROP_PVP:String="0";
        public static const DROP_PVP_GET:String="-1";

        public static const PASS_FB:int=1;

//        /**
//         * 最大上阵位置
//         */
        public static const SEAT_MAX:int=5;

        /**
         * 客户端位置转服务器
         * @param pos
         * @return
         *
         */
        public static function posC2S(pos:int):int
        {
            return pos >= Val.SEAT_COUNT ? 21 + pos : 11 + pos;
        }

        /**
         * 服务器位置转客户端
         * @param pos
         * @return
         *
         */
        public static function posS2C(pos:int):int
        {
            return pos >= 21 ? pos - 21 + Val.SEAT_COUNT : pos - 11;
        }

        public static var filter:Vector.<Number>=new Vector.<Number>;
        filter.push(0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0)
        public static var PROPERTY_LIST:Array=["attack", "hp", "defend", "puncture", "hit", "dodge", "crit", "critPercentage", "anitCrit", "toughness"];

        public static var MAGICBALL:Array=["attack", "hp", "defend", "puncture", "hit", "dodge", "crit", "critPercentage", "anitCrit", "toughness"]
        public static var tabList:Object={5: "bagequ", 2: "bagprop", 1: "bagmat"};

        public static var hardList:Object={1: 5, 2: 10, 3: 20}


        public static var PROPERTY_ICON:Object={attack: "ui_tongyong_tubiao_gongji", hp: "ui_tongyong_tubiao_xueliang", defend: "ui_tongyong_tubiao_fangyu", puncture: "ui_tongyong_tubiao_chuanci", hit: "ui_tongyong_tubiao_mingzhong", dodge: "ui_tongyong_tubiao_shanbi", crit: "ui_tongyong_tubiao_baoji", critPercentage: "ui_tongyong_tubiao_baoqiang", anitCrit: "ui_tongyong_tubiao_mianbao", toughness: "ui_tongyong_tubiao_renxing"};
        /*
         *
         * 角色形象缩放的分母
         *
         * */
        public static var ROLE_ZISE:int=100;
        /**
         * 英雄身上最大技能数量
         */
        public static const SKILL_COUNT:int=5;
        /**
         * 英雄身上的装备数量
         */
        public static const EQUIP_COUNT_ON_HERO:int=4;
        /**
         * 装备分类
         */
        public static const SEAT_WEAPON:int=1;
        /**
         *
         * @default
         */
        public static const SEAT_NECKLACE:int=2;
        /**
         *
         * @default
         */
        public static const SEAT_RING:int=3;
        /**
         *
         * @default
         */
        public static const SEAT_BRACELET:int=4;

        /**
         * 物品分类
         */
        public static const TAB_EQUIP:int=1;
        /**
         *
         * @default
         */
        public static const TAB_OBJ:int=2;
        /**
         *
         * @default
         */
        public static const TAB_PROP:int=3;
        /**
         *
         * @default
         */
        public static const TAB_SKILL:int=4;

        public static const HERO_COLOR:Array=[0xffffff, 0x3cff00, 0x0042ff, 0xde00ff, 0xffae00, 0xfd0000, 0xfffc00];
        /**
         * 布阵位置数量
         */
        public static const SEAT_COUNT:int=9;
        /*
           #  &1   - 暴击
           #  &2   - 闪避
           #  &4   - 复活
           #  &8   - 治疗
         */
        /**
         *
         * @default
         */
        public static const BJ:int=1;
        // 闪避
        /**
         *
         * @default
         */
        public static const SB:int=2;
        // 复活
        /**
         *
         * @default
         */
        public static const FH:int=4;
        // 治疗
        /**
         *
         * @default
         */
        public static const ZL:int=8;

        // 战斗驱动时间间隔
        /**
         *
         * @default
         */
        public static const BATTLE_DRIVER_DELAY:Number=0.8;

        public static const PORT_PUBLISH:int=8200;
    }
}
