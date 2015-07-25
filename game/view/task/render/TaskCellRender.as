package game.view.task.render
{
    import com.utils.Constants;

    import feathers.controls.tree.TreeCellRenderer;
    import feathers.controls.tree.TreeEvent;

    import game.data.MainLineData;
    import game.data.TaskData;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.manager.HeroDataMgr;
    import game.manager.TaskDataMgr;

    import starling.display.Image;

    public class TaskCellRender extends TreeCellRenderer
    {
        private var typeIcon:Image=null;
        private var newIcon:Image=null;
        private var overIcon:Image=null;
        private var makeIcon:Image=null;

        public function TaskCellRender()
        {
            super();
        }

        override protected function drawData():void
        {
            super.drawData();
            if (hasParentNode)
            {
                var taskData:TaskData=TaskDataMgr.instance.hash.getValue(this.data.id);
                var taskTaype:String="";
                if (taskData.TaskType == TaskDataMgr.EPICTASK)
                {
                    taskTaype="ui_renwu_shishibiaoqian";
                }
                else if (taskData.TaskType == TaskDataMgr.MAINTASK)
                {
                    taskTaype="ui_renwu_zhuxianbiaoqian";
                }

                if (taskTaype != "")
                {
                    typeIcon=new Image(AssetMgr.instance.getTexture(taskTaype));
                    typeIcon.smoothing=Constants.smoothing;
                    typeIcon.touchable=false;
                    typeIcon.x=this.x + (this.width - typeIcon.width) >> 1;
                    addQuiackChild(typeIcon);
                }

                if (taskData.isNew && taskData.state == 0)
                {
                    newIcon=new Image(AssetMgr.instance.getTexture("ui_renwu_new1"));
                    newIcon.scaleX=0.7;
                    newIcon.scaleY=0.7;
                    newIcon.x=160;
                    newIcon.smoothing=Constants.smoothing;
                    newIcon.touchable=false;
                    addQuiackChild(newIcon);
                }
                if (taskData.state == 1)
                {

                    overIcon=new Image(AssetMgr.instance.getTexture("ui_yiwancheng"));
                    overIcon.scaleX=0.7;
                    overIcon.scaleY=0.7;
                    overIcon.smoothing=Constants.smoothing;
                    overIcon.touchable=false;
                    addQuiackChild(overIcon);
                }
                if (TaskDataMgr.instance.isMakeTask(taskData))
                {
                    makeIcon=new Image(AssetMgr.instance.getTexture("ui_kezhixing"));
                    makeIcon.smoothing=Constants.smoothing;
                    makeIcon.touchable=false;
                    makeIcon.scaleX=0.7;
                    makeIcon.scaleY=0.7;
                    addQuiackChild(makeIcon);
                }



            }

        }

        public function removeNewIcon():void
        {
            var taskData:TaskData=TaskDataMgr.instance.hash.getValue(this.data.id);
            taskData.isNew=false;
            newIcon && newIcon.removeFromParent(true);
        }

        public function selectItem():void
        {
            this.clickNode();
            this.dispatchEvent(new TreeEvent(TreeEvent.CLICK_NODE, this, true));
        }

        override public function dispose():void
        {
            typeIcon && typeIcon.removeFromParent(true);
            newIcon && newIcon.removeFromParent(true);
            overIcon && overIcon.removeFromParent(true);
            makeIcon && makeIcon.removeFromParent(true);
            super.dispose();
        }
    }
}


