package game.view.tavern.render {
    import com.sound.SoundManager;
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
    import game.manager.HeroDataMgr;
    import game.net.data.IData;

    import starling.display.DisplayObject;
    import starling.events.Event;

    import treefortress.spriter.SpriterClip;

    /**
     * 通用英雄列表
     * @author hyy
     *
     */
    public class MercenaryListRender extends View {
        public static var POSTION:Number = 0;
        public var _selectedIndex:int = 0;
        public var list_hero:List = null;
        public var selectedAnimation:SpriterClip = null;

        public function MercenaryListRender() {
            super();
        }

        override protected function init():void {
            selectedAnimation = AnimationCreator.instance.create("effect_012", AssetMgr.instance);

            const listLayout:TiledColumnsLayout = new TiledColumnsLayout();
            listLayout.gap = 3;
            listLayout.useSquareTiles = false;
            listLayout.useVirtualLayout = false;
            listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
            listLayout.paging = TiledColumnsLayout.PAGING_HORIZONTAL; //自动排列
            list_hero = new List();
            list_hero.layout = listLayout;
            list_hero.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
            list_hero.itemRendererFactory = tileListItemRendererFactory;
            addChild(list_hero);
            function tileListItemRendererFactory():MercenaryIconRender {
                var itemRender:MercenaryIconRender = new MercenaryIconRender(selectedAnimation);
                itemRender.setSize(100, 100);
                return itemRender;
            }
        }

        /**监听*/
        override protected function addListenerHandler():void {
            this.addViewListener(list_hero, Event.CHANGE, onListSelected);
            this.addViewListener(list_hero, Event.SCROLL, listBagScroll);
            this.addContextListener(EventType.NOTIFY_MERCENARY_BUY, onUpdateMerGrid);
        }

        /**更新格子*/
        private function onUpdateMerGrid():void {
            list_hero.horizontalScrollPosition = POSTION;
        }

        /**
         * 记录滚动位置
         *
         */
        private function listBagScroll():void {
            POSTION = list_hero.horizontalScrollPosition;
        }

        /**更新数据[{id:佣兵id,state:状态},...]*/
        public function updateMercenaryList(vector:Vector.<IData>):void {
            list_hero.dataProvider = new ListCollection(vector);
        }

        override protected function show():void {
            if (list_hero.selectedIndex == -1)
                return;
            var tmp_Grid:Object = list_hero.selectedItem;
            _selectedIndex = list_hero.selectedIndex;
            dispatch(EventType.NOTIFY_MERCENARY_SELECT, tmp_Grid);
        }

        /**向外派发事件*/
        private function onListSelected():void {
            if (list_hero.selectedIndex == -1)
                return;
            var tmp_Grid:Object = list_hero.selectedItem;
            _selectedIndex = list_hero.selectedIndex;
            dispatch(EventType.NOTIFY_MERCENARY_SELECT, tmp_Grid);
        }

        /**设置大小*/
        public function setSize(w:int, h:int):void {
            list_hero.setSize(w, h);
        }

        /**获取选项*/
        public function getChildItem(i:int):DisplayObject {
            return list_hero.dataViewPort.getChildAt(i);
        }

        /**{id:佣兵id,state:状态}*/
        public function updateItem(item:Object):void {
            list_hero.dataProvider.updateItem(item);
        }

        /**{id:佣兵id,state:状态}*/
        public function removeItem(item:Object):void {
            list_hero.dataProvider.removeItem(item);
        }

        public function validate():void {
            if (!list_hero.isCreated)
                list_hero.validate();
        }

        /**获取选中下标*/
        public function get selectedIndex():int {
            return _selectedIndex;
        }

        /**选中通过下标*/
        public function set selectedIndex(value:int):void {
            _selectedIndex = value;
            list_hero.selectedIndex = -1;
            list_hero.selectedIndex = _selectedIndex;
            list_hero.horizontalScrollPosition = POSTION;
        }

        /**停止所有声音*/
        public function stopAllSound():void {
            var soundMgr:SoundManager = SoundManager.instance;
            HeroDataMgr.instance.hash.eachValue(fun);
            function fun(data:HeroData):void {
                soundMgr.stopSound(data.sound);
            }
        }

        /**销毁*/
        override public function dispose():void {
            super.dispose();
            selectedAnimation && selectedAnimation.removeFromParent(true);
            selectedAnimation = null;
        }
    }
}



