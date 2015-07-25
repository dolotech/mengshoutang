package game.view.heroHall.render
{
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.sound.SoundManager;
    import com.utils.ArrayUtil;
    import com.view.View;
    import com.view.base.event.EventType;

    import feathers.controls.List;
    import feathers.controls.Scroller;
    import feathers.data.ListCollection;
    import feathers.layout.TiledColumnsLayout;
    import feathers.layout.TiledRowsLayout;

    import game.data.HeroData;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.manager.HeroDataMgr;
    import game.net.message.EquipMessage;
    import game.view.heroHall.HeroDialog;
    import game.view.loginReward.ResignDlg;

    import starling.display.DisplayObject;
    import starling.events.Event;

    import treefortress.spriter.SpriterClip;

    /**
     * 通用英雄列表
     * @author hyy
     *
     */
    public class HeroListRender extends View
    {
        public static var POSTION:Number=0;
        public var _selectedIndex:int=0;
        public var list_hero:List=null;
        public var selectedAnimation:SpriterClip=null;
        public var isDragEnable:Boolean=false;

        public function HeroListRender(isDragEnable:Boolean=false)
        {
            super();
            this.isDragEnable=isDragEnable;
        }

        override protected function init():void
        {
            selectedAnimation=AnimationCreator.instance.create("effect_012", AssetMgr.instance);

            const listLayout:TiledColumnsLayout=new TiledColumnsLayout();
            listLayout.useSquareTiles=false;
            listLayout.useVirtualLayout=false;
            listLayout.tileVerticalAlign=TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.tileHorizontalAlign=TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
            listLayout.paging=TiledColumnsLayout.PAGING_HORIZONTAL; //自动排列
            list_hero=new List();
            list_hero.layout=listLayout;
            list_hero.verticalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
            list_hero.itemRendererFactory=tileListItemRendererFactory;
            addChild(list_hero);
            function tileListItemRendererFactory():HeroIconRender
            {
                var itemRender:HeroIconRender=new HeroIconRender(selectedAnimation, isDragEnable);
                itemRender.setSize(106, 101);
                return itemRender;
            }
        }

        override protected function addListenerHandler():void
        {
            this.addViewListener(list_hero, Event.CHANGE, onListSelected);
            this.addViewListener(list_hero, Event.SCROLL, listBagScroll);
            this.addContextListener(EventType.BUY_HERO_GRID, onUpdateHeroGrid);
        }

        private function onUpdateHeroGrid():void
        {
            updateHeroList(null);
            list_hero.horizontalScrollPosition=POSTION;
        }

        /**
         * 记录滚动位置
         *
         */
        private function listBagScroll():void
        {
            POSTION=list_hero.horizontalScrollPosition;
        }

        override protected function show():void
        {
            updateHeroList(null);
            selectedIndex=_selectedIndex;
        }

        public function updateHeroList(listData:Array):void
        {
            if (listData == null)
            {
                listData=ArrayUtil.change2Array(HeroDataMgr.instance.hash.values());
                listData.sortOn("getPower", Array.DESCENDING | Array.NUMERIC);
            }
            //按等级,品质排序
            var len:int=listData.length;
            var gridCount:int=GameMgr.instance.hero_gridCount;

            //玩家英雄小于9个，添加灰色头像英雄,保证列表9个人物框
            for (var i:int=0; i < gridCount; i++)
            {
                if (len <= i)
                    listData[i]=new HeroData(); //空的英雄数据
            }

            if (HeroDataMgr.list_heroGrid[GameMgr.instance.hero_gridCount + 1] != null)
            {
                var nullGridHero:HeroData=new HeroData();
                nullGridHero.id=-1;
                listData.push(nullGridHero);
            }
            list_hero.dataProvider=new ListCollection(listData);
        }

        public function buyHeroGrid():void
        {
            var tip:ResignDlg=DialogMgr.instance.open(ResignDlg) as ResignDlg;
            var text:String=Langue.getLangue("buyHeroGrid").replace("*", HeroDataMgr.list_heroGrid[GameMgr.instance.hero_gridCount + 1]);
            text=text.replace("&", GameMgr.instance.hero_gridCount + 1);
            tip.text=text;
            tip.onResign.addOnce(isOkClick);
            function isOkClick():void
            {
                EquipMessage.sendDBuyHeroGridMessage();
            }
        }

        private function onListSelected():void
        {
            if (list_hero.selectedIndex == -1)
                return;
            var tmp_Grid:HeroData=list_hero.selectedItem as HeroData;

            if (tmp_Grid.id == -1)
            {
                buyHeroGrid();
                return;
            }

            if (tmp_Grid.id > 0)
            {
                _selectedIndex=list_hero.selectedIndex;
                dispatch(EventType.UPDATE_HERO_SELECTED, tmp_Grid);
            }
        }


        public function setSize(w:int, h:int):void
        {
            list_hero.setSize(w, h);
        }

        public function getChildItem(i:int):DisplayObject
        {
            return list_hero.dataViewPort.getChildAt(i);
        }

        public function updateItem(item:HeroData):void
        {
            list_hero.dataProvider.updateItem(item);
        }

        public function removeItem(item:HeroData):void
        {
            list_hero.dataProvider.removeItem(item);
        }

        public function validate():void
        {
            if (!list_hero.isCreated)
                list_hero.validate();
        }

        public function get selectedIndex():int
        {
            return _selectedIndex;
        }

        public function set selectedIndex(value:int):void
        {
            _selectedIndex=value;
            list_hero.selectedIndex=-1;
            list_hero.selectedIndex=_selectedIndex;
            list_hero.horizontalScrollPosition=POSTION;
        }

        public function stopAllSound():void
        {
            var soundMgr:SoundManager=SoundManager.instance;
            HeroDataMgr.instance.hash.eachValue(fun);
            function fun(data:HeroData):void
            {
                soundMgr.stopSound(data.sound);
            }
        }

        override public function dispose():void
        {
            super.dispose();
            selectedAnimation && selectedAnimation.removeFromParent(true);
            selectedAnimation=null;
        }
    }
}


