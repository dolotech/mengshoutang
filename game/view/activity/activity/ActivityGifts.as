package game.view.activity.activity {
    import com.data.HashMap;
    import com.mvc.interfaces.INotification;
    import com.view.View;

    import feathers.controls.List;
    import feathers.controls.PageIndicator;
    import feathers.controls.Scroller;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ListCollection;
    import feathers.layout.TiledColumnsLayout;
    import feathers.layout.TiledRowsLayout;

    import game.data.ActivityNum;
    import game.dialog.ShowLoader;
    import game.manager.AssetMgr;
    import game.net.GameSocket;
    import game.net.data.IData;
    import game.net.data.c.CDiamondFest;
    import game.net.data.s.SDiamondFest;
    import game.net.data.vo.FestValues;
    import game.view.activity.IActivity;

    import starling.display.Image;
    import starling.events.Event;
    import starling.textures.Texture;

    /**
     *
     * @author litao 免费钻石大放送
     *
     */
    public class ActivityGifts extends View implements IActivity {
        private var activityList:Array = [];

        public function ActivityGifts() {
            super();
        }
        private var hash:HashMap
        private var ids:Vector.<IData>;

        public function set data(data:Object):void {
            hash = data as HashMap;
            activityList.length = 0;

            send();
        }

        private function send():void {
            var cmd:CDiamondFest = new CDiamondFest();
            GameSocket.instance.sendData(cmd);
            ShowLoader.add();
        }

        override public function handleNotification(_arg1:INotification):void {
            var info:SDiamondFest = _arg1 as SDiamondFest;
            var i:int;
            var len:int = info.ids.length;
            activityList.length = 0;
            var values:FestValues;
            var data:ActivityNum;
            var arr:Array = [];
            for (i; i < len; i++) {
                values = info.ids[i] as FestValues;
                data = hash.getValue(values.id);
                arr[i] = {id: values.id, data: data}
                data.ids = info.ids;
                data.code = info.code;
                data.loadUrl = info.loadUrl;
                data.ratingUrl = info.ratingUrl;
            }
            arr.sortOn(["id"], Array.NUMERIC);
            for (i = 0; i < len; i++) {
                activityList[i] = arr[i].data;
            }
            if (!list) {
                createList();
//				createPageIndicator();
            }
            refreshListData();
            ShowLoader.remove();
        }

        override public function listNotificationName():Vector.<String> {
            var vect:Vector.<String> = new Vector.<String>;
            vect.push(SDiamondFest.CMD);
            return vect;
        }


        private var list:List;
        private var _pageIndicator:PageIndicator;

        private function createList():void {
            const listLayout:TiledColumnsLayout = new TiledColumnsLayout();
            listLayout.gap = 8;
            listLayout.useSquareTiles = false;
            listLayout.useVirtualLayout = true;
            listLayout.paging = TiledColumnsLayout.PAGING_HORIZONTAL; //自动排列
            listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;

            list = new List();
            list.x = 250;
            list.y = 185;
            list.width = 680;
            list.height = 460;
            addChild(list);
            list.layout = listLayout;
            list.paddingLeft = 10;
            list.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;

            list.itemRendererFactory = tileListItemRendererFactory;
            list.addEventListener(Event.CHANGE, onSelect);
//			list.snapToPages = true;
            if (scrollIndex > 0) {
                list.scrollToPosition(scrollIndex * 325, 0);
                scrollIndex = -1;
            }
//			list.addEventListener(Event.SCROLL, list_scrollHandler);

        }
        private var scrollIndex:int = -1;

        public function set scrollToPageIndex(value:int):void {
            scrollIndex = value;
        }

        private function createPageIndicator():void {
            const normalSymbolTexture:Texture = AssetMgr.instance.getTexture("ui_gongyong_yemianqiehuan2");
            const selectedSymbolTexture:Texture = AssetMgr.instance.getTexture("ui_gongyong_yemianqiehuan1");
            this._pageIndicator = new PageIndicator();
            this._pageIndicator.normalSymbolFactory = function():Image {
                return new Image(normalSymbolTexture);
            }
            this._pageIndicator.selectedSymbolFactory = function():Image {
                return new Image(selectedSymbolTexture);
            }
            this._pageIndicator.direction = PageIndicator.DIRECTION_HORIZONTAL;
            this._pageIndicator.gap = 20;
            this._pageIndicator.addEventListener(Event.CHANGE, pageIndicator_changeHandler);
            _pageIndicator.y = 580;
            _pageIndicator.x = 520;
            this._pageIndicator.pageCount = Math.ceil(activityList.length * 0.5);
            addChild(_pageIndicator);
        }

        protected function pageIndicator_changeHandler(event:Event):void {
            this.list.scrollToPageIndex(this._pageIndicator.selectedIndex, 0);
        }

        private function refreshListData():void {
            const collection:ListCollection = new ListCollection(activityList);
            list.dataProvider = collection;
        }

        protected function tileListItemRendererFactory():IListItemRenderer {
            const renderer:ActivityGiftsItemRender = new ActivityGiftsItemRender();
            renderer.setSize(318, 385);
            return renderer;
        }

        protected function list_scrollHandler(event:Event):void {
            this._pageIndicator.selectedIndex = this.list.horizontalPageIndex;
        }

        private function onSelect(e:Event):void {

        }
    }
}
import flash.utils.getDefinitionByName;

import avmplus.getQualifiedClassName;

import feathers.controls.renderers.DefaultListItemRenderer;

import game.data.ActivityNum;
import game.view.activity.activity.AllGifts.IGifts;

class ActivityGiftsItemRender extends DefaultListItemRenderer {
    public function ActivityGiftsItemRender() {

    }
    private var activityNum:ActivityNum;

    override public function set data(value:Object):void {
        if (value == null)
            return;
        activityNum = value as ActivityNum;
        if (defaultSkin) {
            var className:String = getQualifiedClassName(defaultSkin);
            if (className != value.showClass) {
                showSKin(String(value.showClass));
            }
        } else
            showSKin(String(value.showClass));
        super.data = value;
    }

    private function showSKin(value:String):void {
        var cls:Class = getDefinitionByName("game.view.activity.activity.AllGifts." + value) as Class;
        defaultSkin && defaultSkin.removeFromParent(true);
        defaultSkin = new cls;
        var gifts:IGifts = defaultSkin as IGifts;
        gifts.data = activityNum;
    }

}
