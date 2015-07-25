package game.view.tavern.render {
    import com.langue.Langue;

    import feathers.dragDrop.IDragSource;

    import game.common.JTLogger;
    import game.data.HeroData;
    import game.data.MercenaryData;
    import game.view.heroHall.render.StarBarRender;
    import game.view.uitils.Res;
    import game.view.viewBase.MercenaryIconBase;

    import starling.core.Starling;
    import starling.display.Sprite;

    import treefortress.spriter.SpriterClip;

    /**
     * 佣兵头像render
     * @author Samuel
     *
     */
    public class MercenaryIconRender extends MercenaryIconBase implements IDragSource {
        private var img_level:Sprite;
        private var selectedAnimation:SpriterClip;
        private var star:StarBarRender;

        public function MercenaryIconRender(animation:SpriterClip = null) {
            super();
            selectedAnimation = animation;
        }

        /**设置data数据，生成UI*/
        override public function set data(value:Object):void {
            super.data = MercenaryData.hash.getValue(value.id) as MercenaryData;
            var arr:Array = Langue.getLans("Mercenary_Icon_Value");
            switch (value.state) {
                case 0: //可以购买 
                    txt_1.visible = false;
                    txt_2.text = arr[0];
                    txt_2.color = 0x30D8F1;
                    lockImage.visible = false;
                    break;
                case 1: //未解锁
                    txt_1.visible = true;
                    txt_2.visible = false;
                    lockImage.visible = true;
                    break;
                case 2: //已经购买
                    txt_1.visible = false;
                    txt_2.text = arr[1];
                    txt_2.color = 0x00FF00;
                    lockImage.visible = false;
                    break;
                default:
                    txt_1.visible = false;
                    txt_2.visible = true;
                    lockImage.visible = true;
                    JTLogger.debug("程序异常");
                    break;
            }
            txt_1.text = data.pointID + arr[2];
            txt_3.visible = false;
            var heroData:HeroData = HeroData.hero.getValue(data.heroID);


            qualitybg.upState = Res.instance.getWinHeroQualityPhoto(data.quality ? data.quality : 1);
            imageIcon.texture = Res.instance.getHeroIcoPhoto(heroData.show);
            this.swapChildren(imageIcon, qualitybg);
            if (data.star > 0) {
                if (star == null) {
                    star = new StarBarRender();
                    star.updataStar(data.star, 0.35);
                    addQuiackChild(star);
                    star.x = 5; //(qualitybg.width - star.width) >> 1;
                    star.y = qualitybg.height - star.height - 6;
                } else {
                    star.updataStar(data.star, 0.35);
                    star.x = 5; // (qualitybg.width - star.width) >> 1;
                    star.y = qualitybg.height - star.height - 6;
                }
            }
        }

        /**选中*/
        override public function set isSelected(value:Boolean):void {
            super.isSelected = value;
            if (!value || data == null || data.id == 0 || (owner && owner.isScrolling))
                return;

            if (data.id > 0) {
                selectedAnimation.play("effect_012");
                selectedAnimation.animation.looping = true;
                Starling.juggler.add(selectedAnimation);
                selectedAnimation.x = this.qualitybg.width >> 1;
                selectedAnimation.y = this.qualitybg.height >> 1;
                addChild(selectedAnimation);
            } else {
                isSelected = false;
            }
        }

        /**销毁*/
        override public function dispose():void {
            super.dispose();
            img_level && img_level.dispose();
            star && star.removeFromParent(true);
            img_level = null;
            star = null;
            selectedAnimation = null;
        }
    }
}



