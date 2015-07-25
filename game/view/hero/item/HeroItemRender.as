package game.view.hero.item
{
    import game.data.HeroData;
    import game.data.RoleShow;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.view.hero.base.HeroListItemRenderBase;

    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    import treefortress.spriter.SpriterClip;

    public class HeroItemRender extends HeroListItemRenderBase
    {
        private var lv:Sprite;
        private var photo:Image;
        private var dataList:Array=[];
        private var selectIcon:SpriterClip;
        private static var cancel:HeroItemRender; //选中的英雄Item
        private static var cancelHeroData:HeroData; //选中的英雄数据
        private var heroData:HeroData;

        public function HeroItemRender()
        {
            super();
            setSize(100, 100);
        }

        override public function set data(value:Object):void
        {
            if (!value)
            {
                return;
            }
            heroData=(value as HeroData);
            if (heroData.id == 0 && heroData.name == "") //不是玩家存在的英雄的数据
            {
                //隐藏一些图标
                qualityImage.visible=false;
//				lvImage.visible=false;
                if (lv)
                    lv.visible=false;
                this.touchable=false;
                removeSelectIcon();
                boxButton.upState=boxButton.downState=AssetMgr.instance.getTexture("ui_gongyong_100yingxiongkuang_kong"); //有灰色人物的人物框
                photo && photo.removeFromParent();
                photo=null;
                super.data=value;
                return;
            }

            qualityImage.visible=true;
//			lvImage.visible=true;
            if (lv)
                lv.visible=true;
            this.touchable=true;

            var texture:Texture=AssetMgr.instance.getTexture("ui_gongyong_100yingxiongkuang_" + (heroData.quality - 1));
            if (texture) //替换人物框皮肤，如果品质为567
            {
                boxButton.upState=texture;
                boxButton.downState=texture;
            }
            else //替换人物框皮肤，品质低的英雄通用人物框
            {
                texture=AssetMgr.instance.getTexture("ui_gongyong_100yingxiongkuang_0");
                boxButton.upState=texture;
                boxButton.downState=texture;
            }
            textLv.text=heroData.level + "";

            //等级
//			lv && lv.removeFromParent(true);
//			lv = GraphicsNumber.instance().getNumber(heroData.level + 1,"ui_shuzi_");
//			addChild(lv);
//			lv.x = lvImage.x + lvImage.width - 3;
//			lv.y = lvImage.y ;
//			lv.touchable = false;
//			qualityImage.touchable = false;

            //人物头像
            if (photo)
            {
                photo.texture=AssetMgr.instance.getTexture((RoleShow.hash.getValue(heroData.show) as RoleShow).photo);
            }
            else
            {
                photo=new Image(AssetMgr.instance.getTexture((RoleShow.hash.getValue(heroData.show) as RoleShow).photo));
                addQuiackChildAt(photo, 1);
//				this.swapChildren(photo, boxButton);
                photo.touchable=false;
            }

            //品质图标
            qualityImage.texture=AssetMgr.instance.getTexture("ui_hero_yingxiongpinzhi_0" + heroData.getQualityImageId());
            removeSelectIcon();
            if (heroData.selectStaut == 1) //如果被选中，添加勾选图标
                addSelectIcon();
            super.data=value;
        }

        override public function set isSelected(value:Boolean):void
        {
            if (this.isSelected == value)
                return;
            //选中英雄
            if (heroData && heroData.selectStaut == 3 && value)
            {
                heroData.selectStaut=1; //选中，默认selectStaut = 1;
                cancel && cancel.removeSelectIcon();
                addSelectIcon();
            }
            super.isSelected=value;
        }

        //添加勾选图标
        public function addSelectIcon():void
        {
            if (cancelHeroData)
                cancelHeroData.selectStaut=3;
            cancelHeroData=heroData;
            if (!selectIcon)
                selectIcon=AnimationCreator.instance.create("effect_012", AssetMgr.instance);
            selectIcon.play("effect_012");
            selectIcon.animation.looping=true;
            Starling.juggler.add(selectIcon);
            selectIcon.x=boxButton.x + boxButton.width >> 1;
            selectIcon.y=boxButton.y + boxButton.height >> 1;
            addChild(selectIcon);
//			ObjectUtil.setToCenter(boxButton,selectIcon);
            cancel=this;
        }

        //移除勾选投标
        public function removeSelectIcon():void
        {
            if (selectIcon)
            {
                selectIcon.stop();
                Starling.juggler.remove(selectIcon);
                selectIcon.removeFromParent();
            }
        }

        override public function dispose():void
        {
            selectIcon && selectIcon.dispose();
            photo && photo.dispose();
            lv && lv.dispose();
            super.dispose();
        }
    }
}
