package game.net.message
{
    import com.data.HashMap;
    import com.dialog.DialogMgr;
    import com.scene.SceneMgr;
    import com.view.base.event.EventType;

    import game.common.JTLogger;
    import game.data.TaskData;
    import game.manager.TaskDataMgr;
    import game.net.data.IData;
    import game.net.data.c.CGetTask;
    import game.net.data.c.CInitTask;
    import game.net.data.c.CPlatformShare;
    import game.net.data.s.SGetTask;
    import game.net.data.s.SInitTask;
    import game.net.data.s.SOpenTask;
    import game.net.data.s.SPlatformShare;
    import game.net.data.s.SSendTask;
    import game.net.data.s.SUpdateTask;
    import game.net.data.vo.TaskInfo;
    import game.net.data.vo.TaskPlan;
    import game.net.data.vo.TaskVal;
    import game.net.message.base.Message;
    import game.scene.BattleScene;
    import game.view.city.CityFace;
    import game.view.task.TaskDialog;

    /**
     * 任务信息接口
     * @author Samuel
     *
     */
    public class TaskMessage extends Message
    {

        private static var _isOpenTips:Boolean=false;
        private static var _isOverTips:Boolean=false;

        public function TaskMessage()
        {
            super();
        }

        override protected function addListenerHandler():void
        {
            this.addHandler(SInitTask.CMD, onInitTaskNotify);
            this.addHandler(SOpenTask.CMD, onOpenTaskNotify);
            this.addHandler(SSendTask.CMD, onSendTaskNotify);
            this.addHandler(SGetTask.CMD, onGetTaskNotify);
            this.addHandler(SUpdateTask.CMD, onUpdateTaskNotify);
            this.addHandler(SPlatformShare.CMD, onPlatformTaskNotify);
        }


        /**任务初始化*/
        private function onInitTaskNotify(info:SInitTask):void
        {
            TaskDataMgr.instance.hash=new HashMap(); //防止重新注册缓存还在
            var vect:Vector.<IData>=info.ids;
            var taskData:TaskData=null;
            var cloneData:TaskData=null;
            var taskInfo:TaskInfo=null;
            var taskPlan:TaskPlan=null;
            var numVect:Vector.<IData>=null;
            for (var i:int=0; i < vect.length; i++)
            {
                taskInfo=vect[i] as TaskInfo;
                taskData=TaskData.hash.getValue(taskInfo.id) as TaskData;
                numVect=taskInfo.num as Vector.<IData>;
                cloneData=taskData.clone() as TaskData;
                cloneData.taskVector=numVect;
                cloneData.state=taskInfo.state;
                TaskDataMgr.instance.hash.put(cloneData.TaskId, cloneData);
            }

        }

        /**开启任务*/
        private function onOpenTaskNotify(info:SOpenTask):void
        {
            JTLogger.debug("开启新任务" + info.id);
            var taskPlan:TaskPlan=null;
            var taskData:TaskData=TaskData.hash.getValue(info.id);
            var cloneData:TaskData=taskData.clone() as TaskData;
            cloneData.taskVector=new Vector.<IData>;
            for each (var tp:TaskPlan in cloneData.TaskPlanVector)
            {
                taskPlan=new TaskPlan();
                taskPlan.type=tp.type;
                taskPlan.number=0;
                cloneData.taskVector.push(taskPlan);
            }
            cloneData.isNew=true;
            TaskDataMgr.instance.hash.put(cloneData.TaskId, cloneData);
            this.dispatch(EventType.UPDATA_TASK_LIST);

        }


        /**检测显示是否有新任务开启*/
        public static function chenkOpenTipDialog():void
        {
            if (SceneMgr.instance.getCurScene() is BattleScene)
            {
                var bool:Boolean=false;
                //如果是战斗场景
                for each (var taskData:TaskData in TaskDataMgr.instance.hash.values())
                {
                    if (TaskDataMgr.instance.isMakeTask(taskData) && !taskData.isTips)
                    {
                        taskData.isTips=true;
                        bool=true;
                    }
                }
                if (bool)
                    DialogMgr.instance.open(TaskDialog);

            }

        }



        /**执行提示*/
        public function overTaskTips():void
        {
            if (SceneMgr.instance.getCurScene() is CityFace)
            {
                _isOverTips=false;
            }
            else
            { //如果是战斗场景
                _isOverTips=true;
            }


        }

        /**检测显示是否有完成的任务*/
        public static function chenkOverTipDialog():void
        {
            if (_isOverTips)
            {
                _isOverTips=false;
                var bool:Boolean=false;
                for each (var taskData:TaskData in TaskDataMgr.instance.hash.values())
                {
                    if (TaskDataMgr.instance.isMakeTask(taskData) && !taskData.isTips)
                    {
                        taskData.isTips=true;
                    }
                    if (taskData.state == 1)
                    {
                        bool=true;
                    }
                }
                if (bool)
                    DialogMgr.instance.open(TaskDialog);
            }
        }

        /**完成任务*/
        private function onSendTaskNotify(info:SSendTask):void
        {
            JTLogger.debug("完成任务" + info.id);
            var taskData:TaskData=TaskDataMgr.instance.hash.getValue(info.id);
            taskData.state=1;
            this.dispatch(EventType.UPDATA_TASK_LIST);
            if (!_isOverTips)
                overTaskTips();
        }

        /**领取任务返回*/
        private function onGetTaskNotify(info:SGetTask):void
        {
            switch (info.code)
            {
                case 0: //领取成功
                    TaskDataMgr.instance.playAwardEffect();
                    TaskDataMgr.instance.hash.remove(TaskDataMgr.instance.currTaskId);
                    TaskDataMgr.instance.currTaskType=0;
                    TaskDataMgr.instance.currTaskId=0;
                    this.dispatch(EventType.UPDATA_TASK_LIST);
                    break;
                case 1:
                    addTips("task_no_complete");
                    break;
                case 2: //任务已经领取（领取成功）
                    TaskDataMgr.instance.hash.remove(TaskDataMgr.instance.currTaskId);
                    TaskDataMgr.instance.currTaskType=0;
                    TaskDataMgr.instance.currTaskId=0;
                    this.dispatch(EventType.UPDATA_TASK_LIST);
                    break;
                case 3: //背包已满，物品已通过邮件发送
                    addTips("packFulls");
                    TaskDataMgr.instance.hash.remove(TaskDataMgr.instance.currTaskId);
                    TaskDataMgr.instance.currTaskType=0;
                    TaskDataMgr.instance.currTaskId=0;
                    this.dispatch(EventType.UPDATA_TASK_LIST);
                    break;
                default: //程序异常
                    addTips("proError");
                    break;
            }
        }

        /**更新任务进度*/
        private function onUpdateTaskNotify(info:SUpdateTask):void
        {
            var taskData:TaskData=TaskDataMgr.instance.hash.getValue(info.id) as TaskData;
            var tv:TaskVal=null;
            var taskPlan:TaskPlan=null;
            for (var i:int=0; i < info.num.length; i++)
            {
                tv=info.num[i] as TaskVal;
                taskPlan=taskData.taskVector[i] as TaskPlan;
                taskPlan.type=tv.type;
                taskPlan.number=tv.number;
            }
            this.dispatch(EventType.UPDATA_TASK_LIST);
        }

        /**更新直接操作的任务*/
        private function onPlatformTaskNotify(info:SPlatformShare):void
        {
            switch (info.code)
            {
                case 0:
                    (TaskDataMgr.instance.hash.getValue(TaskDataMgr.instance.currTaskId) as TaskData).state=1;
                    this.dispatch(EventType.UPDATA_TASK_LIST);
                    break;
                default:
                    addTips("proError");
                    break;
            }
        }

        /**请求任务数据列表*/
        public static function requestTask():void
        {
            TaskDataMgr.instance.currTaskId=0;
            TaskDataMgr.instance.currTaskType=0;
            var cmd:CInitTask=new CInitTask();
            sendMessage(cmd);
        }

        /**获取任务*/
        public static function getTask(taskId:int):void
        {
            var cmd:CGetTask=new CGetTask();
            cmd.id=taskId;
            sendMessage(cmd);
        }

        /**
         * 直接设置任务完成
         * specialId 1:factbook 2:weiChat
         * */
        public static function getSpecialTask(specialId:int):void
        {
            var cmd:CPlatformShare=new CPlatformShare();
            cmd.id=specialId;
            sendMessage(cmd);
        }
    }
}


