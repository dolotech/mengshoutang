package game.view.gameover {
    import com.dialog.DialogMgr;
    import com.scene.SceneMgr;
    import com.sound.SoundManager;

    import feathers.controls.Scroller;
    import feathers.data.ListCollection;
    import feathers.layout.TiledColumnsLayout;
    import feathers.layout.TiledRowsLayout;

    import game.common.JTSession;
    import game.data.MainLineData;
    import game.dialog.ShowLoader;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.net.message.GameMessage;
    import game.net.message.TaskMessage;
    import game.scene.arenaWorld.ArenaBattleLoader;
    import game.scene.world.NewFbScene;
    import game.scene.world.NewMainWorld;
    import game.view.PVP.JTPvpComponent;
    import game.view.achievement.TipAchievement;
    import game.view.arena.ArenaDareData;
    import game.view.arena.ArenaDlg;
    import game.view.arena.DareFace;
    import game.view.city.CityFace;
    import game.view.msg.MsgTipsDlg;
    import game.view.new2Guide.NewGuide2Manager;
    import game.view.viewBase.NewWinViewBase;

    import starling.core.Starling;
    import starling.events.Event;

    import treefortress.spriter.SpriterClip;

    /**
     * 结算胜利面板
     * @author hyy
     *
     */
    public class WinView extends NewWinViewBase {
        //临时用来储存结算数据，有时间再改
        public static var code:int = 0;
        public static var rewardData:Array;
        public static var achievementData:*;
        private var animation:SpriterClip;
        private var showGoodstime:Number;
        private var showBtntime:Number;
        private var star1_animation:SpriterClip;
        private var star2_animation:SpriterClip;
        private var star3_animation:SpriterClip;

        public function WinView() {
            super();
        }

        override protected function init():void {
            isVisible = true;
            const listLayout:TiledRowsLayout = new TiledRowsLayout();
            listLayout.useSquareTiles = false;
            listLayout.useVirtualLayout = true;
            listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
            list_hero.layout = listLayout;
            list_hero.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
            list_hero.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
            list_hero.itemRendererFactory = tileListItemRendererFactory;

            function tileListItemRendererFactory():WinHeroIcoRender {
                var itemRender:WinHeroIcoRender = new WinHeroIcoRender();
                itemRender.setSize(114, 170);
                return itemRender;
            }

            const listLayout1:TiledColumnsLayout = new TiledColumnsLayout();
            listLayout1.gap = 5;
            listLayout1.useSquareTiles = false;
            listLayout1.useVirtualLayout = true;
            listLayout1.horizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
            list_goods.layout = listLayout1;
            list_goods.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
            list_goods.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
            list_goods.itemRendererFactory = listItemRendererFactory;

            function listItemRendererFactory():WinGoodsIcoRender {
                var itemRender:WinGoodsIcoRender = new WinGoodsIcoRender();
                itemRender.setSize(90, 90);
                return itemRender;
            }
        }

        override protected function addListenerHandler():void {
            this.addViewListener(btn_replay, Event.TRIGGERED, onNextHandler);
            this.addViewListener(btn_return, Event.TRIGGERED, onQuitHandler);
        }

        override protected function show():void {
            SoundManager.instance.stopAllSounds();
            SoundManager.instance.playSound("BGM_Win");
            setToXCenter();
            createAnimation();
            updateView();
        }

        override public function dispose():void {
            super.dispose();
            SoundManager.instance.stopAllSounds();
            animation && animation.removeFromParent(true);
            star1_animation && star1_animation.removeFromParent(true);
            star2_animation && star2_animation.removeFromParent(true);
            star3_animation && star3_animation.removeFromParent(true);
        }

        /**
         * 整个界面更新
         */
        protected function updateView():void {
            txt_gold.text = GameMgr.instance.tollgateData ? GameMgr.instance.tollgateData.gold + "" : "0";
            updateTipAchievement();
            showTweenAnimation();
        }

        /**
         * 缓动展示界面
         */
        private function showTweenAnimation():void {
            //隐藏按钮
            showBtnVisible(false);

            if (GameMgr.instance.battle_type == 0 || GameMgr.instance.battle_type == 1 || GameMgr.instance.battle_type == 2) {
                showGoodstime = 2.5;
                showBtntime = rewardData == null || rewardData.length == 0 ? showGoodstime : showGoodstime + .5;
                if (NewGuide2Manager.instance)
                    showGoodstime = showBtntime = 0;
                showStartAnimation();
            } else if (GameMgr.instance.battle_type == 3 || GameMgr.instance.battle_type == 4) {
                showGoodstime = 1;
                showBtntime = rewardData == null || rewardData.length == 0 ? showGoodstime : showGoodstime + .5;
                showHeroList();
                showNexAnimation();
            }
        }

        //显示英雄列表
        private function showHeroList():void {
            list_hero.dataProvider = new ListCollection(GameMgr.instance.sBattle.upgrade);
        }

        //物品列表
        private function showGoodsList():void {
            list_goods.dataProvider = new ListCollection(rewardData);
        }

        private function showNexAnimation():void {
            delayCall(showGoodsList, showGoodstime);
            delayCall(showBtnVisible, showBtntime);
        }

        //显示星星
        private function showStartAnimation():void {
            var nightmare_star:int = GameMgr.instance.tollgateData.nightmare_star;
            var num:String = nightmare_star.toString(2);
            var count:int = 0;

            for (var i:int = 0; i < num.length; i++) {
                if (num.charAt(i) == "1")
                    count++;
            }

            if (star1_animation == null && (count >= 2)) {
                star1_animation = addAnimation(130, 120, "star_1", showStartAnimation);
                return;
            }

            if (star2_animation == null && (count == 1 || count == 3)) {
                star2_animation = addAnimation(290, 160, "star_2", showStartAnimation);
                return;
            }

            if (star3_animation == null && (count >= 2)) {
                star3_animation = addAnimation(435, 120, "star_3", showStartAnimation);
                return;
            }
            showHeroList();
            showNexAnimation();
        }

        private function showBtnVisible(value:Boolean = true):void {
            btn_replay.visible = btn_return.visible = value;
            if (value) {
                var mainLineData:MainLineData = MainLineData.getPoint(int(_parameter));

                if ((mainLineData && mainLineData.boss_type == 1) || JTSession.isPvp || mainLineData.isStory)
                    btn_replay.visible = false;
                if (!NewGuide2Manager.instance && GameMgr.instance.sBattle.success == 1) { //不在新手
                    TaskMessage.chenkOpenTipDialog(); //结束后提示新任务开启
                    TaskMessage.chenkOverTipDialog(); //结束后提示完成任务
                }
            }

            if (code > 0) {
                MsgTipsDlg.instance.tips(code);
                code = 0;
            }
        }

        /**
         *  更新关卡,副本数据
         */
        private function addAnimation(x:int, y:int, sound:String, onComplement:Function):SpriterClip {
            var animation:SpriterClip = AnimationCreator.instance.create("effect_pingxingdonghua", AssetMgr.instance);
            animation.play("effect_pingxingdonghua");
            animation.animation.looping = false;
            animation.x = x;
            animation.y = y;
            addChild(animation);
            animation.addCallback(onComplement, 400);
            Starling.juggler.add(animation);
            SoundManager.instance.playSound(sound);
            return animation;
        }

        /**
         * 更新成就
         *
         */
        private function updateTipAchievement():void {
            if (achievementData == null)
                return;
            var tip:TipAchievement = new TipAchievement();
            tip.open(Starling.current.stage, achievementData);
        }

        /**
         * 创建动画
         */
        private function createAnimation():void {
            animation = AnimationCreator.instance.create("effect_shenglixiaoguo", AssetMgr.instance);
            animation.play("effect_shenglixiaoguo");
            animation.animation.looping = true;
            animation.x = -47;
            animation.y = -20;
            addChild(animation);
            Starling.juggler.add(animation);
        }

        /**
         * 退出
         * @param e
         */
        private function onQuitHandler(e:Event):void {
            if (GameMessage.gotoTollgateBack())
                return;

            if (JTSession.isPvp) {
                JTPvpComponent.backPvpPanel(true);
                return;
            }

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
                    _okFunction != null && _okFunction.call(null, 2);
                    break;
            }
            close();
        }

        override public function getGuideDisplay(name:String):* {
            return btn_return;
        }

        /**
         * 新手引导专用函数
         * @param id
         * 退出新手引导
         */
        override public function executeGuideFun(name:String):void {
            if (name == "跳转主城") {
                ShowLoader.remove();
                SceneMgr.instance.changeScene(CityFace)
            } else if (name == "世界地图") {
                ShowLoader.remove();
                SceneMgr.instance.changeScene(NewMainWorld);
            } else {
                onQuitHandler(null);
            }
        }

        /**
         * 下一关
         * @param e
         */
        private function onNextHandler(e:Event):void {
            var arenaDareData:ArenaDareData = ArenaDareData.instance.getData("dare") as ArenaDareData;

            if (arenaDareData && GameMgr.instance.game_type == GameMgr.PVP) {
                if (arenaDareData.number > 0)
                    (new ArenaBattleLoader).load.apply(this, DareFace.fightData);
                else {
                    DialogMgr.instance.closeAllDialog();
                    SceneMgr.instance.changeScene(CityFace);
                    DialogMgr.instance.open(ArenaDlg);
                }
                return;
            }
            if (_okFunction != null)
                _okFunction.call(null, 3, "agin", e.target == btn_replay ? "agin" : "");
            close();
        }
    }
}

