package game.view.city {
    import com.components.RollTips;
    import com.dialog.Dialog;
    import com.dialog.DialogMgr;
    import com.dialog.IDialog;
    import com.langue.Langue;
    import com.scene.BaseScene;
    import com.scene.SceneMgr;
    import com.sound.SoundManager;
    import com.utils.Constants;
    import com.utils.ObjectUtil;
    import com.view.base.event.EventType;

    import game.common.JTGlobalDef;
    import game.data.Val;
    import game.dialog.ShowLoader;
    import game.manager.GameMgr;
    import game.managers.JTFunctionManager;
    import game.managers.JTSingleManager;
    import game.net.data.c.CAttain_init;
    import game.net.message.GameMessage;
    import game.scene.world.NewFbScene;
    import game.scene.world.NewMainWorld;
    import game.view.PVP.JTPvpComponent;
    import game.view.achievement.data.AchievementData;
    import game.view.arena.ArenaCreateNameDlg;
    import game.view.blacksmith.BlacksmithDlg;
    import game.view.chat.component.JTChatControllerComponent;
    import game.view.chat.component.JTMessageSystemComponent;
    import game.view.dispark.DisparkControl;
    import game.view.dispark.data.ConfigDisparkStep;
    import game.view.heroHall.HeroDialog;
    import game.view.luckyStar.LuckyStarDlg;
    import game.view.magicorbs.MagicOrb;
    import game.view.new2Guide.NewGuide2Manager;
    import game.view.rank.JTRankListComponent;
    import game.view.shop.ShopDlg;
    import game.view.tavern.TavernDialog;
    import game.view.viewGuide.ViewGuideManager;

    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.DisplayObject;
    import starling.events.Event;

    /**
     * 游戏大厅
     */
    public class CityFace extends BaseScene {
        private var _scroller:DragScrollManager;
        public var icon:CityIcon;
        private var _container1:HouseContainer;

        override protected function addListenerHandler():void {
            JTFunctionManager.registerFunction(JTGlobalDef.STOP_CITY_ANIMATABLE, onStopAnimatable);
            JTFunctionManager.registerFunction(JTGlobalDef.PLAY_CITY_ANIMATABLE, onPlayAnimatable);
            JTFunctionManager.registerFunction(JTGlobalDef.SHOW_CHAT_PANEL, onShowChatPanelHandler);
            this.addContextListener(CityIcon.CREATE_DIALOG, createDialog);
            this.addContextListener(EventType.OPEN_ARENA, onPvp);
        }

        private function createDialog(evt:Event, obj:Object):void {
            openAssignDialog(obj.cls, obj.data);
            onStopAnimatable();
        }

        private var _animationList:Array = [];

        private function onPlayAnimatable():void {
            this.visible = true;
            ObjectUtil.resumeAnimation(_animationList);
        }

        private function onStopAnimatable(visible:Boolean = true):void {
            this.visible = visible;
            ObjectUtil.stopAnimation(_animationList, this);
        }

        private function onShowChatPanelHandler():void {
            JTChatControllerComponent.open(this);
        }

        override public function dispose():void {
            JTFunctionManager.removeFunction(JTGlobalDef.STOP_CITY_ANIMATABLE, onStopAnimatable);
            JTFunctionManager.removeFunction(JTGlobalDef.PLAY_CITY_ANIMATABLE, onPlayAnimatable);
            JTFunctionManager.removeFunction(JTGlobalDef.SHOW_CHAT_PANEL, onShowChatPanelHandler);
            JTChatControllerComponent.close();
            _scroller.dispose();
            SoundManager.instance.stopAllSounds();
            SoundManager.instance.tweenVolumeSmall("city_bgm", 0.0, 1);
            super.dispose();
        }

        private function onTouch(sp:String):void {
            if (!touchable)
                return;

            switch (sp) {
                case "effcet_mainline_house":
                    onExpedition();
                    break;
                case "effcet_shop_house":
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep11)) //商店功能是否开启
                        return;
                    openAssignDialog(ShopDlg);
                    onStopAnimatable(false);
                    break;
                case "effcet_magicball_house":
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep14)) //宝珠功能是否开启
                        return;
                    openAssignDialog(MagicOrb);
                    DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep14);
                    onStopAnimatable(false);
                    break;
                case "effcet_hero_house":
                    onHeroHall();
                    break;
                case "effcet_tavern_house":
