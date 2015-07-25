package game.data
{
	import com.data.Data;
	import com.data.HashMap;

	import flash.utils.ByteArray;

	/**
	 *副本掉落和怪物
	 * @author Administrator
	 *
	 */
	public class FBData extends Data
	{
		/**
		 * 怪物
		 * @default
		 */
		public var monsters:Array;
		/**
		 * 物品掉落
		 * @default
		 */
//		public var dropProps:Array;

//        public var dropCoin:int;

		/**
		 *
		 */
		public function FBData()
		{
			super();
            monsters = [];
//            dropProps = [];
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
			data.position=0;

            hash = new HashMap();
            data.position = 0;
            var exp:RegExp = /\{[\d,\,]*\}/gs;
            var ex:RegExp = /\d+/gs;

            var vector:Array = data.readObject() as Array;
            var len:int = vector.length;
            for(var i : int = 0; i < len; i++)
            {
                var obj:Object = vector[i];
                var instance : FBData = new FBData();

                for (var key:String in obj)
                {
                  if(key == "monsters")
                    {
                        var str:String = obj[key];
                        var arr:Array = str.match(exp);
                        var le:int = arr.length;
                        for (var k:int = 0;k<le;k++)
                        {
                            var sub:String = arr[k];
                            var subArr:Array = sub.match(ex);
                            instance.monsters[k] = subArr;
                        }
                    }
                     /* else if(key == "dropProps")
                    {
                        var str:String = obj[key];
                        var arr:Array = str.match(exp);
                        var le:int = arr.length;
                        for (var k:int = 0;k<le;k++)
                        {
                            var sub:String = arr[k];
                            var subArr:Array = sub.match(ex);
                            instance.dropProps[k] = subArr;
                        }
                    }*/
                    else
                    {
                        instance[key] = obj[key];
                    }
                }
                hash.put(instance.id,instance);
            }
		}
	}
}
