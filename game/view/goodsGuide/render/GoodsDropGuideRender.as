package game.view.goodsGuide.render
{
    import com.components.RollTips;
    import com.langue.Langue;
    import com.view.base.event.EventType;
    import com.view.base.event.ViewDispatcher;

    import game.data.ConfigData;
    import game.data.MainLineData;
    import game.data.TollgateData;
    import game.data.Val;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.view.viewBase.GoodsDropGuideRenderBase;

    import starling.events.Event;

    /**
     * 物品掉落
     * @author hyy
     *
     */
    public class GoodsDropGuideRender extends GoodsDropGuideRenderBase
    {
        private var isOpen:Boolean;

        public function GoodsDropGuideRender()
        {
            super();
            addEventListener(Event.TRIGGERED, onClick);
        }

        override public function set data(value:Object):void
        {
            if (value == null)
                return;
            var mainLineData:MainLineData=value as MainLineData;
            super.data=mainLineData;

            if (mainLineData == null && value && value.data != Val.DROP_PVP && value.data != Val.DROP_PVP_GET)
                return;

            if (mainLineData)
            {
                if (mainLineData.isNightMare)
                {
                    var tollgateData:TollgateData=TollgateData.hash.getValue(mainLineData.id);
                    isOpen=tollgateData.nightmare_star == 7;
                }
                else
                    isOpen=GameMgr.instance.tollgateID >= mainLineData.pointID;

            }
            else
            {
                super.data=value.data;
                isOpen=GameMgr.instance.tollgateID > ConfigData.instance.arenaGuide;
            }

            if (mainLineData)
            {
                txt_drop.text=mainLineData.pointName;
                ico_hero.texture=AssetMgr.instance.getTexture(mainLineData.points_ico);
                txt_droptype.text=mainLineData.isFb ? Langue.getLangue("fb") : Langue.getLangue("mainLine");
            }
            else
            {
                txt_droptype.text="";
                ico_hero.texture=AssetMgr.instance.getTexture("ui_zhuxian_bigboss_airenguowang");
                txt_drop.text=Langue.getLangue("pvp");
            }
            txt_des1.text=((mainLineData || value.data == Val.DROP_PVP) ? Langue.getLangue("drop_type1") : Langue.getLangue("drop_type2")) + " :";
            txt_isOpen.text=Langue.getLangue(isOpen ? "tollgate_open" : "tollgate_close");
            txt_isOpen.color=isOpen ? 0x00ff00 : 0xff0000;
        }

        public function onClick():void
        {
            if (!isOpen && data)
            {
                var lastPoint:MainLineData=MainLineData.getPoint(data.pointID - 1);
                RollTips.add(Langue.getLangue("onOpen") + "  " + (lastPoint ? lastPoint.pointName : ""));
                return;
            }

            if (owner && !owner.isScrolling && data is MainLineData)
                ViewDispatcher.dispatch(EventType.CHANGE_BATTLE, data.id);
            else
                ViewDispatcher.dispatch(EventType.OPEN_ARENA, data);
        }

        override public function dispose():void
        {
            super.dispose();
            removeEventListener(Event.TRIGGERED, onClick);
        }
    }
}