//                    if (GameMgr.instance.tollgateID <= ConfigData.instance.tavernGuide) {
//                        RollTips.addNoOpenInfo(ConfigData.instance.tavernGuide);
//                        return;
//                    }
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep3)) //酒馆功能是否开启
                        return;
                    openAssignDialog(TavernDialog);
                    onStopAnimatable(false);
                    break;
                case "effcet_transcript_house":
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep8)) //试练 副本功能是否开启
                        return;
                    SceneMgr.instance.changeScene(NewFbScene);
                    break;
                case "effcet_hecheng":
                    openAssignDialog(BlacksmithDlg);
                    onStopAnimatable(false);
                    break;
                case "effcet_pvp_house":
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep7)) //角斗场能是否开启
                        return;
                    onPvp();
                    break;
                case "effcet_society_house":
                    RollTips.add(Langue.getLangue("functionWait"));
                    break;
                case "effcet_lion_house":
                    JTRankListComponent.open();
                    onStopAnimatable(false);
                    JTRankListComponent.instance.onClose.addOnce(function(obj:Object):void {
                        onPlayAnimatable()
                    });
                    break;
                default:
                    break;

            }
        }

        /**
         * 新手引导
         */
        public static var isNewGuideInit:Boolean;
        /**
         * 功能引导
         */
        public static var isViewGuideInit:Boolean;


        private function openAssignDialog(ClassName:Class, parameter:Object = null, okFun:Function = null, cancelFun:Function = null,
                                          mode:String = Dialog.OPEN_MODE_TRANSLUCENCE, color:uint = 0x000000, al:Number = 0.5,
                                          isHiddenBg:Boolean = true):void {
            var dlg:IDialog = DialogMgr.instance.open(ClassName, parameter, okFun, cancelFun, mode, color, al);
            (dlg as DisplayObject).addEventListener(Dialog.CLOSE_CONTAINER, onCloseHandler);
        }

        /**
         *英雄大厅
         *
         */
        private function onHeroHall(e:Event = null):void {
            //openAssignDialog(HeroDlg);
            openAssignDialog(HeroDialog);
            onStopAnimatable(false);
        }

        /**
         *聊天界面
         *
         */
        private function addChat():void {
            JTChatControllerComponent.open(this);
        }

        /**
         *
         * 进入关卡选择界面
         *
         */
        public function onExpedition(e:Event = null):void {

            DialogMgr.instance.closeAllDialog();
            SceneMgr.instance.changeScene(NewMainWorld);
            //检查功能开放
            DisparkControl.instance.checkMajorOpen();
        }

        /**
         *幸运星
         *
         */
        private function onProclamation(e:Event = null):void {
            if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep5)) //幸运星功能是否开启
                return;
            openAssignDialog(LuckyStarDlg);
            onStopAnimatable(false);
        }

        private function onCloseHandler(e:Event):void {
            var dlg:DisplayObject = e.currentTarget as DisplayObject;
            dlg.removeEventListener(Dialog.CLOSE_CONTAINER, onCloseHandler);
            onPlayAnimatable();
        }

        /**
         *pvp
         *
         */
        private function onPvp(event:Event = null, value:String = Val.DROP_PVP):void {

            if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep7)) {
                return;
            }
            if (GameMgr.instance.arenaname == "" || GameMgr.instance.arenaname == null)
                //创建玩家名字
            {
                openAssignDialog(ArenaCreateNameDlg, false);
                onStopAnimatable();
            } else {
                JTPvpComponent.open(value);
                onStopAnimatable(false);
                JTPvpComponent.instance.onClose.addOnce(function(obj:Object):void {
                    onPlayAnimatable()
                });
            }


        }

        /**
         *公会
         *
         */
        private function onGild(e:Event = null):void {
            RollTips.add(Langue.getLangue("functionWait"));
        }

        override protected function show():void {
            if (!isNewGuideInit) {
                sendMessage(new CAttain_init());
                isNewGuideInit = true;
                NewGuide2Manager.start();
            }

            if (!isViewGuideInit) {
                isViewGuideInit = true;
                ViewGuideManager.checkViewGuide();
            }

            JTMessageSystemComponent.checkMsg();
            DisparkControl.instance.checkMajorOpen();
        }

        override protected function init():void {
            var singleManager:JTSingleManager = JTSingleManager.instance;
            singleManager.tollgateInfoManager.current_TollgateID = GameMgr.instance.tollgateprize;
            AchievementData.instance;
            _scroller = new DragScrollManager();

            _container1 = new HouseContainer(onTouch);
            addChild(_container1);

            _scroller.createSroll(_container1);
            _scroller.setPosition(Constants.virtualWidth - _container1.width + _scroller.limitOffset);
            _container1.arrow_startX = Constants.virtualWidth - _container1.width + _scroller.limitOffset + (_container1.width - (Constants.standardWidth + 720) - 70);
            icon = new CityIcon();
            addChild(icon);

            SoundManager.instance.playSound("city_bgm", true, 0, 99999);
            SoundManager.instance.tweenVolume("city_bgm", 1.0, 2);

            Starling.juggler.add(this);
            JTSingleManager.initialize();
            addChat(); //添加聊天
            ShowLoader.remove();
        }

        /**
         * 新手引导
         * @param name
         * @return
         *
         */
        override public function getGuideDisplay(name:String):* {
            switch (name) {
                case "下拉列表":
                    return icon;
                    break;
                case "福利":
                    _container1.touchable = false;
                    return icon.btn_welfare;
                    break;
                case "主线按钮":
                    _container1.touchable = false;
                    return super.getGuideDisplay("icon,btn_main");
                    break;
                case "签到按钮":
                    return WelfareView(DialogMgr.instance.getDlg(WelfareView)).btn_sign;
                    break;
                case "英雄之家":
                    var effcet_hero_house:House = getHouseByName("effcet_hero_house");
                    effcet_hero_house.onClick.addOnce(gotoNext);
                    _scroller.setPosition(-600);
                    function gotoNext():void {
                        NewGuide2Manager.gotoNext();
                    }
                    return effcet_hero_house;
                    break;
                case "成就按钮":
                    return WelfareView(DialogMgr.instance.getDlg(WelfareView)).btn_reward;
                    break;
                case "背包按钮":
                    return icon.btn_bag
                    break;
                default:
                    break;
            }
            return null;
        }


        /**
         * 新手引导专用函数
         * @param id
         * type 1 转换场景
         * type 2加载场景
         */
        override public function executeGuideFun(name:String):void {
            if (name.indexOf("加载关卡") >= 0)
                GameMessage.gotoTollgateData(int(name.split(",")[1]));
        }

        /**
         * 功能引导
         * @param name
         * @return
         *
         */
        override public function getViewGuideDisplay(name:String):* {
            switch (name) {
                case "宝珠商店":
                    var effcet_magicball_house:House = getHouseByName("effcet_magicball_house");
                    effcet_magicball_house.onClick.addOnce(gotoNext);
                    icon.touchable = false;
                    return effcet_magicball_house;
                    break;
                case "英雄酒馆":
                    var effcet_tavern_house:House = getHouseByName("effcet_tavern_house");
                    if (effcet_tavern_house == null)
                        return null;
                    icon.touchable = false;
                    effcet_tavern_house.onClick.addOnce(gotoNext);
                    return effcet_tavern_house;
                    break;
                case "活动按钮":
                    return icon.btn_welfare;
                    break;
                case "铁匠铺":
                    var effcet_hecheng:House = getHouseByName("effcet_hecheng");
                    if (effcet_hecheng == null)
                        return null;
                    icon.touchable = false;
                    effcet_hecheng.onClick.addOnce(gotoNext);
                    _scroller.setPosition(-100);
                    return effcet_hecheng;
                    break;
                case "竞技场":
                    var effcet_pvp_house:HouseImage = _container1.getChildByName("effcet_pvp_house") as HouseImage;
                    if (effcet_pvp_house == null)
                        return null;
                    icon.touchable = false;
                    effcet_pvp_house.onClick.addOnce(gotoNext);
                    return effcet_pvp_house;
                    break;
            }

            function gotoNext():void {
                getHouseByName("effcet_hero_house").touchable = true;
                ViewGuideManager.gotoNext();
            }
        }

        public function getHouseByName(name:String):House {
            return _container1.getChildByName(name) as House;
        }

        override protected function guideBtnClick(btn:Button):void {
        }
    }
}
