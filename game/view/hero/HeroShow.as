package game.view.hero
{
    import com.dialog.DialogMgr;
    import com.view.View;

    import game.data.Goods;
    import game.data.HeroData;
    import game.data.RoleShow;
    import game.data.Val;
    import game.data.WidgetData;
    import game.dialog.ShowLoader;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.manager.BattleAssets;
    import game.view.comm.HeroSkillDialog;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;

    import starling.core.Starling;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.utils.AssetManager;

    import treefortress.spriter.SpriterClip;

    /**
     * 战斗外面，英雄圣殿，英雄酒馆等UI上展示的英雄形象
     * @author Administrator
     */
    public class HeroShow extends View
    {
        private static const list_loader:Array=[];
        public static const animationList:Array=["idle", "attack", "move", "win", "underattack"];

        private var _viewHero:SpriterClip;
        private var _isTouchable:Boolean;
        private var _heroData:HeroData;
        private var _assets:AssetManager;
        public var complate:ISignal;

        public function HeroShow()
        {
            super();
            _assets=BattleAssets.instance;
            complate=new Signal(HeroShow);
        }

        /**
         *
         * @param heroData 英雄数据模型
         * @param isNow    加载队列最后显示true
         * @param isTouchable 点击是否显示英雄介绍信息
         */
        public function updateHero(heroData:HeroData, isNow:Boolean=true, isTouchable:Boolean=false):void
        {
            disposeCurrent();
            _heroData=heroData;
            _isTouchable=isTouchable;
            if (!_heroData || _heroData.show == 0)
            {
                complate.dispatch(this);
                return;
            }
            var roleShow:RoleShow=RoleShow.hash.getValue(_heroData.show) as RoleShow;
            if (!_assets.getTextureAtlas(roleShow.avatar))
            {
                AnimationCreator.instance.loadHeroRes(heroData, _assets);
                ShowLoader.add();
                list_loader.push(this);
                isNow && _assets.loadQueue(onLoaded, true);
            }
            else
            {
                if (isNow && list_loader.length > 0)
                {
                    ShowLoader.add();
                    _assets.loadQueue(onLoaded, true);
                }
                else if (isNow)
                    ShowLoader.remove();
                createAvatarHandler();
            }
        }

        /**
         *更新装备
         */
        public function updataWeapon():void
        {
            if (_viewHero == null)
                return;
            var weapon:int=_heroData.seat1;
            if (weapon > 0)
            {
                var goods:Goods=WidgetData.hash.getValue(weapon);
                if (goods == null)
                    goods=Goods.goods.getValue(weapon);

                if (goods && goods.avatar)
                    _viewHero.swapPieceByTex("role_weapon", AssetMgr.instance.getTexture(goods.avatar));
            }
            else
            {
                _viewHero.unswapPiece("role_weapon");
            }
        }

        /**加载*/
        private function onLoaded(ratio:Number):void
        {
            if (ratio == 1.0)
            {
                for each (var render:HeroShow in list_loader)
                {
                    render.createAvatarHandler();
                }
                list_loader.length=0;
                ShowLoader.remove();
            }
        }

        /**建立显示模型*/
        public function createAvatarHandler():void
        {
            var roleShow:RoleShow=RoleShow.hash.getValue(_heroData.show) as RoleShow;
            _viewHero=AnimationCreator.instance.create(roleShow.avatar, _assets);
            _viewHero.play(animationList[0]);
            _viewHero.scaleX=_viewHero.scaleY=1.2 * _heroData.size / Val.ROLE_ZISE;
            _viewHero.animation.looping=true;
            _viewHero.touchable=true;
            Starling.juggler.add(_viewHero);
            _viewHero.addEventListener(TouchEvent.TOUCH, changeAnimation);
            isChage=false;
            addChild(_viewHero);
            updataWeapon();
            complate.dispatch(this);
        }

        /**停止播放*/
        public function stop():void
        {
            if (_viewHero)
            {
                _viewHero.stop();
                Starling.juggler.remove(_viewHero);
            }
        }

        /**播放默认的待机*/
        public function play():void
        {
            if (_viewHero)
            {
                if (!_viewHero.isPlaying)
                {
                    _viewHero.play(animationList[0]);
                    Starling.juggler.add(_viewHero);
                }
            }
        }

        private var changeIndex:uint=0;
        private var isChage:Boolean=false;

        /**点击改变动作*/
        private function changeAnimation(e:TouchEvent):void
        {
            var touch:Touch=e.getTouch(stage);
            if (touch == null || isChage)
                return;
            changeIndex=(changeIndex >= 4) ? 0 : changeIndex; //英雄动作的长度
            switch (touch && touch.phase)
            {
                case TouchPhase.BEGAN:
                    if (_viewHero)
                    {
                        changeIndex++;
                        _viewHero.play(animationList[changeIndex]);
                        Starling.juggler.add(_viewHero);
                        _viewHero.animationComplete.addOnce(animationComplete);
                        isChage=true;
                        if (_isTouchable)
                        {
                            DialogMgr.instance.open(HeroSkillDialog, _heroData);
                        }
                    }
                    break;
                default:
                    break;
            }
        }

        /**播放动作完成*/
        private function animationComplete(sp:SpriterClip):void
        {
            _viewHero.play(animationList[0]);
            _viewHero.animationComplete.remove(animationComplete);
            isChage=false;
        }

        /**释放当前英雄*/
        public function disposeCurrent():void
        {
            if (_viewHero)
            {
                var roleShow:RoleShow=RoleShow.hash.getValue(_heroData.show) as RoleShow;
                _viewHero.removeFromParent(true);
            }
        }

        /**
         * @return HeroData
         */
        public function get hero():HeroData
        {
            return _heroData;
        }

        /**销毁*/
        override public function dispose():void
        {
            _viewHero && _viewHero.stop();
            Starling.juggler.remove(_viewHero);
            _viewHero && _viewHero.removeFromParent(true);
            super.dispose();
        }
    }
}


