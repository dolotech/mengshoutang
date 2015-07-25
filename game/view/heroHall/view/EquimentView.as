package game.view.heroHall.view
{
    import com.dialog.DialogMgr;
    import com.langue.Langue;

    import flash.geom.Point;

    import feathers.controls.Scroller;
    import feathers.data.ListCollection;
    import feathers.layout.TiledRowsLayout;

    import game.data.ExpData;
    import game.data.Goods;
    import game.data.HeroData;
    import game.data.HeroPriceData;
    import game.data.SkillData;
    import game.data.Val;
    import game.data.WidgetData;
    import game.manager.AssetMgr;
    import game.manager.HeroDataMgr;
    import game.net.message.EquipMessage;
    import game.view.blacksmith.BlacksmithDlg;
    import game.view.blacksmith.render.ExpGridRender;
    import game.view.dispark.DisparkControl;
    import game.view.dispark.data.ConfigDisparkStep;
    import game.view.goodsGuide.GoodsEquipOrForgeDlg;
    import game.view.hero.HeroShow;
    import game.view.heroHall.HeroDialog;
    import game.view.heroHall.SkillDesDialog;
    import game.view.heroHall.render.HeroBodyEquipRender;
    import game.view.heroHall.render.StarBarRender;
    import game.view.loginReward.ResignDlg;
    import game.view.uitils.FunManager;
    import game.view.uitils.Res;
    import game.view.viewBase.EquimentViewBase;

    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.filters.ColorMatrixFilter;
    import starling.text.TextField;
    import starling.textures.Texture;

    /**
     * 英雄装备版面
     * @author Samule
     */
    public class EquimentView extends EquimentViewBase
    {
        /**父类引用*/
        private var _selfParent:HeroDialog=null;
        /**当前英雄数据*/
        private var _currData:HeroData=null;
        /**英雄模型显示*/
        public var _heroAvatar:HeroShow=null;
        /**等级图片*/
        private var _imglevel:Sprite=null;
        /**动画图标*/
        private var _mcImage:MovieClip=null;
        /**星星*/
        private var _starBar:StarBarRender=null;

        public function EquimentView(parent:HeroDialog)
        {
            _selfParent=parent;
            super();
        }

        /**初始化*/
        override protected function init():void
        {
            lable1.text=Langue.getLangue("strengthen"); //铁匠铺
            lable2.text=Langue.getLangue("autoMakeup"); //自动换装

            //装备列表
            const listLayout:TiledRowsLayout=new TiledRowsLayout();
            listLayout.gap=64;
            listLayout.useSquareTiles=false;
            listLayout.useVirtualLayout=true;
            listLayout.tileVerticalAlign=TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.tileHorizontalAlign=TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
            list_equip.layout=listLayout;
            list_equip.verticalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
            list_equip.horizontalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
            list_equip.itemRendererFactory=tileListItemRendererFactory;
            function tileListItemRendererFactory():HeroBodyEquipRender
            {
                var itemRender:HeroBodyEquipRender=new HeroBodyEquipRender();
                itemRender.setSize(101, 92);
                return itemRender;
            }

            const listExpLayout:TiledRowsLayout=new TiledRowsLayout();
            listExpLayout.gap=24;
            listExpLayout.useSquareTiles=false;
            listExpLayout.useVirtualLayout=true;
            listExpLayout.tileVerticalAlign=TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listExpLayout.tileHorizontalAlign=TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;

            list_exp.layout=listExpLayout;
            list_exp.verticalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
            list_exp.horizontalScrollPolicy=Scroller.SCROLL_POLICY_OFF;
            list_exp.itemRendererFactory=expListItemRendererFactory;

            function expListItemRendererFactory():ExpGridRender
            {
                var itemRender:ExpGridRender=new ExpGridRender();
                itemRender.setSize(116, 108);
                return itemRender;
            }
            list_exp.dataProvider=new ListCollection(Goods.getExpList());


            //英雄模型
            _heroAvatar=new HeroShow();
            _heroAvatar.scaleX=_heroAvatar.scaleY=1.1;
            _heroAvatar.x=485;
            _heroAvatar.y=420;
            this.addQuiackChild(_heroAvatar);

            _starBar=new StarBarRender();
            _starBar.x=kuang.x;
            _starBar.y=kuang.y;
            addQuiackChild(_starBar);

            DisparkControl.dicDisplay["hero_fenjie"]=upgradeBtn;
            DisparkControl.dicDisplay["hero_blacksmith"]=btn_blacksmith;

            ico_quality5.touchable=false;

        }

        /**监听*/
        override protected function addListenerHandler():void
        {
            super.addListenerHandler();
            //分解操作
            this.addViewListener(upgradeBtn, Event.TRIGGERED, onHeroUpgrade);
            //跳到铁匠铺操作
            this.addViewListener(btn_blacksmith, Event.TRIGGERED, onJumpBlacksmith);
            //自动换装操作
            this.addViewListener(btn_atuo, Event.TRIGGERED, onAutoEquip);
            //操作装备title
            this.addViewListener(btn_equip5, Event.TRIGGERED, onEquipTitle);
        }

        /**选中更新英雄信息*/
        public function updata(heroData:HeroData):void
        {
            if (heroData && _currData != heroData)
                _heroAvatar.updateHero(heroData);
            if (heroData == null)
                return;
            _currData=heroData;
            heroName.text=_currData.name;
            txt_heroName.text=_currData.name;

            _starBar.updataStar(_currData.foster, 0.8);
            _starBar.offsetXY(kuang.x + (kuang.width - _starBar.width) * 0.5, kuang.y + 70);

            var qualtyid:uint=_currData.quality > 0 ? _currData.quality - 1 : 0;
            effectbg_1.texture=AssetMgr.instance.getTexture("ui_yingxiongkapaiguang_" + qualtyid + "_1");
            effectbg_2.texture=AssetMgr.instance.getTexture("ui_yingxiongkapaiguang_" + qualtyid + "_2");
            effectbg_3.texture=AssetMgr.instance.getTexture("ui_yingxiongkapaiguang_" + qualtyid + "_1");
            effectbg_3.scaleY=-1;
            effectbg_3.y=500;

            updateHeroEquip();

            var index:int=_currData.quality - 1;
            index < 0 ? index=0 : null;
            txt_heroName.color=Val.HERO_COLOR[index];
            var nextLevelData:ExpData=ExpData.hash.getValue(_currData.level);
            var nextExp:int=nextLevelData ? nextLevelData.exp : 0;
            updateExp(_currData.exp / nextExp);

            _imglevel && _imglevel.removeFromParent(true);
            if (_currData.level > 0)
            {
                textLv.text=_currData.level + "";
            }

            var textureVec:Vector.<Texture>=new Vector.<Texture>;
            textureVec.push(AssetMgr.instance.getTexture("ui_gongyong_zheyetubiao" + _currData.job));
            textureVec.push(AssetMgr.instance.getTexture("ui_hero_yingxiongpinzhi_0" + _currData.getQualityImageId()));
            if (_mcImage == null)
            {
                _mcImage=new MovieClip(textureVec, 0.5);
                _mcImage.x=576;
                _mcImage.y=438;
                addChild(_mcImage);
                Starling.juggler.add(_mcImage);
            }
            else
            {
                _mcImage.setFrameTexture(0, AssetMgr.instance.getTexture("ui_gongyong_zheyetubiao" + _currData.job));
                _mcImage.setFrameTexture(1, AssetMgr.instance.getTexture("ui_hero_yingxiongpinzhi_0" + _currData.getQualityImageId()));
                _mcImage.currentFrame=0;
            }
        }

        /**
         * 解散英雄
         */
        private function onHeroUpgrade():void
        {
            if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep16)) //英雄分解功能是否开启
                return;
            //智能判断是否删除功能开放提示图标（分解）
            DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep16);

            if (_currData == null || _currData.id == 0 || HeroDataMgr.instance.hash.keys().length == 1)
                return;
            _selfParent.isVisible=true;
            var tip:ResignDlg=DialogMgr.instance.open(ResignDlg) as ResignDlg;
            var heroPriceData:HeroPriceData=HeroPriceData.hash.getValue((_currData.rarity == 0 ? 1 : _currData.rarity) + "" + _currData.quality) as HeroPriceData;
            tip.text=getLangue("heroDismissalMsg").replace("*", int(FunManager.hero_dismissal(heroPriceData.price, _currData.level))) + ExpData.getExpGoodsBylevel(_currData.level);
            tip.onResign.addOnce(isOkClick);
            function isOkClick():void
            {
                EquipMessage.sendDissolutionMessage(_currData);
            }
        }

        /**装备和经验药水*/
        public function selectEquimp(bool:Boolean=true):void
        {
            if (_currData == null)
                return;
            if (bool)
            {
                list_equip.visible=bool;
                list_exp.visible=!bool;
                btn_equip5.visible=bool;
                ico_quality5.visible=bool;
                equip_title.visible=!bool;
                ico_equip5.visible=bool;
                ico_equipDi.visible=bool;
                var tmp_arr:Array=_currData.getHeroCurrEquipList();
                var widget_title:WidgetData=tmp_arr.pop();
                tag_add.visible=widget_title.getBestEquipByHero(_currData) == null ? false : true;
            }
            else
            {
                list_equip.visible=bool;
                list_exp.visible=!bool;
                btn_equip5.visible=bool;
                ico_quality5.visible=bool;
                ico_equipDi.visible=bool;
                equip_title.visible=bool;
                ico_equip5.visible=bool;
                tag_add.visible=bool;
            }

        }

        /**
         * 跳转铁匠铺
         */
        private function onJumpBlacksmith():void
        {
            _selfParent.isVisible=false;
            DialogMgr.instance.open(BlacksmithDlg, [BlacksmithDlg.EQUIP, _selfParent.heroListPanle.selectedIndex]);
        }

        /**
         * 自动换装
         */
        private function onAutoEquip():void
        {
            _selfParent.selectPanel(0);
            EquipMessage.sendAutoEquip(_currData, _currData.getHeroCurrEquipList());
        }

        /**打开GoodsEquipOrForgeDlg窗口*/
        private function onEquipTitle():void
        {
            _selfParent.isVisible=true;
            DialogMgr.instance.open(GoodsEquipOrForgeDlg, _currData);
        }

        /**
         * 更新玩家装备
         * @param heroData
         */
        private function updateHeroEquip():void
        {
            var tmp_arr:Array=_currData.getHeroCurrEquipList();
            var widget_title:WidgetData=tmp_arr.pop();
            list_equip.dataProvider=new ListCollection(tmp_arr);
            _heroAvatar.updataWeapon();
            showHeroInfomation(_currData);
            showHeroSkill(_currData);
            ico_equip5.visible=_currData.seat5 > 0;
            ico_quality5.visible=_currData.seat5 > 0;
            equip_title.visible=_currData.seat5 == 0;
            tag_add.visible=widget_title.getBestEquipByHero(_currData) == null ? false : true;

            if (_currData.seat5 > 0)
            {
                var equip:WidgetData=WidgetData.hash.getValue(_currData.seat5);
                ico_equip5.texture=getTexture(equip.picture);
                ico_quality5.upState=Res.instance.getQualityPhoto(equip.quality);
                ico_equip5.filter=null;
                ico_quality5.filter=null;
            }
            else
            {

                ico_equip5.filter=new ColorMatrixFilter(Val.filter);
                ico_quality5.filter=new ColorMatrixFilter(Val.filter);
            }
        }

        /**
         * 更新经验
         * @param value
         */
        private function updateExp(value:Number):void
        {
            if (value < 0)
                value=0;
            par.width=145 * (value > 1 ? 1 : value);
            value=(value * 100) >> 0;
            txt_rate.text=value >= 100 ? "N/A" : value + "%";
        }

        /**
         * 英雄属性
         */
        private function showHeroInfomation(heroData:HeroData):void
        {
            var tmpArray:Array=heroData.getAttributes();
            var len:int=tmpArray.length;
            var txt:TextField;
            var key:String;
            for (var i:int=0; i < len; i++)
            {
                key=tmpArray[i];
                txt=fieldView.getChildByName(key + "Value") as TextField;
                txt.text=heroData[key];
            }
        }


        /**
         * 英雄技能
         * @param heroData
         */
        private function showHeroSkill(heroData:HeroData):void
        {
            var skillData:SkillData;
            var icon:Sprite=null;
            var image:Image=null;
            var arr:Array=[];
            for (var i:int=1; i <= 3; i++)
            {
                skillData=SkillData.getSkill(heroData["skill" + i]);
                icon=this["skillIcon_" + i] as Sprite;
                image=(icon.getChildByName("skillIcon") as Image);
                image.touchable=true;
                if (skillData)
                {
                    icon.visible=true;
                    image.texture=AssetMgr.instance.getTexture(skillData.skillIcon);
                    icon.addEventListener(TouchEvent.TOUCH, thochHandler);
                    arr.push(icon);
                }
                else
                {
                    icon.visible=false;
                }
            }

            if (arr.length == 1)
            {
                icon=arr[0] as Sprite;
                icon.x=147;
            }
            else if (arr.length == 2)
            {
                icon=arr[0] as Sprite;
                icon.x=104;
                icon=arr[1] as Sprite;
                icon.x=215.2;
            }
            else if (arr.length == 3)
            {
                icon=arr[0] as Sprite;
                icon.x=51.55;
                icon=arr[1] as Sprite;
                icon.x=147;
                icon=arr[2] as Sprite;
                icon.x=242.2;
            }
        }

        private function thochHandler(e:TouchEvent):void
        {
            var index:uint=0;
            switch (e.currentTarget)
            {
                case skillIcon_1:
                    index=1;
                    break;
                case skillIcon_2:
                    index=2;
                    break;
                case skillIcon_3:
                    index=3;
                    break;
                default:
                    break;
            }

            var touch:Touch=e.getTouch(stage);
            if (touch == null)
                return;
            var skillData:SkillData=SkillData.getSkill(_currData["skill" + index]);
            var p:Point=touch.getLocation(stage);
            switch (touch.phase)
            {
                case TouchPhase.BEGAN:
                    _selfParent.isVisible=true;
                    DialogMgr.instance.open(SkillDesDialog, {data: skillData, point: p});
                    break;
                case TouchPhase.ENDED:
                    DialogMgr.instance.closeDialog(SkillDesDialog);
                    break;
                default:
                    break;
            }
        }

        /**获取英雄数据*/
        public function get currheroData():HeroData
        {
            return _currData
        }

        /**销毁*/
        override public function dispose():void
        {
            super.dispose();
            while (this.numChildren > 0)
            {
                this.getChildAt(0).removeFromParent(true);
            }

            Starling.juggler.remove(_mcImage);
            _currData=null;
            _heroAvatar=null;
            _imglevel=null;
            _mcImage=null;
            _starBar=null;
        }
    }
}
