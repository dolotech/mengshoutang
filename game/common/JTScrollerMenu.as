package game.common
{
    import flash.geom.Point;

    import feathers.controls.List;
    import feathers.controls.Scroller;
    import feathers.controls.renderers.DefaultListItemRenderer;
    import feathers.data.ListCollection;
    import feathers.layout.ILayout;
    import feathers.layout.ILayoutDisplayObject;
    import feathers.layout.TiledColumnsLayout;
    import feathers.layout.TiledRowsLayout;

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.events.Event;

    /**
     * 滚动菜单按钮列表
     * @author CabbageWrom
     *
     */
    public class JTScrollerMenu extends List
    {
        private static var _instance:JTScrollerMenu=null;
        private var itemRenderer:Class=null;
        private var callback:Function=null;

        public function JTScrollerMenu(itemRenderer:Class=null, onMouseClick:Function=null, itemDataList:Object=null)
        {
            super();
            reset(itemRenderer, itemDataList);
            this.callback=onMouseClick;
        }

        override protected function initialize():void
        {
            super.initialize();
            this.itemRendererFactory=getItemRenderer;
            this.addEventListener(Event.CHANGE, onMouseClickHandler);
        }

        public static var scrollerV:int=0;

        public function registerScroller():void
        {
            this.addEventListener(Event.SCROLL, onScrollerHandler);
        }

        private function onScrollerHandler(e:Event):void
        {
            if (this.maxVerticalScrollPosition != 0)
                scrollerV=this.verticalScrollPosition;
        }

        public function getDefaultLayout(gap:int=1, paddingTop:int=5):ILayout
        {
            var listLayout:TiledRowsLayout=new TiledRowsLayout();
            listLayout.gap=gap;
            listLayout.useSquareTiles=false;
            listLayout.useVirtualLayout=true;
            this.horizontalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
            this.verticalScrollPolicy=Scroller.SCROLL_POLICY_ON;
            this.paddingTop=paddingTop;
            return listLayout as ILayout;
        }

        public function getTildedRowsLayout(gap:int=1, paddingTop:int=5):ILayout
        {
            var listLayout:TiledRowsLayout=new TiledRowsLayout();
            listLayout.gap=gap;
            listLayout.useSquareTiles=false;
            listLayout.useVirtualLayout=true;
            listLayout.verticalAlign=TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
            this.horizontalScrollPolicy=Scroller.SCROLL_POLICY_ON;
            this.verticalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
            this.paddingTop=paddingTop;
            return listLayout as ILayout;
        }

        public function setRectange(display:DisplayObject):void
        {
            this.x=display.x;
            this.y=display.y;
            this.width=display.width;
            this.height=display.height;
        }

        public function getAutoTildedRowsLayout(gap:int=1, paddingTop:int=5):ILayout
        {
            var listLayout:TiledRowsLayout=new TiledRowsLayout();
            listLayout.gap=gap;
            listLayout.useSquareTiles=false;
            listLayout.useVirtualLayout=true;
            listLayout.verticalAlign=TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
            listLayout.paging=TiledColumnsLayout.PAGING_HORIZONTAL;
            this.horizontalScrollPolicy=Scroller.SCROLL_POLICY_ON;
            this.verticalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
            this.paddingTop=paddingTop;
            return listLayout as ILayout;
        }

        public function getAutoTiledColumnsLayout(gap:int=8):ILayout
        {
            const listLayout:TiledColumnsLayout=new TiledColumnsLayout();
            listLayout.gap=gap;
            listLayout.useSquareTiles=false;
            listLayout.useVirtualLayout=true;
            listLayout.tileVerticalAlign=TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.tileHorizontalAlign=TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
            listLayout.paging=TiledColumnsLayout.PAGING_HORIZONTAL;
            this.verticalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
            this.paddingTop=paddingTop;
            return listLayout;
        }

        public function getTiledColumnsLayout(gap:int=8):ILayout
        {
            const listLayout:TiledColumnsLayout=new TiledColumnsLayout();
            listLayout.gap=gap;
            listLayout.useSquareTiles=false;
            listLayout.useVirtualLayout=true;
            listLayout.tileVerticalAlign=TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.tileHorizontalAlign=TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
            this.verticalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
            this.paddingTop=paddingTop;
            return listLayout;
        }

        private function getItemRenderer():ILayoutDisplayObject
        {
            var render:DefaultListItemRenderer=null;
            if (!this.itemRenderer)
            {
                render=new JTMenuButton() as DefaultListItemRenderer;
            }
            else
            {
                render=new itemRenderer() as DefaultListItemRenderer
            }
            render.owner=this;
            return render;
        }

        public function changeLayout(layout:ILayout):void
        {
            this.layout=layout;
            super.initialize();
        }

        /**
         * 重置
         * @param itemRenderer
         * @param itemDataList
         *
         */
        public function reset(itemRenderer:Class, itemDataList:Object):void
        {
            resetItemClass(itemRenderer);
            resetItemInfoList(itemDataList);
        }

        /**
         *此方法可能导致GPU渲染器强制性重绘.性能开销较大，建议少用.
         *
         */
        public static function initializeDefualtMenu():void
        {
            if (!_instance)
            {
                JTLogger.error("[JTScrollSelectUtil.initializeDefualtMenu] _Instance is Empty!]");
            }
            if (!_instance.dataViewPort)
            {
                JTLogger.error("[JTScrollSelectUtil.initializeDefualtMenu] _Instance dataViewPort is Empty]");
            }
            if (_instance.dataProvider.length == 0)
            {
                JTLogger.error("[JTScrollSelectUtil.initializeDefualtMenu] _Instance dataProvider length for Zero]");
            }
            _instance.validate();
            if (_instance.dataViewPort.numChildren == 0)
            {
                JTLogger.error("[JTScrollSelectUtil.initializeDefualtMenu] _Instance dataViewPort numChildren for Zero!]");
            }
            var render:DefaultListItemRenderer=_instance.dataViewPort.getChildAt(0) as DefaultListItemRenderer;
            if (!render)
            {
                JTLogger.error("[JTScrollSelectUtil.initializeDefualtMenu] Can't Find The Render!]");
            }
            if (render is JTMenuButton)
            {
                (render as JTMenuButton).setDownSkin();
            }
        }

        public static function localToGlobal(point:Point):void
        {
            if (!point)
            {
                JTLogger.error("[JTScrollSelectUtil.initializePoint] _Instance is Empty!]");
            }
            _instance.x=point.x;
            _instance.y=point.y;
        }

        public function resetItemClass(itemRenderer:Class):void
        {
            this.itemRenderer=itemRenderer;
            if (!this.itemRenderer)
            {
                this.itemRenderer=JTMenuButton;
            }

            //注释掉的代码为  重设置 有内存泄漏，建议使用时先解决内存泄漏
        /*if (this.itemRendererFactory != null)
        {
        this.resetItemRendererFactory(getItemRenderer);
        }
        else
        {
        this.itemRendererFactory = getItemRenderer;
        }*/
        }

        /**
         * 重设置数据列表
         * @param itemDataList
         *
         */
        public function resetItemInfoList(itemDataList:Object):void
        {
            if (!itemDataList)
            {
                JTLogger.warn("[JTScrollSelectUtil.rest] DataList is Empty!");
                this.dataProvider=new ListCollection();
            }
            if (this.dataProvider)
            {
                this.dataProvider=null;
            }
            this.dataProvider=new ListCollection(itemDataList);
            refreshBackgroundSkin();
        }

        private function onMouseClickHandler(e:Event):void
        {
            if (callback == null)
            {
                return;
            }
            var i:int=0;
            var viewPorts:ListCollection=this.dataViewPort.dataProvider
            var l:int=viewPorts.length;
            var render:DefaultListItemRenderer=null;
            for (i=0; i < l; i++)
            {
                if (this.selectedIndex == i)
                {
                    continue;
                }
                render=this.dataViewPort.getChildAt(i) as DefaultListItemRenderer;
                if (!(render is JTMenuButton))
                {
                    break;
                }
                (render as JTMenuButton).recoverDefaultSkin();
            }
            if (!this.selectedItem)
            {
                return;
            }
            callback(selectedItem);
            this.selectedIndex=-1;
            //	e.stopImmediatePropagation();
        }

        public function push(item:Object):void
        {
            if (!this.dataProvider)
            {
                this.dataProvider=new ListCollection();
            }
            this.dataProvider.push(item);
        }

        public function shift():Object
        {
            if (!this.dataProvider)
            {
                JTLogger.error("[JTScrollSelectUtil.shift] DataProvider is Empty!");
            }
            if (!this.dataProvider.length)
            {
                JTLogger.error("[JTScrollSelectUtil.shift] DataProvider Length for Zero!");
            }
            return this.dataProvider.shift();
        }

        override public function dispose():void
        {
            super.dispose();
            if (this.hasEventListener(Event.SCROLL))
            {
                this.removeEventListener(Event.SCROLL, onScrollerHandler);
            }
            this.removeEventListener(Event.CHANGE, onMouseClickHandler);
            this.callback=null;
            this.itemRenderer=null;
        }

        /**
         * 创建滚动菜单
         * 些方法使用是伪单例
         * @param parent 父容器
         * @param itemRenderer 要滚动的类型
         * @param onMouseClick 单击某一个对像的单击事件
         * @param itemDataList 要传入的数据列表
         *
         */
        public static function show(parent:Sprite, itemRenderer:Class=null, onMouseClick:Function=null, itemDataList:Object=null):void
        {
            if (!_instance)
            {
                _instance=new JTScrollerMenu(itemRenderer, onMouseClick, itemDataList);
                parent.addChild(_instance);
            }
        }

        public static function getInstance():JTScrollerMenu
        {
            return _instance;
        }

        /**
         * 创建滚动菜单
         * @param itemRenderer 要滚动的类型
         * @param onMouseClick 单击某一个对像的单击事件
         * @param itemDataList 要传入的数据列表
         * @return  返回该菜单管理器
         *
         */
        public static function createScrollerMenu(itemRenderer:Class=null, onMouseClick:Function=null, itemDataList:Object=null):JTScrollerMenu
        {
            return new JTScrollerMenu(itemRenderer, onMouseClick, itemDataList);
        }

        /**
         *
         *
         */
        public static function hide():void
        {
            if (_instance)
            {
                _instance.removeFromParent();
                _instance.dispose();
                _instance=null;
            }
        }
    }
}
import flash.text.TextFormat;

