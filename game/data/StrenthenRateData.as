/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-12-10
 * Time: 下午6:02
 * To change this template use File | Settings | File Templates.
 */
package game.data {
import com.data.HashMap;

import flash.utils.ByteArray;

/*
 *
 * 强化成功率计算表
 * */
public class StrenthenRateData {
    public static var hash:HashMap;
    public  static var stoneList:Vector.<StrenthenRateData>;

    /**
     *
     * @param data
     */
    public static function init(data:ByteArray):void {
        hash = new HashMap();
        data.position = 0;
        stoneList = new <StrenthenRateData>[];
        var vector:Array = data.readObject() as Array;
        var len:int = vector.length;
        var k:int = 0;
        for (var i:int = 0; i < len; i++) {
            var obj:Object = vector[i];
            var instance:StrenthenRateData = new StrenthenRateData();

            for (var key:String in obj) {
                instance[key] = obj[key];
            }

            if(instance.level == 1)
            {
                stoneList[k++] = instance;
            }
            hash.put(instance.level +""+ instance.stone, instance);
        }
    }

    public var level:int;
    public var stone:int;
    public var rate:int;
}
}
