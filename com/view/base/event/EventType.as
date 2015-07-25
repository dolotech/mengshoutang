package com.view.base.event
{
    import starling.events.Event;

    /**
     * @author hyy
     * 创建时间：2014-1-3 上午10:49:22
     *
     */
    public class EventType extends Event
    {

        /**为方便ViewDispatcher派发和监听接收data继承Event*/
        public function EventType(type:String, data:*=null)
        {
            super(type, false, data);
        }

        /**
         * 断线重连
         */
        public static const CONNNECT:String="1";
        public static const AUTO_LOGIN:String="3";
        public static const GET_SERVER_LIST_OK:String="4_1";
        public static const GET_SERVER_LIST_FAIL:String="4_2";

        /**
         * 跳转页面
         */
        public static const GOTO_WEB:String="5";
        /**
         * 更新金币
         */
        public static const UPDATE_MONEY:String="10";
        /**
         * 更新当前服务器IP
         */
        public static const SELECTED_SERVER:String="11";
        /**
         * 充值双倍
         */
        public static const UPDATE_DIAMOND_DOUBLE:String="12";
        /**
         * 更新每日签到提示
         */
        public static const UPDATE_SIGN:String="21";
        /**
         * 更新公告提示
         */
        public static const UPDATE_NOTICE:String="22";
        /**
         * 更新战斗力
         */
        public static const UPDATE_POWER:String="23";
        /**
         * 更新副本状态
         */
        public static const UPDATE_PASS_FB:String="24";
        /**
         * 更新VIP
         */
        public static const UPDATE_VIP:String="25";
        /**
         * 更新疲劳
         */
        public static const UPDATE_TIRED:String="26";
        /**
         * 更新角斗场等级
         */
        public static const UPDATE_RANK_LEVEL:String="27";
        /**
         * 更新成就奖励
         */
        public static const NOTIFY_ACHIEVEMENT:String="31";
        /**
         * 英雄列表选择
         */
        public static const UPDATE_HERO_SELECTED:String="41";
        /**
         * 英雄身上装备选择
         */
        public static const UPDATE_BODYEQUIP_SELECTED:String="42";
        /**
         * 更新玩家装备信息
         */
        public static const NOTIFY_HERO_EQUIP:String="43";
        /**
         * 背包装备选择
         */
        public static const UPDATE_BAGEQUIP_SELECTED:String="44";
        /**
         * 合成装备
         */
        public static const NOTIFY_FORGE_EQUIP:String="45";
        /**
         * 强化CD
         */
        public static const NOTIFY_STRENGTHEN_CD:String="46";
        /**
         * 卸载强化石
         */
        public static const UN_STONE_SELECTED:String="47";
        /**
         * 强化装备
         */
        public static const NOTIFY_STRENGTHEN:String="48";
        /**
         * 更新宝珠信息
         */
        public static const UPDATE_EQUIP_GEM:String="49_1";
        /**
         * 英雄进化
         */
        public static const NOTIFY_HERO_PURGE:String="50";
        public static const UPDATE_BATTLE_STATUS:String="60";

        /**选中佣兵*/
        public static const NOTIFY_MERCENARY_SELECT:String="51";
        /**购买到佣兵*/
        public static const NOTIFY_MERCENARY_BUY:String="52";

        /**
         * 布阵显示英雄列表
         */
        public static const UPDATE_HERO_LIST_STATUS:String="61";
        /**
         * 更新英雄列表
         */
        public static const UPDATE_HERO_LIST:String="62";
        public static const UPDATE_HERO_INDEX:String="62_2";
        /**
         * 更新英雄装备
         */
        public static const UPDATE_HERO_EQUIP:String="62_1";
        /**
         * 移除英雄
         */
        public static const REMOVE_HERO:String="63";
        public static const BUY_HERO_GRID:String="64";

        /**
         * 英雄升星
         */
        public static const NOTIFY_HERO_STAR:String="65";

        /**
         * 更新竞技结算信息
         */
        public static const UPDATE_ARENARESULT:String="71";
        /**
         * 更新战斗录像列表
         */
        public static const UPDATE_BATTLE_VIDEO_RANK:String="72";

        /**
         * 主线选择
         */
        public static const SELECTED_MAINLINE:String="8_0";
        public static const UPDATE_SELECTED_MAINLINE:String="8_1";
        public static const UPDATE_MAINLINE_STAR:String="8_2";
        public static const MAINLINE_HIDDEN:String="8_3";
        public static const GOTO_NIGHTMARE_TOLLGATE:String="8_4";
        public static const GOTO_NIGHTMARE:String="8_5";

        /**
         * 成就更新
         */
        public static const UPDATE_ACHIEVEMENT:String="9_0";
        /**
         * 选中物品引导render
         */
        public static const SELECTED_TITLE_GOODS_GUIDE:String="10_0";
        public static const SELECTED_GOODS_GUIDE:String="10_1";

        /**
         * 出售物品
         */
        public static const SELL_GOODS:String="11_0";
        /**
         * 使用经验药水
         */
        public static const USE_EXP:String="11_1";
        /**
         * 更新英雄信息
         */
        public static const UPDATE_HERO_INFO:String="11_2";
        /**
         * 播放英雄特效
         */
        public static const PLAY_HERO_ANIMATION:String="11_3";
        /**
         * 打开竞技场界面
         */
        public static const OPEN_ARENA:String="12_0";
        /**
         * 跳转战斗界面
         */
        public static const CHANGE_BATTLE:String="12_1";

        /**
         * 更新任务列表
         */
        public static const UPDATA_TASK_LIST:String="13_1";
        /**
         * 改变改变条状态
         */
        public static const CHANGE_BAR_STATUE:String="changeBarSatue";
        /**
         * 更换头像成功
         */
        public static const UP_HEROPHOTO:String="upHeroPhoto";
        /**
         *宝珠吞噬默认选择
         */
        public static const SELECTED_DEFAULT:String="selectedDefault";

        /**战斗结束*/
        public static const BATTLE_GAME_OVER:String="battle_game_over";
    }
}


