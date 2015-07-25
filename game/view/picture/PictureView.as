package game.view.picture
{
    import com.utils.ArrayUtil;
    import com.utils.ObjectUtil;

    import feathers.controls.Scroller;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ListCollection;
    import feathers.layout.TiledColumnsLayout;
    import feathers.layout.TiledRowsLayout;

    import game.common.JTSession;
    import game.data.HeroData;
    import game.net.data.c.CPictorialial;
    import game.net.data.s.SPictorialial;
    import game.net.data.vo.Pictorial;
    import game.view.dispark.DisparkControl;
    import game.view.dispark.data.ConfigDisparkStep;
    import game.view.uitils.PageView;
    import game.view.viewBase.PictureViewBase;

    import starling.events.Event;

    /**
     * 图鉴
     * @author hyy
     *
     */
    public class PictureView extends PictureViewBase
    {
        private var view_info:PictureInfoView;
        private var view_page:PageView;

        public function PictureView()
        {
            super();
        }

        override protected function init():void
        {
            enableTween=true;
            _closeButton=btn_close;
            const listLayout:TiledRowsLayout=new TiledRowsLayout();
            listLayout.useSquareTiles=false;
            listLayout.useVirtualLayout=true;
            listLayout.tileVerticalAlign=TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
            listLayout.tileHorizontalAlign=TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
            listLayout.paging=TiledColumnsLayout.PAGING_HORIZONTAL; //自动排列
            listLayout.paddingTop=10;
            list_pic.layout=listLayout;
            list_pic.snapToPages=true;
            list_pic.verticalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
            list_pic.itemRendererFactory=itemRendererFactory;

            function itemRendererFactory():IListItemRenderer
            {
                const renderer:PictureRender=new PictureRender();
                renderer.setSize(110, 150);
                return renderer;
            }

            view_page=new PageView(Math.ceil(HeroData.hero.values().length / 12), 4);
            addChild(view_page);
            ObjectUtil.setToCenter(this, view_page);
            view_page.y=425;

            clickBackroundClose();
        }

        override protected function addListenerHandler():void
        {
            super.addListenerHandler();
            this.addViewListener(tabMenu, Event.CHANGE, onTabMenuHandler);
            this.addViewListener(list_pic, Event.CHANGE, onListHandler);
            this.addViewListener(list_pic, Event.SCROLL, onListScrollHanlder);
            this.addContextListener(CPictorialial.CMD + "", updateHeroList);
        }

        override protected function openTweenComplete():void
        {
            setToCenter();
            tabMenu.selectedIndex=0;
            //请求图鉴列表
            sendMessage(CPictorialial);
        }

        /**
         * 获取图鉴列表，更新图鉴界面
         * @param evt
         * @param info
         *
         */
        private function updateHeroList(evt:Event, info:SPictorialial):void
        {
            HeroData.getHeroList.length=0;
            //英雄数据里面所有英雄
            var heroArray:Array=ArrayUtil.change2Array(HeroData.hero.values());

            for each (var hero:Pictorial in info.herose)
            {
                HeroData.getHeroList.push(hero.id);
            }


            //排序，优先已获得的和老英雄
            heroArray.sortOn(["isGet", "get_hard"], [Array.DESCENDING, 0]);
            list_pic.dataProvider=new ListCollection(heroArray);
            //更新数量
            txt_count.text=info.herose.length + "/" + HeroData.hero.values().length;
        }

        /**
         * 点击英雄查看详细信息
         * @param evt
         *
         */
        private function onListHandler(evt:Event):void
        {
            if (list_pic.selectedItem == null)
                return;
            var heroData:HeroData=list_pic.selectedItem as HeroData;

            if (view_info == null)
                view_info=new PictureInfoView();
            view_info.heroData=heroData;
            JTSession.layerPanel.addChild(view_info.background);
            JTSession.layerPanel.addChild(view_info);
            view_info.easingIn();
            list_pic.selectedIndex=-1;
        }

        private function onListScrollHanlder(evt:Event):void
        {
            view_page.selectedIndex=list_pic.horizontalPageIndex;
        }

        private function onTabMenuHandler(evt:Event):void
        {

        }

        override public function close():void
        {
            //智能判断是否删除功能开放提示图标（图鉴）
            DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep2);

            super.close();
        }

        override public function dispose():void
        {
            super.dispose();

            if (view_info)
                view_info.dispose();
        }

    }
}
