package game.scene.world
{
    import com.dialog.DialogMgr;
    import com.sound.SoundManager;
    import com.utils.Constants;

    import feathers.controls.Scroller;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ListCollection;
    import feathers.layout.TiledColumnsLayout;
    import feathers.layout.TiledRowsLayout;

    import game.data.MainLineData;
    import game.data.TollgateData;
    import game.manager.GameMgr;
    import game.net.message.GameMessage;
    import game.net.message.GoodsMessage;
    import game.view.dispark.DisparkControl;
    import game.view.dispark.data.ConfigDisparkStep;

    import starling.core.Starling;
    import starling.display.Image;
    import starling.events.Event;
    import starling.text.TextField;

    /**
     * 副本
     * @author hyy
     *
     */
    public class NewFbScene extends NewMainWorld
    {
        public static var curr_pos:int=-1;

        public function NewFbScene()
        {
            super();
        }

        override protected function init():void
        {
            view_reward.scaleX=view_reward.scaleY=Constants.isScaleWidth ? Constants.standardWidth / Constants.FullScreenWidth : 1;
            DialogMgr.instance.closeAllDialog();
            GameMgr.instance.game_type=GameMgr.FB;

            SoundManager.instance.playSound("worldmap_bgm", true, 0, 99999);
            SoundManager.instance.tweenVolume("worldmap_bgm", 1.0, 2);

            btn_return.x=Constants.virtualWidth - btn_return.width - 50;
            tag_return.x=btn_return.x + btn_return.width * .5;

            const listLayout:TiledColumnsLayout=new TiledColumnsLayout();
            listLayout.useSquareTiles=false;
            listLayout.useVirtualLayout=true;
            listLayout.tileVerticalAlign=TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.tileHorizontalAlign=TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
            list_map.width=Constants.virtualWidth;
            list_map.layout=listLayout;
            list_map.horizontalScrollPolicy=Scroller.SCROLL_POLICY_ON;
            list_map.verticalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
            list_map.itemRendererFactory=itemRendererFactory;

            function itemRendererFactory():IListItemRenderer
            {
                const renderer:NewMainWorldRender=new NewMainWorldRender();
                renderer.setSize(1840, list_map.height);
                return renderer;
            }

			const equiplistLayout : TiledColumnsLayout = new TiledColumnsLayout();
			equiplistLayout.paddingLeft = -40;
			equiplistLayout.gap = -15;
            equiplistLayout.useSquareTiles=true;
            equiplistLayout.useVirtualLayout=true;
            equiplistLayout.tileHorizontalAlign=TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
            equiplistLayout.paging=TiledColumnsLayout.PAGING_HORIZONTAL; //自动排列
            list_reward.layout=equiplistLayout;
            list_reward.verticalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
            list_reward.itemRendererFactory=itemEquipRendererFactory;

            function itemEquipRendererFactory():IListItemRenderer
            {
                const renderer:NewMainRewardRender=new NewMainRewardRender();
                renderer.setSize(102, 120);
                return renderer;
            }

            view_reward.x=Constants.virtualWidth * .5;
            view_reward.y=Constants.virtualHeight;
            view_title.x=view_reward.x;
            view_title.y=-view_title.height;
            view_title.visible=view_reward.visible=false;
            tag_modle=view_reward.getChildByName("tag_modle") as Image;

            TextField(view_reward.getChildByName("txt_des2")).text=getLangue("hard_modle");
            addMask(tag_modle);
        }

        /**
         * 地图滚动
         *
         */
        override protected function listMapScroll():void
        {
            if (curr_pos == list_map.horizontalScrollPosition)
                return;
            curr_pos=list_map.horizontalScrollPosition;
            hiddenBottomHandler();
        }

        override protected function show():void
        {
            updateTired();
            onModleClick();

            var mainLineData:MainLineData=new MainLineData();
            var tmp_list:Array=[];
            var data:MainLineData;
            mainLineData.startIndex=1001;
            mainLineData.chapterID=1001;

            for (var i:int=1001; i <= 1013; i++)
            {
                data=MainLineData.getPoint(i);
                tmp_list.push(data);
            }
            mainLineData.chapterScope=tmp_list;
            list_map.dataProvider=new ListCollection([mainLineData]);

            if (NewMainWorld.buy_tired)
            {
                NewMainWorld.buy_tired=false;
                GoodsMessage.onBuyTiredClick();
            }

            if (curr_pos != -1)
                list_map.scrollToPosition(curr_pos, 0);

            //智能判断是否删除功能开放提示图标（副本）
            DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep8);
        }

        /**
         * 噩梦难度选择
         *
         */
        override protected function onModleClick(evt:Event=null, isRest:Boolean=false):void
        {
            if (isRest)
            {
                isTweening=false;
                isNightmare=false;
                Starling.juggler.removeTweens(tag_modle);
                tag_modle.x=-tag_modle.width * .5;
                isPlayNightMareAnimation=false;
                return;
            }

            if (isTweening)
                return;

            if (evt)
                isNightmare=!isNightmare;

            if (selected_data && selected_data.nightmareData)
            {
                var nightmareData:TollgateData=selected_data.nightmareData;
                var mainLineData:MainLineData=MainLineData.getPoint(nightmareData.id);

                if (GameMgr.instance.tollgateID < mainLineData.pointID)
                {
                    var lastPoint:MainLineData=MainLineData.getPoint(mainLineData.pointID - 1);
                    addTips(getLangue("onOpen") + (lastPoint ? lastPoint.pointName : ""));
                    return;
                }
                onSelectedMainLine(evt, isNightmare ? nightmareData : selected_data, false);
				if(isNightmare){
					//删除New图标
					DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep10);
				}
            }

            tweenTab(tag_modle, isNightmare, onComplete);

            function onComplete():void
            {
                isPlayNightMareAnimation=isNightmare;
                isTweening=false;
            }
        }

        /**
         * 隐藏奖励框
         *
         */
        override protected function hiddenBottomHandler():void
        {
            if (isTweeningBottom || view_reward.y == Constants.virtualHeight)
                return;
            isPlayNightMareAnimation=false;
            isTweeningBottom=true;
            Starling.juggler.tween(view_reward, 0.3, {y: Constants.virtualHeight, onComplete: onComplete});
            Starling.juggler.tween(view_title, 0.3, {y: -view_title.height});

            function onComplete():void
            {
                selected_data=null;
                view_title.visible=view_reward.visible=false;
                isTweeningBottom=false;
            }
        }

        /**
         * 开始加载战斗资源
         *
         */
        override protected function onBattleClick():void
        {
            var tollgateData:TollgateData=isNightmare ? selected_data.nightmareData : selected_data;

            if (tollgateData == null)
                return;

            GameMessage.gotoTollgateData(tollgateData.id);
        }

    }
}

