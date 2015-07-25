package game.data
{
    import com.data.Data;
    import com.data.HashMap;

    import flash.utils.ByteArray;

    /**
     * 功能开放数据模型
     * @author Samuel
     *
     */
    public class DisparkData extends Data
    {

        /**关卡限制*/
        public var point:uint;
        /**等级限制*/
        public var level:uint;
        /**提示说明*/
        public var tips:String;
        /**提示类型0主城里面 1战斗结束*/
        public var type:int;

        /**自定义数据---------------------------------*/
        /**回调函数*/
        public var callBack:Function;

        /**状态 0没提示过条， 1已经过提示条，2已经完成*/
        public var statue:uint;

        public function DisparkData()
        {
            super();
        }

        /**
         *
         * @default
         */
        public static var hash:HashMap;

        /**
         *
         * @param data
         */
        public static function init(data:ByteArray):void
        {
            hash=new HashMap();
            initData(data, hash, DisparkData, "id");
        }
    }
}
