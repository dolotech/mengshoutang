package game.scene {
    import com.cache.Pool;
    import com.data.Data;
    import com.dialog.Dialog;
    import com.dialog.DialogMgr;
    import com.scene.BaseScene;
    import com.scene.SceneMgr;
    import com.sound.SoundManager;
    import com.utils.Constants;
    import com.view.base.event.EventType;

    import flash.geom.Point;
    import flash.system.System;

    import game.common.JTGlobalDef;
    import game.common.JTSession;
    import game.data.Goods;
    import game.data.HeroData;
    import game.data.MainLineData;
    import game.data.StoryConfigData;
    import game.data.TollgateData;
    import game.data.WidgetData;
    import game.dialog.ShowLoader;
    import game.fight.Position;
    import game.hero.AnimationCreator;
    import game.hero.BattleDriver;
    import game.hero.Hero;
    import game.manager.AssetMgr;
    import game.manager.BattleAssets;
    import game.manager.BattleHeroMgr;
    import game.manager.CommandSet;
    import game.manager.GameMgr;
    import game.manager.HeroDataMgr;
    import game.managers.JTFunctionManager;
    import game.managers.JTPvpInfoManager;
    import game.managers.JTSingleManager;
    import game.net.data.IData;
    import game.net.data.c.CBattle;
    import game.net.data.s.SBattle;
    import game.net.data.s.SColiseumPrizeSend;
    import game.net.data.s.SVideoInfo;
    import game.net.data.vo.BattleTarget;
    import game.net.data.vo.BattleVo;
    import game.net.data.vo.EquipVOS;
    import game.net.data.vo.battleHeroesVo;
    import game.net.data.vo.videoDataInfo;
    import game.net.data.vo.videoHeroes;
    import game.net.data.vo.videoVo;
    import game.net.message.GameMessage;
    import game.scene.world.NewFbScene;
    import game.scene.world.NewMainWorld;
    import game.view.PVP.JTPvpComponent;
    import game.view.arena.ArenaDareData;
    import game.view.arena.ArenaDlg;
    import game.view.battle.BattleUI;
    import game.view.battle.VSEntify;
    import game.view.city.CityFace;
    import game.view.embattle.EmBattleDlg;
    import game.view.fb.FbData;
    import game.view.gameover.WinView;

    import sdk.DataEyeManger;

    import starling.display.BlendMode;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.Texture;

    import treefortress.spriter.SpriterClip;

    /**
     * 战斗场景
     * @author Michael
     *
     */
    public class BattleScene extends BaseScene {
        /**
         *
         * @default
         */
        private var _driver:BattleDriver;
        private var _battleUI:BattleUI;
        private var _bgLayer:Sprite;
        private var _roleLayer:Sprite;
        private var _effectLayer:Sprite;
        private var _powerSkillLayer:Sprite;
        private var _uiLayerLayer:Sprite;
        /**
         * 0关卡2副本3PVP
         */
        private var tollgate_type:int;
        /**
         * 对手ID
         */
        private var enemy_id:int;

        /**
         * 关卡信息
         */
        private var tollgateData:TollgateData;
        private var isTweening:Boolean;
        private var isReturnMsg:Boolean;
        private var bossAnimation:SpriterClip;
        private var bossSeatAnimation:SpriterClip;

        public function BattleScene() {
            _driver = new BattleDriver(this);
            super();
        }

        public function get battleUI():BattleUI {
            return _battleUI;
        }

        /**
         *
         * @param container
         */
        override protected function init():void {
            _bgLayer = new Sprite();
            _roleLayer = new Sprite();
            _effectLayer = new Sprite();
            _uiLayerLayer = new Sprite();
            _powerSkillLayer = new Sprite();
            this.addChild(_bgLayer);
            this.addChild(_roleLayer);
            this.addChild(_powerSkillLayer);
            this.addChild(_uiLayerLayer);
            this.addChild(_effectLayer);

            //设置成不可点击
            setTouchState(_bgLayer);
            setTouchState(_roleLayer);
            setTouchState(_powerSkillLayer);
            setTouchState(_effectLayer);
        }

        override protected function show():void {
            Pool.delAllObjs();

            //PVP
            if (tollgate_type == 3) {
                SoundManager.instance.playSound("battle_bgm", true, 0, 99999);
                SoundManager.instance.tweenVolume("battle_bgm", 1.0, 2);
                addBackground(_bgLayer, "map_013");
            }
            //关卡/副本
            else {
                var mainLineData:MainLineData = (MainLineData.getPoint(tollgateData.id) as MainLineData);
                addBackground(_bgLayer, mainLineData.scene);
                SoundManager.instance.playSound(mainLineData.bgm, true, 0, 99999);
                SoundManager.instance.tweenVolume(mainLineData.bgm, 1.0, 2);
                //进入关卡
                DataEyeManger.instance.beginTollgate(mainLineData.pointName);

                if (mainLineData && mainLineData.boss_level > 0) {
                    bossSeatAnimation = AnimationCreator.instance.create("effect_006", BattleAssets.instance);
                    bossSeatAnimation.play("effect_006");
                    bossSeatAnimation.animation.looping = true;
                    var point:Point = Position.instance.getPoint(mainLineData.boss_seat + 20);
                    bossSeatAnimation.x = point.x;
                    bossSeatAnimation.y = point.y - 20;
                    _effectLayer.addChild(bossSeatAnimation);
                    bossAnimation = AnimationCreator.instance.createSecneEffect(mainLineData.boss_level == 1 ? "effect_007" : "effect_008",
                                                                                0, 0, JTSession.layerGlobal, BattleAssets.instance,
                                                                                playOver);

                    bossAnimation.scaleX = bossAnimation.scaleY = Constants.isScaleWidth ? Constants.scale_x : Constants.scale;
                    bossAnimation.x = (Constants.FullScreenWidth - changePosition(400, true)) * .5;
                    bossAnimation.y = (Constants.FullScreenHeight - changePosition(400, true)) * .5;

                    function playOver():void {
                        bossSeatAnimation && bossSeatAnimation.removeFromParent(true);
                        bossSeatAnimation = null;
                    }
                }
            }
            tweenOpen();
            startup();
        }

        private var bg:Image;
        private var bg1:Image;
        private var bg2:Image;

        private function addBackground(stage:Sprite, resName:String, x:Number = 0, y:Number = 0):void {
            var n:String = resName.replace("map", "map_1");
            var texture:Texture = BattleAssets.instance.getTexture(n);

            if (!bg) {
                bg = new Image(texture);
            } else {
                bg.texture = texture;
            }

            if (bg.width < Constants.virtualWidth) {
                bg.width = Constants.virtualWidth
            }
            bg.x = ((Constants.FullScreenWidth - bg.width * Constants.scale) * .5);
            bg.blendMode = BlendMode.NONE;

            stage.addChild(bg);
            texture = AssetMgr.instance.getTexture("ui_array_base_map");

            if (!bg1) {
                bg1 = new Image(texture);
            } else {
                bg1.texture = texture
            }

            if (!bg2) {
                bg2 = new Image(texture);
            } else {
                bg2.texture = texture
            }

            bg1.name = "ui_array_base_map_1";
            bg2.name = "ui_array_base_map_2";

            bg1.x = 0;
            bg2.x = Constants.virtualWidth - Constants.virtualEmbattleWidth;
            bg1.y = bg2.y = 205;

            bg1.smoothing = bg2.smoothing = Constants.smoothing;
            stage.addChild(bg1);
            stage.addChild(bg2);
            stage.flatten(); // 扁平化背景
        }

        /**自动开始战斗隐藏九宫格站位*/
        private function hidePosGrid(bool:Boolean = false):void {
            var gridBg:Image = null;

            if (_bgLayer != null) {
                gridBg = _bgLayer.getChildByName("ui_array_base_map_1") as Image;

                if (gridBg != null) {
                    gridBg.visible = bool;
                }
                gridBg = _bgLayer.getChildByName("ui_array_base_map_2") as Image;

                if (gridBg != null) {
                    gridBg.visible = bool;
                }
            }
            _bgLayer.flatten(); //再次更新属性
        }

        override public function get data():Object {
            return tollgateData;
        }

        private function tweenOpen():void {
//            this.y = -100 * (Constants.isScaleWidth ? Constants.scale_x : Constants.scale);
            isTweening = false;
            isReturnMsg = false;
        }

        override public function set data(value:Object):void {
            GameMgr.instance.reward_Battle = null;
            tollgateData = value.tollgate as TollgateData;
            tollgate_type = value.pos;
            enemy_id = value.id;
        }

        override protected function addListenerHandler():void {
            this.addContextListener(SBattle.CMD + "", messageNotification);
            this.addContextListener(SColiseumPrizeSend.CMD + "", getColiseumPrizeSend);
            this.addContextListener(SVideoInfo.CMD + "", messageVideoNotification);
            this.addContextListener(EventType.UPDATE_BATTLE_STATUS, updateViewStatus);
        }

        private function getColiseumPrizeSend(evt:Event, info:SColiseumPrizeSend):void {
            GameMgr.instance.reward_Battle = info;
        }

        protected function updateViewStatus(evt:Event, list:Array):void {
            bossAnimation && bossAnimation.removeFromParent(true);
            bossSeatAnimation && bossSeatAnimation.removeFromParent(true);
            bossSeatAnimation = null;
            bossAnimation = null;
//            Starling.juggler.tween(this, 0.3, {y: 0});
            ShowLoader.add();
            AnimationCreator.instance.loadMeSelfBattleHeros(list, BattleAssets.instance);
            BattleAssets.instance.loadQueue(onCreateMyHerosComplement);

            function onCreateMyHerosComplement(value:Number):void {
                if (value == 1) {
                    createHeroes(list);
                    isTweening = true;
                    gameStart();
                }
            }
        }

        /**
         *
         * @param evt
         * @param sBattle
         *
         */
        protected function messageNotification(evt:Event, sBattle:SBattle):void {
            trace(this, "+收到服务器战斗开始+");

            //PVP
            if (tollgate_type == 3) {
                var pvpInfoManager:JTPvpInfoManager = JTSingleManager.instance.pvpInfoManager;
                pvpInfoManager.pvpCount -= 1;

                if (pvpInfoManager.pvpCount < 0) {
                    pvpInfoManager.pvpCount = 0;
                }
            }

            GameMgr.instance.sBattle = sBattle;
            GameMgr.instance.tired = sBattle.tried;

            WinView.rewardData = [];
            createRewardList(sBattle.props, WinView.rewardData);
            createRewardList(sBattle.equip, WinView.rewardData);

            function createRewardList(tmp_list:Vector.<IData>, reward_list:Array):void {
                var len:int = tmp_list.length;
                var widgetData:WidgetData;
                var data:Object;
                for (var i:int = 0; i < len; i++) {
                    data = tmp_list[i];
                    widgetData = WidgetData.hash.getValue(data.type);
                    if (widgetData == null) {
                        widgetData = new WidgetData(Goods.goods.getValue(data.type));
                    }
                    widgetData = widgetData.clone() as WidgetData;
                    widgetData.copy(data);
                    var count:int = 0;
                    if (data is EquipVOS) {
                        count = 1;
                    } else {
                        count = data.pile - WidgetData.pileByType(data.type);
                    }
                    for (var j:int = 0; j < count; j++) {
                        if (count > 1) {
                            var wid:WidgetData = widgetData.clone() as WidgetData;
                            wid.pile = 1;
                            reward_list.push(wid);
                        } else {
                            widgetData.pile = 1;
                            reward_list.push(widgetData);
                        }
                    }
                }
            }
            WidgetData.createProps(sBattle.props);
            WidgetData.createEquip(sBattle.equip);

            HeroDataMgr.instance.hash.eachValue(eachValue);
            function eachValue(heroData:HeroData):void {
                if (heroData.seat > 0)
                    HeroDataMgr.instance.createHero(heroData);
            }

            // 同步战斗单位血
            var battleHeros:Vector.<IData> = sBattle.battleHeroes;

            for each (var vo:battleHeroesVo in battleHeros) {
                var heroData:HeroData = HeroDataMgr.instance.battleHeros.getValue(vo.pos);

                if (heroData) {
                    heroData.hp = vo.hp;
                    heroData.currenthp = heroData.hp;
                    heroData.power = vo.power;
                }
            }

            //关卡
            if (tollgateData)
                GameMgr.instance.isPass = tollgateData.type == 2 || sBattle.currentCheckPoint > tollgateData.id;
            GameMgr.instance.battle_type = tollgate_type;

            if (sBattle.success == 1) {
                if (tollgate_type == 0 && (tollgateData as TollgateData).id > 0 && (tollgateData as TollgateData).id == GameMgr.instance.tollgateID) {
                    GameMgr.instance.tollgateID = sBattle.currentCheckPoint + 1;
                }

                //请求噩梦难度评星
                if (tollgateData && tollgateData.nightmareData)
                    GameMessage.getFbNightmareInfo();
            }

            //数据之眼
            if (tollgateData) {
                var mainLineData:MainLineData = (MainLineData.getPoint(tollgateData.id) as MainLineData);

                if (sBattle.success == 1 && !GameMgr.instance.isPass)
                    DataEyeManger.instance.completeTollgate(mainLineData.pointName);
                else if (sBattle.success != 1)
                    DataEyeManger.instance.failTollgate(mainLineData.pointName, HeroDataMgr.instance.getPower() + "");
            }

            var battleCommands:Vector.<IData> = sBattle.battleCommands;
            battleCommands.push(null);
            CommandSet.instance.init(battleCommands);
            isReturnMsg = true;
            gameStart();

            //更新关卡礼包数据
            JTFunctionManager.executeFunction(JTGlobalDef.UPDATE_TOLLGATE_NOTICE);
        }

        /**
         * 战斗录像
         * @param evt
         * @param info
         *
         */
        private function messageVideoNotification(evt:Event, info:SVideoInfo):void {
            GameMgr.instance.sBattle = null;
            GameMgr.instance.battle_type = -1;
            GameMgr.instance.isPass = true;
            var len:int, i:int;
            var heroData:HeroData;
            var curr_battle_heros:Array = [];
            var data:videoHeroes;

            var onBattleList:Array = HeroDataMgr.instance.getOnBattleHero();
            len = onBattleList.length;

            for (i = 0; i < len; i++) {
                BattleHeroMgr.instance.hash.remove(HeroData(onBattleList[i]).seat);
            }
            len = info.heroes.length;

            for (i = 0; i < len; i++) {
                data = info.heroes[i] as videoHeroes;
                heroData = HeroData.hero.getValue(data.type) as HeroData;
                heroData = heroData.clone() as HeroData;
                heroData.copy(data);
                heroData.heroPrototype = new HeroData();
                heroData.heroPrototype.copy(data);
                heroData.id = data.seat;
                heroData.currenthp = data.hp;
                heroData.team = HeroData.BLUE;
                curr_battle_heros.push(heroData);
            }
            updateViewStatus(null, curr_battle_heros);

            //数据转换
            var tmp_list:Vector.<IData> = videoDataInfo(info.videoData[0]).videoCommands;
            var battleCommands:Vector.<IData> = new Vector.<IData>();
            var battleVo:BattleVo;
            var tmp_videoVo:videoVo;
            len = tmp_list.length;

            for (i = 0; i < len; i++) {
                battleVo = new BattleVo();
                tmp_videoVo = tmp_list[i] as videoVo;
                battleVo.buffid = tmp_videoVo.buffid;
                battleVo.sponsor = tmp_videoVo.sponsor;
                var len2:int = tmp_videoVo.targets.length;
                var targets:Vector.<IData> = new Vector.<IData>();
                var battleTarget:BattleTarget;

                for (var j:int = 0; j < len2; j++) {
                    battleTarget = new BattleTarget();
                    Data.readObject(battleTarget, tmp_videoVo.targets[j]);
                    targets.push(battleTarget);
                }
                battleVo.targets = targets;
                battleVo.skill = tmp_videoVo.skill;
                battleCommands.push(battleVo);
            }
            battleCommands.push(null);
            CommandSet.instance.init(battleCommands);
            isReturnMsg = true;
            gameStart();
        }

        public function addToRoleLayer(sp:DisplayObject, x:int, y:int):void {
            _roleLayer.addChild(sp);
            sp.x = x;
            sp.y = y;
        }

        public function addToPowerSkillLayer(sp:DisplayObject, x:int, y:int):void {
            _powerSkillLayer.addChild(sp);
            sp.x = x;
            sp.y = y;
        }

        public function addEffect(sp:DisplayObject, x:int, y:int):void {
            _effectLayer.addChild(sp);
            sp.x = x;
            sp.y = y;
        }

        /**
         * 开始战斗
         */
        public function gameStart():void {
            trace(this, "[gameStart]");

            if (!isTweening || !isReturnMsg) {
                hidePosGrid();
                ShowLoader.add();
                return;
            }

            if (_battleUI == null) {
                _battleUI = new BattleUI();
                _battleUI.addEventListener(BattleUI.PASS, onSkip);
                _uiLayerLayer.addChild(_battleUI);
            }

            var storyData:StoryConfigData;

            if (tollgateData && GameMgr.instance.sBattle)
                storyData = StoryConfigData.getStory(tollgateData.id, 1);

            if (storyData)
                _uiLayerLayer.addChild(new NewBattleWords(storyData, saidComplete));
            else
                saidComplete();

            function saidComplete():void {
                _battleUI.showBattleView();
                var vs:VSEntify = new VSEntify(_effectLayer);
                vs.onComplete.addOnce(vsComplete);
            }

            function vsComplete(vs:VSEntify):void {
                var point:int = tollgateData ? tollgateData.id : 0;
                GameMgr.instance.isGameover = false;
                _driver.starup(point);
            }
            ShowLoader.remove();
        }

        private function createMonsters(data:HeroData):void {
            var heroAnimation:Hero;

            if (data.team != HeroData.BLUE) {
                heroAnimation = BattleHeroMgr.instance.createHero(data)
                _roleLayer.addChild(heroAnimation);
            }
        }

        private function createHeroes(list:Array):void {
            var tmp_list:Array = list;
            var len:int;
            var heroData:HeroData;
            var hero:Hero;
            var help_seats:Array = [];

            if (tollgateData) {
                len = tollgateData.helpHeroList.length;

                for (i = 0; i < len; i++) {
                    heroData = tollgateData.helpHeroList[i];
                    list.push(heroData);
                    help_seats.push(heroData.seat);
                }
            }

            len = tmp_list.length;

            for (var i:int = 0; i < len; i++) {
                heroData = tmp_list[i];

                if (heroData.id > 0 && help_seats.indexOf(heroData.seat) >= 0)
                    continue;
                hero = Pool.getObj(heroData.show);

                if (hero == null)
                    hero = BattleHeroMgr.instance.createHero(heroData.clone() as HeroData, false);

                if (help_seats.indexOf(heroData.seat) >= 0)
                    HeroDataMgr.instance.createHero(heroData);
                hero.data.copy(heroData);
                hero.data.seat = heroData.seat;
                hero.data.currenthp = hero.data.hp;
                BattleHeroMgr.instance.put(heroData.seat, hero);
                hero.startAnimation();
                hero.reastPos();
                _roleLayer.addChild(hero);
            }
        }

        private function startup():void {
            CommandSet.instance.onSkip.addOnce(function():void {
                var data:ArenaDareData = ArenaDareData.instance.getData("dare") as ArenaDareData;

                if (tollgateData && tollgateData.id < GameMgr.instance.tollgateID && GameMgr.instance.game_type == GameMgr.MAIN_LINE)
                    _battleUI.skip = true;
                else if (!data && GameMgr.instance.game_type == GameMgr.FB)
                    _battleUI.skip = true;
            });

            HeroDataMgr.instance.battleHeros.eachValue(createMonsters);

            DialogMgr.instance.open(EmBattleDlg, tollgateData, okButton, cancelButton, Dialog.OPEN_MODE_NOTHING);

            function cancelButton():void {
                if (GameMessage.gotoTollgateBack())
                    return;

                var data:ArenaDareData = ArenaDareData.instance.getData("dare") as ArenaDareData;

                if (JTSession.isPvp) {
                    JTPvpComponent.backPvpPanel(false);
                } else {
                    switch (GameMgr.instance.game_type) {
                        case GameMgr.MAIN_LINE:
                            DialogMgr.instance.closeAllDialog();
                            SceneMgr.instance.changeScene(NewMainWorld);
                            break;
                        case GameMgr.FB:
                            SceneMgr.instance.changeScene(NewFbScene);
                            break;
                        case GameMgr.PVP:
                            DialogMgr.instance.closeAllDialog();
                            SceneMgr.instance.changeScene(CityFace);
                            DialogMgr.instance.open(ArenaDlg);
                            break;
                        default:
                            break;
                    }
                }
            }

            /**
             * 通知服务器开始战斗
             *
             */
            function okButton():void {
                var battle:CBattle = new CBattle();
                JTSession.isPvped = true;

                if (tollgateData) {
                    switch (tollgate_type) {
                        case 0:
                            battle.type = 1;
                            battle.currentCheckPoint = tollgateData.id;
                            break;
                        case 2:
                            battle.type = 2;
                            battle.currentCheckPoint = tollgateData.id;
                            battle.pos = tollgate_type;
                            if (FbData.instance.number > 0) //副本剩余次数
                                FbData.instance.number--; //如果是副本战斗，副本剩余次数递减
                            break;
                    }

                    if (tollgateData.id > 20000)
                        battle.type = 5;

                } else if (tollgate_type == 3) {
                    battle.type = 3;
                    battle.currentCheckPoint = enemy_id;
                }
                battle && sendMessage(battle);
                trace(this, "+通知服务器开始战斗+");
                ShowLoader.add();
            }
        }

        private function onSkip(e:Event):void {
            _driver.skip = true;
        }

        /**
         *
         */
        override public function dispose():void {
            _battleUI = null;
            _bgLayer = null;
            _roleLayer = null;
            _powerSkillLayer = null;
            _effectLayer = null;
            _uiLayerLayer = null;

            if (tollgate_type != 3) {
                var mainLineData:MainLineData = (MainLineData.getPoint(tollgateData.id) as MainLineData);
                SoundManager.instance.tweenVolumeSmall(mainLineData.bgm, 0.0, 1);
            } else if (tollgate_type == 3) {
                SoundManager.instance.tweenVolumeSmall("battle_bgm", 0.0, 1);
            }
            HeroDataMgr.instance.battleHeros.clear();
            BattleHeroMgr.instance.dispose();
            BattleAssets.instance.checkDispose();
            CommandSet.instance.onSkip.removeAll();
            GameMgr.instance.tollgateData = null;
            System.pauseForGCIfCollectionImminent(0);
            System.gc();

            // 这时候场景切换，最适合垃圾回收，因为下面来个方法会导致卡屏，切换会掩盖真相
            super.dispose();
        }

    }
}