import feathers.controls.renderers.DefaultListItemRenderer;

import game.manager.AssetMgr;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import com.utils.Constants;

class JTMenuButton extends DefaultListItemRenderer
{
    private var text:TextField=null;
    private var changeDownSkin:Image=null;
    private var changeUpSkin:Image=null;
    private var image:Image=null;

    public function JTMenuButton()
    {
        super();
        this.stateToSkinFunction=null;
        this.changeUpSkin=new Image(AssetMgr.instance.getTexture("ui_butten_rongyufenleianniu1"));
        this.defaultSkin=changeUpSkin;
        this.changeDownSkin=new Image(AssetMgr.instance.getTexture("ui_butten_rongyufenleianniu2"));
        this.text=getTextField();
        this.addChild(text);
    }

    override protected function initialize():void
    {
        this.text.touchable=false;
        this.text.x=((this.defaultSkin.width - this.text.width) / 2 + 20);
        this.text.y=(this.defaultSkin.height - this.text.height) / 2;
    }

    override public function dispose():void
    {
        text=null;
        changeDownSkin=null;
        changeUpSkin=null;
        image=null;
        super.dispose();
    }

    override protected function itemRenderer_triggeredHandler(e:Event):void
    {
        super.itemRenderer_triggeredHandler(e);
        setDownSkin();
    }

