package game.view.task
{
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.scene.SceneMgr;
    import com.view.base.event.EventType;
    import com.view.base.event.ViewDispatcher;

    import feathers.controls.tree.TreeCellRendererVO;
    import feathers.controls.tree.TreeEvent;

    import game.base.BaseIcon;
    import game.common.JTFastBuyComponent;
    import game.common.JTGlobalDef;
    import game.common.JTLogger;
    import game.data.ConfigData;
    import game.data.IconData;
    import game.data.MainLineData;
    import game.data.MonsterData;
    import game.data.RoleShow;
    import game.data.TaskData;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.manager.HeroDataMgr;
    import game.manager.TaskDataMgr;
    import game.managers.JTFunctionManager;
    import game.net.data.vo.TaskPlan;
    import game.net.message.GameMessage;
    import game.net.message.GoodsMessage;
    import game.net.message.TaskMessage;
    import game.scene.world.NewFbScene;
    import game.view.achievement.Dlg.AchievementDlg;
    import game.view.activity.ActivityDlg;
    import game.view.blacksmith.BlacksmithDlg;
    import game.view.city.CityFace;
    import game.view.city.WelfareView;
    import game.view.email.EmailDlg;
    import game.view.heroHall.HeroDialog;
    import game.view.loginReward.Dla.LoginRewardDlg;
    import game.view.luckyStar.LuckyStarDlg;
    import game.view.magicorbs.MagicOrb;
    import game.view.notice.NoticeDlg;
    import game.view.pack.PackDlg;
    import game.view.picture.PictureView;
    import game.view.rank.JTRankListComponent;
    import game.view.shop.ShopDlg;
    import game.view.strategy.StrategyDlg;
    import game.view.task.render.TaskCellRender;
    import game.view.task.view.TaskTree;
    import game.view.tavern.TavernDialog;
    import game.view.viewBase.TaskDialogBase;
    import game.view.vip.VipDlg;
    import game.view.vip.VipRewardDlg;

    import starling.core.Starling;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.utils.HAlign;

    import treefortress.spriter.SpriterClip;

    /**
     * 任务系统模块
     * @author Samuel
     *
     */
    public class TaskDialog extends TaskDialogBase
    {
        /**任务列表*/
        private var _tree:TaskTree=null;
        /**当前选中节点*/
        private var _taskCellRender:TaskCellRender=null;
        /**任务宝箱*/
        private var _effectSp:SpriterClip=null;



        public function TaskDialog()
        {
            super();
            _closeButton=closeBtn;
        }

        /**初始化*/
        override protected function init():void
        {
            enableTween=true;
            isVisible=false;
            _tree=new TaskTree();
            _tree.itemRenderer=TaskCellRender;
            _tree.x=14;
            _tree.y=120;
            _tree.width=240;
            _tree.height=420;
            _tree.addEventListener(TreeEvent.CLICK_NODE, onClickTreeNode);
            this.addChild(_tree);
            isVisible=true;
            taskPass.visible=false;

            if (_effectSp)
                _effectSp.visible=false;
            this.taskContent.text="";
            this.operBtnTxt.text="";
            this.taskButton.touchable=false;

            clickBackroundClose();

        }

        /**初始化监听*/
        override protected function addListenerHandler():void
        {
            super.addListenerHandler();
            addViewListener(taskButton, Event.TRIGGERED, makeTaskHandler);
            addContextListener(EventType.UPDATA_TASK_LIST, onUpdataTaskList);
        }

        private function onUpdataTaskList(evt:Event):void
        {
            taskPass.visible=false;
            if (_effectSp)
                _effectSp.visible=false;
            this.taskContent.text="";
            this.operBtnTxt.text="";
            this.taskButton.touchable=false;
            _tree.dataProvider=TaskDataMgr.instance.getTaskDatas(TaskDataMgr.instance.hash.values());
            openTweenComplete();
        }

        /**显示到舞台*/
        override protected function show():void
        {
            setToCenter();
            _tree.dataProvider=TaskDataMgr.instance.getTaskDatas(TaskDataMgr.instance.hash.values());
            JTFunctionManager.executeFunction(JTGlobalDef.STOP_CITY_ANIMATABLE);

        }

        private function getBoxHandler(e:TouchEvent):void
        {

            var touch:Touch=e.getTouch(stage);
            if (touch == null)
                return;
            switch (touch.phase)
            {
                case TouchPhase.BEGAN:
                    if (_taskCellRender != null)
                    {
                        var treeData:TreeCellRendererVO=_taskCellRender.data;
                        var taskData:TaskData=TaskDataMgr.instance.hash.getValue(treeData.id);
                        if (taskData.state == 1)
                        {
                            TaskMessage.getTask(taskData.TaskId);
                        }
                    }
                    break;
            }


        }

        /**缓动结束*/
        override protected function openTweenComplete():void
        {

            if (TaskDataMgr.instance.currTaskType == 0 && TaskDataMgr.instance.currTaskId == 0)
            {
                _tree.openAllNodes();
                _tree.selectOneNode();
            }
            else
            {
                _tree.openAllNodes();
                _tree.selectChildNode(TaskDataMgr.instance.currTaskId);
            }

        }


        /**选中节点*/
        private function onClickTreeNode(e:TreeEvent):void
        {
            var cellTree:TaskCellRender=e.target as TaskCellRender;
            if (cellTree.data.hasParentNodes)
            {
                var taskData:TaskData=TaskDataMgr.instance.hash.getValue(cellTree.data.id);
                updataTaskUI(taskData);
                _taskCellRender=cellTree;
                _taskCellRender.removeNewIcon();
                TaskDataMgr.instance.currTaskType=taskData.TaskType;
                TaskDataMgr.instance.currTaskId=taskData.TaskId;
            }
            else
            {
//                if (cellTree.isOpen())
//                {
//                    _tree.scrollToPosition(0, cellTree.y, 1); //将选中的置位置0
//                }
//                else
//                {
//                    _tree.scrollToPosition(0, 0, 1);
//                }
            }
        }

        /**更新taskUI列表*/
        protected function updataTaskUI(taskData:TaskData):void
        {
            _effectSp && _effectSp.removeFromParent();
            Starling.juggler.remove(_effectSp);
            _effectSp=null;
            this.taskPass.visible=true;
            this.taskButton.touchable=true;
            this.taskContent.text=taskData.TaskDes;
            if (taskData.state == 1)
            {
                this.operBtnTxt.color=0x00ff00;
                this.operBtnTxt.text=Langue.getLangue("okUse"); //可领取
                if (_effectSp == null)
                {
                    _effectSp=AnimationCreator.instance.create("effect_036", AssetMgr.instance);
                    addQuiackChild(_effectSp);
                    _effectSp.play("round"); //effect_036 round out open; 
                    _effectSp.animation.looping=true;
                    _effectSp.animation.id=1;
                    _effectSp.touchable=true;
                    _effectSp.x=725;
                    _effectSp.y=435;
                    _effectSp.visible=true;
                    Starling.juggler.add(_effectSp);
                    setChildIndex(_effectSp, this.numChildren - 1);
                    _effectSp.addEventListener(TouchEvent.TOUCH, getBoxHandler);

                }

            }
            else
            {
                this.operBtnTxt.color=0xffffff;
                this.taskPass.visible=false;
                this.operBtnTxt.text=Langue.getLangue("goto") + "(" + (TaskDataMgr.instance.taskProgress(taskData) + "/" + TaskDataMgr.instance.totalProgress(taskData)) + ")";

            }
            updataTarget(taskData);
            updataRawd(taskData);

        }


        /**获取数据集*/
        private function updataRawd(taskData:TaskData):void
        {

            var vect:Vector.<IconData>=taskData.GetTaskRwad(true, false);
            var len:uint=vect.length;
            var baseIcon:BaseIcon=null;
            var iconData:IconData=null;
            for (var i:uint=0; i < 3; i++)
            {
                iconData=i < len ? vect[i] : null;
                if (iconData)
                {
                    baseIcon=this.getChildByName("baseIcon_" + i) as BaseIcon;
                    if (baseIcon == null)
                    {
                        baseIcon=new BaseIcon(iconData);
                        baseIcon.name="baseIcon_" + i;
                        baseIcon.scaleX=0.8;
                        baseIcon.scaleY=0.8;
                        baseIcon.x=i * 80 + 430;
                        baseIcon.y=396;
                        baseIcon.text_Num.hAlign=HAlign.RIGHT;
                        baseIcon.text_Num.x=-22;
                        addQuiackChild(baseIcon);
                    }
                    else
                    {
                        baseIcon.updata(iconData);
                        baseIcon.text_Num.x=-22;
                    }

                }
                else
                {
                    baseIcon=this.getChildByName("baseIcon_" + i) as BaseIcon;
                    baseIcon && baseIcon.removeFromParent(true);
                }
            }

        }


        /**更新任务目标*/
        /**
         *
         * @param tastData
         *
         */
        private function updataTarget(tastData:TaskData):void
        {
            var iconData:IconData=null;
            var mainLineData:MainLineData=null;
            var monsterData:MonsterData=null;
            var taskPlan:TaskPlan=null;
            var roleShow:RoleShow=null;
            var vectorData:Vector.<IconData>=new Vector.<IconData>;
            switch (tastData.TaskTarget)
            {
                case 1: //关卡目标
                    for each (taskPlan in tastData.TaskPlanVector)
                    {
                        iconData=new IconData();
                        mainLineData=MainLineData.getPoint(taskPlan.type);
                        iconData.GroundTrue="";
                        iconData.Num="x " + taskPlan.number.toString();
                        //iconData.QualityTrue="ui_zhuxian_boss_wenhao";
                        iconData.IconTrue=mainLineData.points_ico;
                        vectorData.push(iconData);

                    }
                    break;
                case 2: //怪物目标
                    for each (taskPlan in tastData.TaskPlanVector)
                    {
                        iconData=new IconData();
                        monsterData=MonsterData.monster.getValue(taskPlan.type);
                        roleShow=RoleShow.hash.getValue(monsterData.show) as RoleShow;
                        iconData.Num="x " + taskPlan.number.toString();
                        iconData.QualityTrue="ui_gongyong_100yingxiongkuang_1";
                        iconData.IconTrue=roleShow.photo;
                        vectorData.push(iconData);
                    }
                    break;
                default: //其他目标
                    break;

            }

            var baseIcon:BaseIcon=null;
            var len:uint=vectorData.length;
            taskMb.visible=len;
            for (var i:uint=0; i < 3; i++)
            {
                iconData=i < len ? vectorData[i] : null;

                baseIcon=this.getChildByName("baseIconTarget_" + i) as BaseIcon;
                baseIcon && baseIcon.removeFromParent(true);
                baseIcon=null;
                if (baseIcon == null && iconData)
                {
                    baseIcon=new BaseIcon(iconData);
                    baseIcon.name="baseIconTarget_" + i;
                    baseIcon.x=i * 80 + 430;
                    baseIcon.y=300;
                    addQuiackChild(baseIcon);
                    baseIcon.scaleX=0.7;
                    baseIcon.scaleY=0.7;
                    baseIcon.text_Num.x=-15;
                    baseIcon.text_Num.hAlign=HAlign.RIGHT;
                }

            }

        }


        /**去做任务*/
        private function makeTaskHandler(e:Event):void
        {
            if (_taskCellRender != null)
            {
                var treeData:TreeCellRendererVO=_taskCellRender.data;
                var taskData:TaskData=TaskDataMgr.instance.hash.getValue(treeData.id);
                if (taskData.state == 1)
                {
                    TaskMessage.getTask(taskData.TaskId);
                    return;
                }


                if (taskData.OperTaskType == 1)
                { //主线 或者关卡
                    if (taskData.OperTaskChlidType > 0)
                    {
                        if (HeroDataMgr.instance.getHerosMaxLv() <= taskData.TaskLevel)
                        {
                            addTips(Langue.getLangue("task_leve_show").replace("*", taskData.TaskLevel));
                            return;
                        }

                        var mainLineData:MainLineData=MainLineData.getPoint(taskData.OperTaskChlidType);
                        var battleType:uint=0;
                        if (mainLineData.isFb)
                        { //副本
                            battleType=2;
                        }
                        else if (mainLineData.isNightMare)
                        { //噩梦

                        }
                        else if (mainLineData.isStory)
                        {

                        }
                        else
                        {
                            battleType=0; //主线
                            if (GameMgr.instance.tollgateID < mainLineData.pointID)
                            {
                                addTips(Langue.getLangue("task_tollgate_show").replace("*", mainLineData.pointID));
                                return;
                            }
                        }

                        if (SceneMgr.instance.isScene(CityFace))
                        {
                            GameMessage.gotoTollgateData(taskData.OperTaskChlidType, DialogMgr.instance.currScene, DialogMgr.instance.currDialogs, DialogMgr.instance.currDialogParams);
                        }
                        else
                        {
                            GameMessage.gotoTollgateData(taskData.OperTaskChlidType);
                        }

                        close();
                    }
                    return;
                }

                if (GameMgr.instance.tollgateID < taskData.TaskTollgate) //功能模块关卡不够
                {
                    addTips(Langue.getLangue("task_tollgate_show").replace("*", taskData.TaskTollgate));
                    return;
                }
                var dialogMgr:DialogMgr=DialogMgr.instance;
                switch (taskData.OperTaskType)
                {
                    case 1: //主线 或者关卡
                        break;
                    case 2: //装备模块
                        dialogMgr.open(BlacksmithDlg, [taskData.OperTaskChlidType]);
                        break;
                    case 3: //英雄模块
                        dialogMgr.open(HeroDialog, taskData.OperTaskChlidType);
                        break;
                    case 4: //酒馆模块
                        dialogMgr.open(TavernDialog, taskData.OperTaskChlidType);
                        break;
                    case 5: //宝珠模块
                        dialogMgr.open(MagicOrb, [taskData.OperTaskChlidType]);
                        break;
                    case 6: //商店模块
                        dialogMgr.open(ShopDlg, [taskData.OperTaskChlidType]);
                        break;
                    case 7: //试练
                        SceneMgr.instance.changeScene(NewFbScene);
                        break;
                    case 8: //角斗场
                        ViewDispatcher.dispatch(EventType.OPEN_ARENA);
                        break;
                    case 9: //排行
                        JTRankListComponent.open();
                        break;
                    case 10: //公会
                        JTLogger.debug("公会");
                        break;
                    case 11: //购买钻石&VIP
                        dialogMgr.open(VipRewardDlg);
                        break;
                    case 12: //购买金币
                        dialogMgr.open(JTFastBuyComponent, JTFastBuyComponent.FAST_BUY_MONEY);
                        break;
                    case 13: //购买疲劳
                        GoodsMessage.onBuyTiredClick();
                        break;
                    case 14: //小助手模块
                        dialogMgr.open(StrategyDlg, [taskData.OperTaskChlidType]);
                        break;
                    case 15: //邮件
                        dialogMgr.open(EmailDlg);
                        break;
                    case 16: //聊天
                        JTFunctionManager.executeFunction(JTGlobalDef.MIN_SWITCHOVER_MAX);
                        break;
                    case 17: //公告
                        dialogMgr.open(NoticeDlg);
                        break;
                    case 18: //福利
                        dialogMgr.open(WelfareView);
                        break;
                    case 19: //图鉴
                        dialogMgr.open(PictureView);
                        break;
                    case 20: //背包
                        dialogMgr.open(PackDlg, [taskData.OperTaskChlidType]);
                        break;
                    case 21: //成就
                        dialogMgr.open(AchievementDlg);
                        break;
                    case 22: //活动模块
                        DialogMgr.instance.open(ActivityDlg, [taskData.OperTaskChlidType]);
                        break;
                    case 23: //幸运星
                        DialogMgr.instance.open(LuckyStarDlg);
                        break;
                    case 24: //每日VIP礼包
                        DialogMgr.instance.open(VipRewardDlg);
                        break;
                    case 25: //月卡
                        DialogMgr.instance.open(VipDlg, taskData.OperTaskChlidType);
                        break;
                    case 26: //签到
                        dialogMgr.open(LoginRewardDlg);
                        break;
                    case 27: //跳转facebook
                        ViewDispatcher.dispatch(EventType.GOTO_WEB, ConfigData.instance.facebook_url);
                        TaskMessage.getSpecialTask(1);
                        break;
                    default:
                        JTLogger.debug("没有对应的操作类型");
                        break;
                }
            }

        }

        /**关闭*/
        override public function close():void
        {
            JTFunctionManager.executeFunction(JTGlobalDef.PLAY_CITY_ANIMATABLE);
            super.close();
        }

        /**销毁*/
        override public function dispose():void
        {
            if (_effectSp)
            {
                _effectSp.stop();
                Starling.juggler.remove(_effectSp);
                _effectSp.removeFromParent();
            }
            super.dispose();
        }

    }
}


