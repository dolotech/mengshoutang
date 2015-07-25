package game.data
{
    import com.data.Data;
    import com.data.HashMap;

    import flash.utils.ByteArray;

    public class Attain extends Data
    {
        /**
         *类别
         */
        public var type:int;
        /**
         *图标
         */
        public var icon:String;
        /**
         *起始位置
         */
        public var start:int;
        /**
         *后续成绩
         */
        public var next:int;
        /**
         *任务类型
         */
        public var taskType:int;
        /**
         *成就描述
         */
        public var caption:String;

        /**
         *条件类型
         */
        public var conditionType:int;

        /**
         *奖励数量
         */
        public var values:int;
        /**
         *奖励物品类型
         */
        public var goodsType:int;

        public var quality:int;
        /**
         * 需要完成数量
         */
        public var condition:int;
        /**
         * 已经完成的数量
         */
        public var finish_num:int=-1;
        public var tollgate:String;

        public function get isFinish():Boolean
        {
            return condition == finish_num;
        }

        public static var hash:HashMap;

        public static function getListByType(type:int, tollgateId:int):Array
        {
            var tmp_arr:Array=[];
            var tmp_list:Array;
            hash.eachValue(eachValue);
            function eachValue(obj:Attain):void
            {
                if (obj.type == type)
                {
                    tmp_list=obj.tollgate.match(/\d+/gs);
                    if (tollgateId >= tmp_list[0] && tollgateId <= tmp_list[1])
                        tmp_arr.push(obj);
                }
            }
            return tmp_arr;
        }

        public static function init(data:ByteArray):void
        {
            hash=new HashMap();
            data.position=0;
            var vector:Array=data.readObject() as Array;
            var len:int=vector.length;

            for (var i:int=0; i < len; i++)
            {
                var obj:Object=vector[i];
                var instance:Attain=new Attain();

                for (var key:String in obj)
                {
                    instance[key]=obj[key];

                    if (key == "values")
                    {
                        if ((obj[key] as String).indexOf(",") != -1)
                        {
                            var str:String=((obj[key] as String).split(","))[0];
                            str=str.substr(1, str.length - 1);

                            instance[key]=int(str);
                            str=((obj[key] as String).split(","))[1]
                            str=str.substr(0, str.length - 2);
                            instance.quality=int(str);
                        }

                    }

                }
                hash.put(instance.id, instance);
            }

            createList();
        }
        /**
         *每组成就，通过 conditionType来拿取一组成就
         */
        public static var taskList:HashMap;

        public static var totals:int;

        //成就分组
        private static function createList():void
        {
            taskList=new HashMap();
            hash.eachValue(function(value:Attain):void
            {
                if (!taskList.getValue(value.conditionType))
                    taskList.put(value.conditionType, new Vector.<Attain>);
                taskList.getValue(value.conditionType).push(value);

                if (value.type != 6 && value.type != 7 && value.type != 8)
                    totals++;
            });
        }



    }
}
