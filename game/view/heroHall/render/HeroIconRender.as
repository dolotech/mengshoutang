package game.view.heroHall.render
{
    import com.view.base.event.EventType;
    import com.view.base.event.ViewDispatcher;

    import flash.geom.Point;

    import feathers.controls.Scroller;
    import feathers.dragDrop.DragData;
    import feathers.dragDrop.DragDropManager;
    import feathers.dragDrop.IDragSource;
    import feathers.events.DragDropEvent;

    import game.data.HeroData;
    import game.data.RoleShow;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.manager.HeroDataMgr;
    import game.view.viewBase.NewHeroIcoRenderBase;

    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    import treefortress.spriter.SpriterClip;

    /**
     * 英雄头像render
     * @author hyy
     *
     */
    public class HeroIconRender extends NewHeroIcoRenderBase implements IDragSource
    {
        private static var curr_target:HeroIconRender;
        private static var curr_point:Point;
        private var selectedAnimation:SpriterClip;
        private var star:StarBarRender;
        private var heroData:HeroData;

        public function HeroIconRender(animation:SpriterClip=null, isDragEnable:Boolean=false)
        {
            super();
            selectedAnimation=animation;
            tag_bg.touchable=true;
            this.isDragEnable=isDragEnable;
        }

        override public function set data(value:Object):void
        {
            super.data=value;
            heroData=value as HeroData;

            tag_battle.visible=heroData && heroData.seat > 0;
            txt_open.visible=heroData && heroData.id == -1;
            txt_desopen.visible=heroData && heroData.id == -1;

            if (heroData == null)
                return;
            if (heroData.id == -1)
                txt_open.text=HeroDataMgr.instance.hash.size() + "/" + GameMgr.instance.hero_gridCount;
            //品质图标
            if (heroData.quality > 0)
                btn_bg.upState=btn_bg.downState=AssetMgr.instance.getTexture("ui_gongyong_100yingxiongkuang_" + (heroData.quality - 1));
            btn_bg.visible=heroData.quality > 0;
            //头像
            updateImgByType(ico_head, heroData.show > 0 ? (RoleShow.hash.getValue(heroData.show) as RoleShow).photo : "", heroData.show);
            //标志
            updateImgByType(img_tag, "ui_gongyong_zheyetubiao" + heroData.job, heroData.job);

            if (heroData.level > 0)
            {
                textLv.text=heroData.level + "";
            }
            else
            {
                textLv.text="";
            }

            if (heroData.foster > 0)
            {
                if (star == null)
                {
                    star=new StarBarRender();
                    star.updataStar(heroData.foster, 0.35);
                    addQuiackChild(star);
                    star.x=8;
                    star.y=tag_bg.height - star.height - 8;
                }
                else
                {
                    star.updataStar(heroData.foster, 0.35);
                    star.x=8;
                    star.y=tag_bg.height - star.height - 8;
                }
            }
            else
            {
                star && star.removeFromParent(true);
            }
        }

        private function updateImgByType(img:Image, type:String, value:int):void
        {
            if (value > 0)
            {
                tag_bg.texture=AssetMgr.instance.getTexture("ui_gongyong_100yingxiongkuang_kong1");
                img.texture=AssetMgr.instance.getTexture(type);
            }
            else
            {
                tag_bg.texture=AssetMgr.instance.getTexture("ui_gongyong_100yingxiongkuang_kong");
            }
            img.visible=value > 0;
        }

        override public function set isSelected(value:Boolean):void
        {
            super.isSelected=value;

            if (!value || data == null || data.id == 0 || (owner && owner.isScrolling))
                return;

            if (data.id > 0)
            {
                selectedAnimation.play("effect_012");
                selectedAnimation.animation.looping=true;
                Starling.juggler.add(selectedAnimation);
                selectedAnimation.x=btn_bg.width / 2;
                selectedAnimation.y=btn_bg.height / 2;
                addChild(selectedAnimation);
            }
            else
            {
                isSelected=false;
            }
        }

        private var isDraging:Boolean;

        public function set isDragEnable(value:Boolean):void
        {
            if (value)
            {
                this.addEventListener(TouchEvent.TOUCH, touchHandler);
                this.addEventListener(DragDropEvent.DRAG_COMPLETE, dragCompleteHandler);
            }
            else
            {
                this.removeEventListener(TouchEvent.TOUCH, touchHandler);
                this.removeEventListener(DragDropEvent.DRAG_COMPLETE, dragCompleteHandler);
            }
        }

        private function touchHandler(event:TouchEvent):void
        {
            if (DragDropManager.isDragging || heroData == null || heroData.id == 0 || heroData.seat > 0)
                return;

            if (!isDraging)
            {
                var touch:Touch=event.getTouch(this);

                if (touch == null)
                    return;

                if (touch.phase == TouchPhase.MOVED)
                {
                    if (curr_point == null)
                        curr_point=this.localToGlobal(new Point());

                    if (touch.globalY - curr_point.y <= 0)
                    {
                        isDraging=true;
                        var dragData:DragData=new DragData();

                        if (curr_target == null)
                        {
                            curr_target=new HeroIconRender(selectedAnimation);
                            curr_target.touchable=false;
                        }
                        curr_target.data=heroData;
                        dragData.setDataForFormat("hero", heroData);
                        DragDropManager.startDrag(this, touch, dragData, curr_target, -btn_bg.width * .5, -btn_bg.height * .5);
                        owner.horizontalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
                        owner.stopScrolling();
                    }
                }
                else if (touch.phase == TouchPhase.ENDED)
                {
                    isDraging=false;
                }
                return;
            }
            isDraging=false;
        }

        private function dragCompleteHandler(event:DragDropEvent, dragData:DragData):void
        {
            owner.horizontalScrollPolicy=Scroller.SCROLL_POLICY_ON;

            if (HeroDataMgr.instance.isMaxBattle)
                ViewDispatcher.dispatch(EventType.UPDATE_HERO_LIST_STATUS, -1);
        }

        override public function dispose():void
        {
            super.dispose();
            isDragEnable=false;
            star && star.removeFromParent(true);
            star=null;
            selectedAnimation=null;
            heroData=null;
        }
    }
}


