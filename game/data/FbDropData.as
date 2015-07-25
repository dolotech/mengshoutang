/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-12-12
 * Time: 下午9:30
 * To change this template use File | Settings | File Templates.
 */
package game.data {
import com.data.Data;
import com.data.HashMap;

import flash.utils.ByteArray;
               /*副本掉落显示*/
public class FbDropData extends Data {
    public function FbDropData() {
        super();
    }

    public var hard:int;
    public var drop1:int;
    public var drop2:int;
    public var drop3:int;
    public var drop4:int;
    public var drop5:int;
    public var drop6:int;
    public var drop7:int;
    public var drop8:int;
    public var drop9:int;
    public var drop10:int;


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
        hash = new HashMap();
        data.position = 0;

        var vector:Array = data.readObject() as Array;
        var len:int = vector.length;
        for(var i : int = 0; i < len; i++)
        {
            var obj:Object = vector[i];
            var instance : FbDropData = new FbDropData();

            for (var key:String in obj)
            {
                instance[key] = obj[key];
            }
            hash.put(instance.id + "" + instance.hard,instance);
        }
    }
}
}
