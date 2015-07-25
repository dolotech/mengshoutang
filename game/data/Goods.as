package game.data {
    import com.data.Data;
    import com.data.HashMap;

    import flash.utils.ByteArray;


    /**
     * 物品表数据
     * @author joy
     */
    public class Goods extends Data {
        /**
         *是否从背包点击打开的物品引导
         */
        public var isPack:Boolean = true;
        public var isForge:Boolean = true;
        public var exp:int;
        public var need_FusionCount:int;
        public var isLookInfo:Boolean;

        //强化成功率系数
        public var strenthenSuccessFactor:Number;

        //强化金币系数
        public var strenthenCoinFactor:Number

        /**
         * 强化等级(物品等级)
         */
        public var level:int;
        /**
         * 推叠数
         * @default
         */
        public var pile:int;

        /**
         * 命中
         * @default
         */
        public var hit:int;
        /**
         * 防御
         * @default
         */
        public var defend:int;

        /**
         * 穿刺
         * @default
         */
        public var puncture:int;
        /**
         * 图标
         * @default
         */
        public var picture:String;
        /**
         *
         * @default
         */
        public var avatar:String;

        /**
         * 专属英雄
         */
        public var limitHero:int;
        /**
         *最高插槽数
         */
        public var maxSocket:int;
        /**
         * 状态
         */
        public var state:int;
        /**
         * 韧性
         */
        public var toughness:int;
        /**
         * 抗暴
         */
        public var anitCrit:int;
        /**
         * 暴击提成(爆强)
         */
        public var critPercentage:int;
        /**
         *暴击率
         */
        public var crit:int;
        /**
         * 闪避
         */
        public var dodge:int;

        /**
         * 最小装备等级
         * @default
         */
        public var limitLevel:int;

        /**
         * 分类
         * @default
         */
        public var sort:int;
        /**
         * 攻击
         * @default
         */
        public var attack:int;
        /**
         * 血量
         * @default
         */
        public var hp:int;

        /**
         * 品质
         * @default
         */
        public var quality:int;

        /**
         * 控制字段
         * @default
         */
        public var ctl1:int;

        /**
         * 道具|装备表的物品类型
         * @default
         */
        public var type:int;

        /**
         *
         * @default
         */
        public var desc:String = "";

        /**
         * 物品最大堆叠数量
         * @default
         */
        public var numberMax:int;

        /**
         * 1:武器，2：项链，3：戒指，4：手镯，5：非装备
         * @default
         */
        public var seat:int;

        /**
         *
         * @default
         */
        public var tab:int;


        /**
         * 阶
         */
        public var phase:int;
        /**
         *control1控制字段1
         */
        public var magicIndex:int;
        /**
         * 开宝箱物品
         */
        public var boxProps:String;

        /**
         *控制字段2
         */
        public var control2:int;

        /**
         *出售价格
         */
        public var Price:int;
        /**
         *出售类型
         */
        public var sellType:int;
        /**
         * 掉落地点
         */
        public var drop_location:String;

        public function getDropLocationList():Array {
            var tmp_arr:Array = drop_location != null ? drop_location.split(",") : [];
            var tmp_list:Array = [];
            var tmp_id:int;
            var _len:int = tmp_arr.length;
            for (var i:int = 0, len:int = _len; i < len; i++) {
                tmp_id = int(tmp_arr[i]);

                if (tmp_id == 0 || tmp_id == -1) {
                    tmp_list.push({data:tmp_id.toString()});
                } else {
                    tmp_list.push(MainLineData.getPoint(tmp_id));
                }
            }
            return tmp_list;
        }
        /**
         *是否引导推送
         */
        public var isGuide:int;

        /**
         *是否是竞技场装备
         */
        public var isPvp:int;
        public var enhance_limit:int;


        /**
         * 物品个数 客户端动态设置
         */
        public var goodsNum:uint;

        /**
         *
         * @default
         */
        public static var goods:HashMap;

        /**
         *
         * @param data
         */
        public static function init(data:ByteArray):void {
            data.position = 0;
            var vector:Array = data.readObject() as Array;
            var len:int = vector.length;

            for (var i:int = 0; i < len; i++) {
                var obj:Object = vector[i];
                var instance:Goods = new Goods();

                for (var key:String in obj) {
                    if (key == "magicIndex" && obj.sort == 7) {
                        instance.boxProps = obj[key];
                    } else {
                        instance[key] = obj[key];
                    }
                }

                if (instance.enhance_limit == 0)
                    instance.enhance_limit = 15;
                goods.put(instance.type, instance);
            }
        }

        /**
         * 战斗力
         * @return
         *
         */
        public function get power():uint {
            return Math.ceil((crit + dodge + critPercentage + hit + anitCrit + defend + puncture + toughness * 2 + 10000) / 10000 * (hp / 7 + attack));
        }

        public static function getExpList():Array {
            var tmp_list:Array = [];
            goods.eachValue(fun);
            function fun(goods:Goods):void {
                if (goods.tab == 2 && goods.sort == 5)
                    tmp_list.push(goods);
            }
            return tmp_list;
        }

    }
}


