package game.view.blacksmith.render {
    import com.view.base.event.EventType;
    import com.view.base.event.ViewDispatcher;

    import game.data.WidgetData;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.view.viewBase.NewHeroBodyEquipRenderBase;

    import starling.core.Starling;

    import treefortress.spriter.SpriterClip;

    /**
     * 英雄人物身上装备
     * @author hyy
     *
     */
    public class NewHeroBodyEquipRender extends NewHeroBodyEquipRenderBase {
        public static var selectedAnimation:SpriterClip;

        public function NewHeroBodyEquipRender() {
            super();
        }

        override public function set data(value:Object):void {
            super.data = value;

            if (value == null)
                return;
            var widget:WidgetData = value as WidgetData;
            //强化等级
            txt_level.text = (widget.level > 0 ? "+" + widget.level : "");

            //装备图标
            if (widget.picture)
                ico_equip.texture = AssetMgr.instance.getTexture(widget.picture);
            ico_equip.visible = widget.picture != null;
            tag_equip.visible = !ico_equip.visible;
            //装备类型
            tag_equip.texture = AssetMgr.instance.getTexture("ui_yingxiongshengdian_wuqikuangbiaozhi" + (widget.sort > 0 ? widget.sort : 1));
            //装备品质
            tag_bg.upState = AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (widget.quality > 0 ? (widget.quality - 1) : 0));
            tag_add.visible = widget.hasBestEquip;
            _isSelected = false;
        }

        override public function set isSelected(value:Boolean):void {
            var tmp_isSelected:Boolean = _isSelected;
            super.isSelected = value;

            if (!value || (owner && owner.isScrolling))
                return;

            if (!tmp_isSelected) {
                if (selectedAnimation == null)
                    selectedAnimation = AnimationCreator.instance.create("effect_012", AssetMgr.instance);
                selectedAnimation.play("effect_012");
                selectedAnimation.animation.looping = true;
                Starling.juggler.add(selectedAnimation);
                selectedAnimation.x = tag_bg.width >> 1;
                selectedAnimation.y = tag_bg.height >> 1;
                addChild(selectedAnimation);

                ViewDispatcher.dispatch(EventType.UPDATE_BODYEQUIP_SELECTED, data);
            }
        }
    }
}
