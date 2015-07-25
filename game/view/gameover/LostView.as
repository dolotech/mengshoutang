package game.view.gameover
{
    import com.dialog.DialogMgr;
    import com.scene.SceneMgr;
    import com.sound.SoundManager;

    import feathers.controls.Scroller;
    import feathers.data.ListCollection;
    import feathers.layout.TiledRowsLayout;

    import game.common.JTSession;
    import game.data.MainLineData;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.manager.HeroDataMgr;
    import game.net.message.GameMessage;
    import game.scene.world.NewFbScene;
    import game.scene.world.NewMainWorld;
    import game.view.PVP.JTPvpComponent;
    import game.view.arena.ArenaDlg;
    import game.view.city.CityFace;
    import game.view.viewBase.NewLostViewBase;

    import starling.core.Starling;
    import starling.events.Event;

    import treefortress.spriter.SpriterClip;

    /**
     * 结算失败界面
     * @author hyy
     *
     */
    public class LostView extends NewLostViewBase
    {
        private var animation:SpriterClip;

        public function LostView()
        {
            super();
        }

        override protected function init():void
        {
            const listLayout:TiledRowsLayout=new TiledRowsLayout();
            listLayout.useSquareTiles=false;
            listLayout.useVirtualLayout=true;
            listLayout.tileVerticalAlign=TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.tileHorizontalAlign=TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
            list_item.layout=listLayout;
            list_item.verticalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
            list_item.horizontalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
            list_item.itemRendererFactory=tileListItemRendererFactory;

            function tileListItemRendererFactory():NewLostRender
            {
                var itemRender:NewLostRender=new NewLostRender();
                itemRender.setSize(662, 156);
                return itemRender;
            }
        }

        override protected function addListenerHandler():void
        {
            this.addViewListener(btn_replay, Event.TRIGGERED, onNextHandler);
            this.addViewListener(btn_return, Event.TRIGGERED, onQuitHandler);
        }

        override protected function show():void
        {
            createAnimation();
            setToBottomCenter();
            btn_replay.visible=GameMgr.instance.battle_type != 3;
            SoundManager.instance.stopAllSounds();
            SoundManager.instance.playSound("BGM_Lose");
            updateList();
        }

        override protected function hide():void
        {
            animation && animation.removeFromParent(true);
            animation=null;
        }

        private function updateList():void
        {
            var mainLineData:MainLineData=MainLineData.getPoint(int(_parameter));

            if (mainLineData == null)
                return;
            var heroDataMg:HeroDataMgr=HeroDataMgr.instance;
            var tmp_list:Array=[];

            //英雄数量|装备等级|强化等级|英雄品质|宝珠品质|宝珠等级
            if (heroDataMg.getOnBattleHeroCount() < HeroDataMgr.instance.seatMax)
                tmp_list.push(0);

            if (heroDataMg.getAllHeroEquipFieldByType("limitLevel") < mainLineData.guide_equip)
                tmp_list.push(1);

            if (heroDataMg.getAllHeroEquipFieldByType("level") < mainLineData.guide_strengthen)
                tmp_list.push(2);

            if (heroDataMg.getAllHeroFieldByType("quality") < mainLineData.guide_quality)
                tmp_list.push(3);

            if (heroDataMg.getAllHeroEquipGemFieldByType("quality") < mainLineData.guide_gem)
                tmp_list.push(4);

            if (heroDataMg.getAllHeroEquipGemFieldByType("level") < mainLineData.guide_gem_level)
                tmp_list.push(5);

            if (tmp_list.length > 2)
                tmp_list.length=2;
            else if (tmp_list.length < 2)
                tmp_list.push(6);

            list_item.dataProvider=new ListCollection(tmp_list);
        }

        private function onNextHandler():void
        {
            if (_okFunction != null)
                _okFunction.call(null, 3, "agin", "agin");
            close();
        }

        private function onQuitHandler():void
        {
            if (GameMessage.gotoTollgateBack())
            {
                if (SceneMgr.instance.getCurScene() is CityFace)
                {
                    DialogMgr.instance.deleteDlg(LostView);
                    close();
                }
                return;
            }

            if (JTSession.isPvp)
            {
                JTPvpComponent.backPvpPanel(false);
                return;
            }

            switch (GameMgr.instance.game_type)
            {
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

            close();
        }


        /**
         * 创建动画
         *
         */
        private function createAnimation():void
        {
            if (animation == null)
                animation=AnimationCreator.instance.create("effect_shibaixiaoguo", AssetMgr.instance);
            animation.play("effect_shibaixiaoguo");
            animation.animation.looping=true;
            animation.x=65;
            animation.y=0;
            addChild(animation);
            Starling.juggler.add(animation);
        }

        override public function get height():Number
        {
            return changePosition(558, true);
        }

        override public function get width():Number
        {
            return changePosition(850, true);
        }
    }
}


