package game.view.viewGuide
{
    import com.dialog.DialogMgr;
    import com.scene.BaseScene;
    import com.scene.SceneMgr;
    import com.utils.Constants;

    import flash.geom.Point;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;

    import game.common.JTSession;
    import game.data.ViewGuideData;
    import game.data.ViewGuideDataStep;
    import game.dialog.MsgDialog;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.uils.LocalShareManager;
    import game.view.PVP.JTPvpComponent;
    import game.view.new2Guide.data.NewDialogData;
    import game.view.new2Guide.view.NewGuideGirl;
    import game.view.new2Guide.view.NewGuideMask;
    import game.view.new2Guide.view.NewGuideStory;
    import game.view.viewGuide.interfaces.IViewGuideView;

    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Quad;
    import starling.events.Event;

    import treefortress.spriter.SpriterClip;


    /**
     * 功能引导
     * @author hyy
     *
     */
    public class ViewGuideManager
    {
        public static var instance:ViewGuideManager;
        public static var list_guide:Dictionary;
        public static var list_excute:Dictionary;
        /**
         * 是否正在对话
         */
        public static var isDialog:Boolean;

        public function ViewGuideManager()
        {
        }

        /**
         * 检测是否开启了功能引导
         *
         */
        public static function checkViewGuide():void
        {

//			var tollgateID:int=GameMgr.instance.tollgateID - 1;
//			var guide_list:Array=list_guide[tollgateID];
//			var isPass:int=LocalShareManager.getInstance().get("viewGuide" + tollgateID);
//			if (isPass == 0 && guide_list && guide_list.length > 0)
//			{
//				if (instance == null)
//				{
//					instance=new ViewGuideManager();
//					instance.init();
//				}
//				instance.start(guide_list)
//			}
//			else
//			{
            instance && instance.dispose();
//			}
        }

        public static function excuteGuide(id:int):void
        {
            var guide_list:Array=list_guide[id];
            var isPass:int=LocalShareManager.getInstance().get("viewGuide" + id);

//			if (isPass == 0 && guide_list && guide_list.length > 0)
//			{
//				if (instance == null)
//				{
//					instance=new ViewGuideManager();
//					instance.init();
//				}
//				instance.start(guide_list);
//			}
        }
        private var guide_list:Array;
        /**
         * 每一大步骤中得一步
         */
        private var cur_step:int;

        private var cur_stepArr:Array;
        /**
         * 遮罩
         */
        private var mask:NewGuideMask;
        /**
         * 反射
         */
        private var dic_className:Dictionary;
        /**
         * 当前容器
         */
        private var container:DisplayObjectContainer;

        /**
         * 当前新手场景
         */
        private var curr_scene:IViewGuideView;
        /**
         * 当前新手dialog
         */
        private var curr_view:IViewGuideView;
        /**
         * 手指动画
         */
        private var btn_finger:SpriterClip;
        /**
         * 对话列表
         */
        private var curr_Dialoglist:Array=[];
        private var curr_dialog:NewGuideStory;
        private var curr_girlDialog:NewGuideGirl;
        /**
         * 新手数据
         */
        private var viewGuideData:ViewGuideData;

        private function init():void
        {
            dic_className=new Dictionary();
            dic_className["CityFace"]="game.view.city";
            dic_className["BattleScene"]="game.scene";
            dic_className["TavernDialog"]="game.view.tavern";
            dic_className["MsgDialog"]="game.dialog";
            dic_className["JTPvpComponent"]="game.view.PVP";
            dic_className["ActivityDlg"]="game.view.activity";
            dic_className["BlacksmithDlg"]="game.view.newhero";
            dic_className["MagicOrb"]="game.view.magicorbs.Dlg";
            dic_className["ArenaCreateNameDlg"]="game.view.arena";
            dic_className["JTPvpComponent"]="game.view.PVP";

            container=JTSession.layerGuideGlobal;
            container.scaleX=container.scaleY=Constants.scale;
            container.touchable=true;

            mask=new NewGuideMask();

            btn_finger=AnimationCreator.instance.create("effect_bigfinger", AssetMgr.instance);
            btn_finger.play("zhiyin1");
            btn_finger.animation.looping=true;
            btn_finger.touchable=false;
            btn_finger.stop();

            curr_dialog=new NewGuideStory();
            curr_girlDialog=new NewGuideGirl();
        }

        private function start(tmp_list:Array):void
        {
            DialogMgr.instance.closeAllDialog();
            guide_list=[].concat(tmp_list);
            isDialog=false;
            next();
        }

        private function next():void
        {
            clear();

            //先实行每一步里面的分步骤
            if (cur_stepArr && cur_stepArr.length > 0)
            {
                if (curr_scene)
                    BaseScene(curr_scene).touchable=true;
                doStep(cur_stepArr.shift());
                return;
            }
            else if (guide_list.length == 0)
            {
                LocalShareManager.getInstance().save("viewGuide" + viewGuideData.tollgateId, 1);
                LocalShareManager.getInstance().flush();
                dispose();
                return;
            }

            viewGuideData=guide_list.shift();

            var dialogClass:Class;
            var sceneClass:Class=getClass(viewGuideData.scene.split(",")[0]);

            if (viewGuideData.view)
                dialogClass=getClass(viewGuideData.view.split(",")[0]);

            if (sceneClass != null && viewGuideData.scene != "BattleScene")
            {
                curr_scene=SceneMgr.instance.changeScene(sceneClass);
                BaseScene(curr_scene).touchable=false;
            }

            if (viewGuideData.view == "JTPvpComponent")
            {
                curr_view=JTPvpComponent.instance;
            }
            else if (dialogClass != null && viewGuideData.view != "MsgDialog")
            {
                var tmp_param:Object=null;

                if (viewGuideData.viewData)
                    tmp_param=[viewGuideData.viewData];

                curr_view=DialogMgr.instance.open(dialogClass, tmp_param) as IViewGuideView;
            }
            else
            {
                DialogMgr.instance.closeAllDialog();
            }

            cur_stepArr=[].concat(viewGuideData.viewParam);

            next();
        }

        private function doStep(tmpStepData:String):void
        {
            var param:ViewGuideDataStep=list_excute[tmpStepData];
            var view:IViewGuideView=viewGuideData.view != "" ? curr_view : curr_scene;

            //按钮指引
            if (param.guide != "")
                guideView(param);

            //对话
            if (param.dialog)
                createDialog(param.dialog.split("*"));

            //函数实行
            if (param.excute != "")
            {
                if (view != null)
                    view.executeViewGuideFun(param.excute);

                if (param.excute.indexOf("跳出提示") >= 0)
                {
                    curr_view=DialogMgr.instance.open(MsgDialog, param.excute.split(",").pop()) as IViewGuideView;
                    next();
                }
                //加载关卡不需要下一步，因为加载关卡完会自动实行,防止多步操作
                else if (param.excute.indexOf("加载关卡") == -1)
                    next();
            }

            /**
             * 指引按钮
             * @param view
             * @param name
             *
             */
            function guideView(param:ViewGuideDataStep):void
            {
                var guide_btn_name:String=param.guide.replace("nextFun", "");
                var child:DisplayObject=view.getViewGuideDisplay(guide_btn_name);


                if (child == null)
                {
                    trace("引导按钮找不到", guide_btn_name, view);
                    next();
                    return;
                }

                var tmp_width:int=0, tmp_height:int=0;
                var point:Point=child.localToGlobal(new Point());

                tmp_width=child.width;
                tmp_height=child.height;

                if (child is Button)
                {
                    child.addEventListener(Event.TRIGGERED, onBtnHandler);

                    function onBtnHandler():void
                    {
                        child.removeEventListener(Event.TRIGGERED, onBtnHandler);
                        endDialog();
                        Starling.juggler.delayCall(next, 0);
                    }
                }

                if (child is Quad)
                    child.removeFromParent(true);

                point.x=point.x / Constants.scale;
                point.y=point.y / Constants.scale;
                mask.setMaskRect(point.x, point.y, tmp_width, tmp_height);
                container.addChildAt(mask, 0);

                if (param.animation == "")
                {
                    btn_finger.x=point.x + tmp_width * .5;
                    btn_finger.y=point.y + tmp_height * .5;
                    container.addQuiackChild(btn_finger);
                    Starling.juggler.add(btn_finger);
                    btn_finger.play("zhiyin1");
                }
            }
        }

        /**
         * 开始创建对话
         * @param ids
         *
         */
        private function createDialog(ids:Array):void
        {
            isDialog=true;

            curr_Dialoglist.length=0;
            var key:String;

            for (var i:int=0, len:int=ids.length; i < len; i++)
            {
                key=ids[i];

                if (key == "jump")
                    curr_Dialoglist.push("jump");
                else
                    curr_Dialoglist.push(NewDialogData.list_dialog[key]);
            }
            nextDialog();
        }

        public function nextDialog():void
        {
            if (curr_Dialoglist.length == 0)
            {
                isDialog=false;
                return;
            }
            var data:*=curr_Dialoglist.shift();

            if (data == "jump")
            {
                endDialog();
                next();
                return;
            }
            var curr_newDialog:NewDialogData=data;

            //场景对话
            if (curr_newDialog.type == 1 && curr_dialog)
            {
                curr_dialog.data(curr_newDialog);
                curr_dialog.addChildAt(mask, 0);
                container.addChildAt(curr_dialog, 0);
            }
            //美女介绍
            else if (curr_girlDialog)
            {
                curr_girlDialog.data(curr_newDialog);
                curr_girlDialog.addChildAt(mask, 0);
                container.addChildAt(curr_girlDialog, 0);
            }
        }

        public function endDialog():void
        {
            if (curr_dialog)
                curr_dialog.removeFromParent();

            if (curr_girlDialog)
                curr_girlDialog.removeFromParent();
            isDialog=false;
        }

        public static function gotoNext():void
        {
            if (instance)
            {
                instance.endDialog();
                instance.next();
            }
        }

        private function clear():void
        {
            mask.setMaskRect(0, 0, 0, 0);
            mask.removeFromParent();

            if (btn_finger)
            {
                btn_finger.stop();
                Starling.juggler.remove(btn_finger);
                btn_finger.removeFromParent();
            }
        }


        private function getClass(name:String):Class
        {
            if (name == "")
                return null;
            return getDefinitionByName(dic_className[name] + "::" + name) as Class;
        }

        public function dispose():void
        {
            mask && mask.removeFromParent(true);
            mask=null;
            curr_girlDialog && curr_girlDialog.removeFromParent(true);
            curr_girlDialog=null;
            curr_dialog && curr_dialog.removeFromParent(true);
            curr_dialog=null;
            btn_finger && btn_finger.removeFromParent(true);
            btn_finger=null;
            endDialog();
            curr_scene=null;
            curr_view=null;
            container=null;
            instance=null;
        }
    }
}
