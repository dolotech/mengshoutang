package game.manager
{
    import com.data.HashMap;
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.singleton.Singleton;

    import game.data.IconData;
    import game.data.MainLineData;
    import game.data.TaskData;
    import game.net.data.vo.TaskPlan;
    import game.view.comm.GetGoodsAwardEffectDia;

    /**
     *任务数据管理
     * @author Samuel
     *
     */
    public class TaskDataMgr
    {
        /**史诗*/
        public static const EPICTASK:uint=1;
        /**主线*/
        public static const MAINTASK:uint=2;
        /**支线*/
        public static const BRANCHTASK:uint=3;
        /**日常*/
        public static const DAYTASK:uint=4;
        /**特殊*/
        public static const SPECIALTASK:uint=5;

        /**记录任务类型*/
        public var currTaskType:uint=0;
        /**记录选中任务Id*/
        public var currTaskId:uint=0;

        /**现在有的任务数据*/
        public var hash:HashMap;

        public static function get instance():TaskDataMgr
        {
            return Singleton.getInstance(TaskDataMgr) as TaskDataMgr;
        }

        public function TaskDataMgr()
        {
            hash=new HashMap();

        }

        /**生成树要解析的xml数据*/
        public function getTaskDatas(list:Vector.<*>):XML
        {
            var tasks:Array=[];
            var vec1:Vector.<TaskData>=new Vector.<TaskData>;
            var vec2:Vector.<TaskData>=new Vector.<TaskData>;
            var vec3:Vector.<TaskData>=new Vector.<TaskData>;
            var vec4:Vector.<TaskData>=new Vector.<TaskData>;
            for each (var taskData:TaskData in list)
            {
                if (taskData.TaskType == EPICTASK || taskData.TaskType == MAINTASK)
                {
                    vec1.push(taskData);
                }
                else if (taskData.TaskType == BRANCHTASK)
                {
                    vec2.push(taskData);
                }
                else if (taskData.TaskType == DAYTASK)
                {
                    vec3.push(taskData);
                }
                else if (taskData.TaskType == SPECIALTASK)
                {
                    vec4.push(taskData);
                }
            }
            if (vec1.length > 0)
            {
                sortTask(vec1);
                tasks.push(vec1);
            }
            if (vec2.length > 0)
            {
                sortTask(vec2);
                tasks.push(vec2);
            }
            if (vec3.length > 0)
            {
                sortTask(vec3);
                tasks.push(vec3);
            }
            if (vec4.length > 0)
            {
                sortTask(vec4);
                tasks.push(vec4);
            }

            return taskXml(tasks);
        }

        /**排列任务 完成-是否可以做-id依次优先*/
        public function sortTask(vec:Vector.<TaskData>):void
        {
            if (vec.length > 0)
            {
                vec.sort(function(a:TaskData, b:TaskData):int
                {
                    if (a.TaskId < b.TaskId)
                    {
                        return -1;
                    }
                    else if (a.TaskId > b.TaskId)
                    {
                        return 1;
                    }
                    return 0;
                });

                vec.sort(function(a:TaskData, b:TaskData):int
                {
                    var bool1:Boolean=TaskDataMgr.instance.isMakeTask(a);
                    var bool2:Boolean=TaskDataMgr.instance.isMakeTask(b);
                    if (bool1 == true && bool2 == false)
                    {
                        return -1;
                    }
                    else if (bool1 == false && bool2 == true)
                    {
                        return 1;
                    }
                    return 0;
                });

                vec.sort(function(a:TaskData, b:TaskData):int
                {
                    if (a.state > b.state)
                    {
                        return -1;
                    }
                    else if (a.state < b.state)
                    {
                        return 1;
                    }
                    return 0;
                });


            }
        }

        /**
         *
         * @param taskDatas 数组里面存多个Vecto<TaskData>每个Vecto为一个父节点
         * @return xml
         *
         */
        public function taskXml(taskDatas:Array):XML
        {
            var nodes:String='';
            var ndodeVector:Vector.<TaskData>=null;
            var taskTata:TaskData=null;
            for (var i:int=0; i < taskDatas.length; i++)
            {
                ndodeVector=taskDatas[i];
                var len:int=ndodeVector.length;
                if (len > 0)
                {
                    taskTata=ndodeVector[0] as TaskData;
                    nodes+='<node id="' + taskTata.TaskType + '" label="' + taskTyeName(taskTata.TaskType) + '">';
                    for (var j:int=0; j < len; j++)
                    {
                        taskTata=ndodeVector[j] as TaskData;
                        nodes+='<node id="' + taskTata.TaskId + '" label="' + taskTata.TaskName + '"/>';
                    }
                    nodes+='</node>';
                }
            }
            var str:String='<node>' + nodes + '</node>';
            var xml:XML=new XML(str);
            return xml;
        }

        /**当前任务进度*/
        public function taskProgress(taskData:TaskData):int
        {
            var cProgress:int=0;
            for each (var taskPanl:TaskPlan in taskData.taskVector)
            {
                cProgress+=taskPanl.number;
            }
            return cProgress;
        }

        /**当前任务总进度*/
        public function totalProgress(taskData:TaskData):int
        {
            var tProgress:int=0;
            for each (var taskPanl:TaskPlan in taskData.TaskPlanVector)
            {
                tProgress+=taskPanl.number;
            }
            return tProgress;
        }

        /**获取任务名字*/
        public function taskTyeName(taskType:uint):String
        {
            var names:Array=Langue.getLans("task_type_name");
            switch (taskType)
            {
                case EPICTASK:
                case MAINTASK:
                    return names[0];
                case BRANCHTASK:
                    return names[1];
                case DAYTASK:
                    return names[2];
                case SPECIALTASK:
                    return names[3];
                default:
                    break;
            }
            return names[0];
        }

        /**播放获取奖励特效*/
        public function playAwardEffect():void
        {
            var dataVector:Vector.<IconData>=(hash.getValue(currTaskId) as TaskData).GetTaskRwad(false, true);
            var effectData:Object={vector: dataVector, effectPoint: null, effectName: "effect_036", effectSound: "baoxiangkaiqihuode", effectFrame: 299};
            DialogMgr.instance.open(GetGoodsAwardEffectDia, effectData, null, null, "translucence", 0x000000, 1);
        }

        /**
         * 根据关卡ID查找任务
         * @param id
         * @return
         *
         */
        public function taskDataByTollgateId(id:int):TaskData
        {
            var returnTask:TaskData;
            hash.eachValue(findTask)
            function findTask(taskData:TaskData):void
            {
                if (taskData.OperTaskChlidType == id)
                    returnTask=taskData
            }
            return returnTask;
        }

        /**
         * 判断任务是否可以做
         * @param taskData
         * @return
         */
        public function isMakeTask(taskData:TaskData):Boolean
        {
            var bool:Boolean=false;
            if (taskData.state == 0) //状态
            {
                bool=true; //可以做
                if (HeroDataMgr.instance.getHerosMaxLv() <= taskData.TaskLevel) //判断等级类型
                    bool=false;
                if (taskData.OperTaskType == 1) //判断战斗关卡类型
                {
                    var mainLineData:MainLineData=MainLineData.getPoint(taskData.OperTaskChlidType);
                    if (mainLineData)
                    {
                        if (mainLineData.isFb)
                        { //副本
                        }
                        else if (mainLineData.isNightMare)
                        { //噩梦

                        }
                        else if (mainLineData.isStory)
                        {

                        }
                        else
                        {
                            if (GameMgr.instance.tollgateID < mainLineData.pointID) //关卡不够
                                bool=false;
                        }
                    }
                    else //没辙关卡信息
                    {
                        bool=false;
                    }
                }
                else
                {
                    if (GameMgr.instance.tollgateID < taskData.TaskTollgate) //功能模块关卡不够
                        bool=false;
                }
            }
            return bool;
        }
    }
}
