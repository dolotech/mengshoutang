package game.data {
    import com.data.Data;
    import com.data.HashMap;
    import com.singleton.Singleton;

    import flash.utils.ByteArray;

    /**
     * 经验数值
     * @author joy
     */
    public class ExpData extends Data {
        public var exp:int;

        public var exp_sum:int;
        public var item:String;

        /**
         *
         */
        public function ExpData() {
            super();
        }

        public static var hash:HashMap;

        public static function get instance():ExpData {
            return Singleton.getInstance(ExpData) as ExpData;
        }

        /**
         *
         * @param data
         */
        public static function init(data:ByteArray):void {
            hash = new HashMap();
            initData(data, hash, ExpData);
        }

        public static function getExpGoodsBylevel(level:int):String {
            var expData:ExpData = hash.getValue(level);
            var exp:RegExp = /\{[\d,\,]*\}/gs;
            var ex:RegExp = /\d+/gs;
            var expGoodsMsg:String = "";

            if (expData && expData.item) {
                var tmp_arr:Array = expData.item.match(exp);
                var len:int = tmp_arr.length;

                for (var i:int = 0; i < len; i++) {
                    var tmp_goodsArr:Array = tmp_arr[i].match(ex);
                    var goods:Goods = Goods.goods.getValue(tmp_goodsArr[0]);

                    if (goods)
                        expGoodsMsg += "," + goods.name + "x" + tmp_goodsArr[1];
                }
            }
            return expGoodsMsg;
        }

        public static function getGoodsList(level:int):Array {
            var arr:Array = [];
            var expData:ExpData = hash.getValue(level);
            var exp:RegExp = /\{[\d,\,]*\}/gs;
            var ex:RegExp = /\d+/gs;
            var expGoodsMsg:String = "";
            if (expData && expData.item) {
                var tmp_arr:Array = expData.item.match(exp);
                var len:int = tmp_arr.length;
                for (var i:int = 0; i < len; i++) {
                    var tmp_goodsArr:Array = tmp_arr[i].match(ex);
                    arr.push({data: Goods.goods.getValue(tmp_goodsArr[0]), num: tmp_goodsArr[1]});
                }
            }
            return arr;
        }
    }
}
