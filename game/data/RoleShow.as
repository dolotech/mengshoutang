package game.data {
    import com.data.Data;
    import com.data.HashMap;

    import flash.utils.ByteArray;

    /**
     *	英雄表现数据
     * @author Administrator
     */
    public class RoleShow extends Data {

        /**
         *
         * @default
         */
        public static var hash:HashMap;

        /**
         *
         * @param data
         */
        public static function init(data:ByteArray):void {
            hash = new HashMap();
            initData(data, hash, RoleShow);
        }
        /**
         * 卡牌
         */
        public var card:String;
        /**
         * 头像
         */
        public var photo:String;
        /**
         * 半身
         */
        public var half_photo:String;
        /**
         * 武器
         * @default
         */
        public var weaponID:int;
        /**
         * 动作
         * @default
         */
        public var avatar:String;

        /**
         * 移动速度
         * @default
         */
        public var moveSpeed:int;
        /**
         * 发起攻击动作到扣血或者子弹飞出的时间间隔
         */
        public var attackTime:int;

        /**
         * 1：头顶
           2：中间
           3：移动攻击
         */
        public var attackType:int;
        /**
         * 攻击特效
         */
        public var attackEffect:String;
        /**
         * 受击特效
         */
        public var underAttackEffect:String;

        /**
         *普通攻击的音效
         */
        public var attackMusic:String;
    }
}