    public function recoverDefaultSkin():void
    {
        this.defaultSkin=this.changeUpSkin;
        refreshSkin();
    }

    public function setDownSkin():void
    {
        this.defaultSkin=this.changeDownSkin;
        refreshSkin();
    }

    public static function getTextFormat():TextFormat
    {
        var textFormat:TextFormat=new TextFormat("宋体", 14, 0xFFFFFF);
        return textFormat;
    }

    private function getTextField():TextField
    {
        var txt:TextField=new TextField(134, 54, '', '', 34, 0xffffff, false);
        txt.touchable=false;
        txt.hAlign='center';
        txt.x=0;
        txt.y=0;
        return txt;
    }

    override public function set data(value:Object):void
    {
        if (!value)
        {
            return;
        }
        var title:String=value.toString();
        var lines:Array=title.split(":");
        this.label=lines[0];
        this.text.text=this.label;
        this.name=lines[1];
        this.addChild(showIcon(this.name));
        super.data=lines[0];
    }

    override public function set isSelected(value:Boolean):void
    {
        super.isSelected=value;
    }

    private function showIcon(name:Object):DisplayObject
    {
        var assetName:String=null;
        switch (name)
        {
            case "btn_pvp":
            {
                assetName="ui_button_charts_classification3";
                break;
            }
            case "btn_star":
            {
                assetName="ui_button_charts_classification2";
                break;
            }
            case "btn_money":
            {
                assetName="ui_button_charts_classification4"
                break;
            }
            case "btn_fight":
            {
                assetName="ui_button_charts_classification1";
                break;
            }
        }
        if (!image)
        {
            image=new Image(AssetMgr.instance.getTexture(assetName));
        }
        else
        {
            image.texture=AssetMgr.instance.getTexture(assetName);
        }
        return image;
    }

    override public function set y(value:Number):void
    {
        super.y=value;
    }

    override public function get data():Object
    {
        return super.data;
    }
}
