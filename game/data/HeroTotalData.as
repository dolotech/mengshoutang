package game.data {
    import com.data.Data;
    import com.data.HashMap;

    import flash.utils.ByteArray;

    public class HeroTotalData extends Data {

        public var maxcount:uint = 0;

        public static var hash:HashMap;

        public function HeroTotalData() {
            super();
        }

        /**
         * @param data
         */
        public static function init(data:ByteArray):void {
            hash = new HashMap();
            initData(data, hash, HeroTotalData, "id");
        }
    }
}


