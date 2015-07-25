package game.view.heroHall.view
{
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.utils.Constants;

    import game.data.Goods;
    import game.data.HeroData;
    import game.data.RoleShow;
    import game.data.StarData;
    import game.data.WidgetData;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.net.message.EquipMessage;
    import game.view.goodsGuide.EquipInfoDlg;
    import game.view.hero.HeroShow;
    import game.view.heroHall.HeroDialog;
    import game.view.heroHall.render.StarBarRender;
    import game.view.viewBase.AultivateViewBase;

    import starling.core.Starling;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;
    import starling.textures.Texture;

    /**
     * 英雄培养版面
     * @author Samuel
     *
     */
    public class AultivateView extends AultivateViewBase
    {

        public function AultivateView(parent:HeroDialog)
        {
            _selfParent=parent;
            super();
        }

        /**英雄模型显示*/
        public var _heroAvatar:HeroShow=null;
        /**当前英雄数据*/
        private var _currData:HeroData=null;
        /**当前英雄星级*/
        private var _currStar:StarBarRender=null;
        /**等级图片*/
        private var _imglevel:Sprite=null;
        /**动画图标*/
        private var _mcImage:MovieClip=null;
        /**下星级英雄星级*/
        private var _nextStar:StarBarRender=null;
        /**父类引用*/
        private var _selfParent:HeroDialog=null;
        /**星星*/
        private var _starBar:StarBarRender=null;

        /**获取英雄数据*/
        public function get currheroData():HeroData
        {
            return _currData
        }

        /**销毁*/
        override public function dispose():void
        {
            this.removeViewListener(upStarBtn, Event.TRIGGERED, onUpStarHandler);
            this.removeViewListener(getBtn, Event.TRIGGERED, onGetMertHandler);

            while (this.numChildren > 0)
            {
                this.getChildAt(0).removeFromParent(true);
            }

            _currData=null;
            _heroAvatar=null;
            _imglevel=null;
            _mcImage=null;
            _currStar=null;
            _nextStar=null;
            _starBar=null;
        }

        /**选中更新英雄信息*/
        public function updata(heroData:HeroData):void
        {
            if (heroData && _currData != heroData)
                _heroAvatar.updateHero(heroData);
            if (heroData == null)
                return;
            _currData=heroData;
            _starBar.updataStar(_currData.foster, 0.8);
            _starBar.offsetXY(kuang.x + (kuang.width - _starBar.width) * 0.5, kuang.y + 70);

            txt_heroName.text=heroData.name;

            var qualtyid:uint=_currData.quality > 0 ? _currData.quality - 1 : 0;
            effectbg_1.texture=AssetMgr.instance.getTexture("ui_yingxiongkapaiguang_" + qualtyid + "_1");
            effectbg_2.texture=AssetMgr.instance.getTexture("ui_yingxiongkapaiguang_" + qualtyid + "_2");
            effectbg_3.texture=AssetMgr.instance.getTexture("ui_yingxiongkapaiguang_" + qualtyid + "_1");
            effectbg_3.scaleY=-1;
            effectbg_3.y=500;

            showHeroInfomation(_currData);

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
                _mcImage.x=275;
                _mcImage.y=437;
                addChild(_mcImage);
                Starling.juggler.add(_mcImage);
            }
            else
            {
                _mcImage.setFrameTexture(0, AssetMgr.instance.getTexture("ui_gongyong_zheyetubiao" + _currData.job));
                _mcImage.setFrameTexture(1, AssetMgr.instance.getTexture("ui_hero_yingxiongpinzhi_0" + _currData.getQualityImageId()));
                _mcImage.currentFrame=0;
            }

            /**-------------------------------------------------------------------------------*/

            nowQuality.texture=AssetMgr.instance.getTexture("ui_gongyong_100yingxiongkuang_" + (((_currData.quality - 1)) < 0 ? 0 : (_currData.quality - 1)));
            nowHead.texture=AssetMgr.instance.getTexture((RoleShow.hash.getValue(_currData.show) as RoleShow).photo);

            var data:HeroData=_currData.clone() as HeroData;
            data.foster+=1;
            nextQuality.texture=AssetMgr.instance.getTexture("ui_gongyong_100yingxiongkuang_" + (((data.quality - 1)) < 0 ? 0 : (data.quality - 1)));
            nextHead.texture=AssetMgr.instance.getTexture((RoleShow.hash.getValue(data.show) as RoleShow).photo);

            _currStar && _currStar.removeFromParent(true);
            _nextStar && _nextStar.removeFromParent(true);
            if (_currData.foster > 0)
            {
                _currStar=new StarBarRender();
                _currStar.touchable=false;
                _currStar.updataStar(_currData.foster, 0.35);
                addChild(_currStar);
                _currStar.x=nowQuality.x + (nowQuality.width - _currStar.width) * .5;
                _currStar.y=nowQuality.y + nowQuality.height - _currStar.height - 6;

            }

            _nextStar=new StarBarRender();
            _nextStar.touchable=false;
            _nextStar.updataStar(_currData.isUpStar() ? _currData.foster + 1 : _currData.foster, 0.35);
            addChild(_nextStar);
            _nextStar.x=nextQuality.x + (nextQuality.width - _nextStar.width) * .5;
            _nextStar.y=nextQuality.y + nextQuality.height - _nextStar.height - 6;

            lock.visible=!_currData.isUpStar();

            /**-------------------------------------------------------------------------------*/

            var starData:StarData=StarData.hash.getValue(_currData.foster + 1);
            if (starData != null)
            {
                var goods:Goods=Goods.goods.getValue(_currData.type);
                var hasCount:int=WidgetData.pileByType(goods.type);
                txt_percent.text=(hasCount + "/" + starData.materialNum);
                par.width=(hasCount / starData.materialNum) >= 1 ? 145 : (hasCount / starData.materialNum) * 145;
                moneyIcon.texture=AssetMgr.instance.getTexture(starData.payType == 1 ? "ui_gongyong_jinbi" : "ui_gongyong_zuanshi");
                moneyTxt.text=starData.money.toString();
                tipsTxt.visible=false;
                moneyIcon.visible=true;
                upStarTxt.visible=true;
                upStarBtn.visible=true;
                enbedStarBtn.visible=false;
            }
            else
            {
                txt_percent.text="?/0";
                par.width=0;
                moneyTxt.text="";
                upStarTxt.visible=false;
                moneyIcon.visible=false;
                tipsTxt.visible=true;
                upStarBtn.visible=false;
                enbedStarBtn.visible=true;
            }
        }

        /**初始化监听*/
        override protected function addListenerHandler():void
        {
            this.addViewListener(upStarBtn, Event.TRIGGERED, onUpStarHandler);
            this.addViewListener(getBtn, Event.TRIGGERED, onGetMertHandler);
        }

        /**初始化*/
        override protected function init():void
        {
            var arr:Array=Langue.getLans("heroLableName"); //"英雄|升星|进化|经验药品"

            //英雄模型
            _heroAvatar=new HeroShow();
            _heroAvatar.scaleX=_heroAvatar.scaleY=1.1;
            _heroAvatar.x=180;
            _heroAvatar.y=395;
            this.addQuiackChild(_heroAvatar);

            _starBar=new StarBarRender();
            _starBar.x=kuang.x;
            _starBar.y=kuang.y;
            addQuiackChild(_starBar);

            enbedStarBtn.visible=false;
        }

        /**获取物品*/
        private function onGetMertHandler(e:Event):void
        {
            var goods:Goods=Goods.goods.getValue(_currData.type);
            goods.isPack=true;
            goods.isForge=false;
            _selfParent.isVisible=true;
            DialogMgr.instance.open(EquipInfoDlg, goods);
        }

        /**进行升星*/
        private function onUpStarHandler(e:Event):void
        {
            var good:Goods=Goods.goods.getValue(_currData.type);
            var starData:StarData=StarData.hash.getValue(_currData.foster + 1);
            var hasCount:int=WidgetData.pileByType(good.type);
            //材料不足
            if (hasCount < starData.materialNum)
            {
                good.isPack=true;
                good.isForge=false;
                _selfParent.isVisible=true;
                DialogMgr.instance.open(EquipInfoDlg, good);
                addTips("materialNotEnough");
                return;
            }

            //金币不足
            if (starData.payType == 1 && GameMgr.instance.coin < starData.money)
            {
                addTips("notEnoughCoin");
                return;
            }

            //钻石不足
            if (starData.payType == 2 && GameMgr.instance.diamond < starData.money)
            {
                addTips("diamendNotEnough");
                return;
            }
            EquipMessage.sendStarMessage(_currData);
        }

        /**
         * 英雄属性
         *
         */
        private function showHeroInfomation(heroData:HeroData):void
        {
            var tmpArray:Array=heroData.getAttributes();
            //下一星属性值
            var nextArray:Array=heroData.getNextStarPropertys(heroData.getUpStar());
            var len:int=tmpArray.length;
            var txt:TextField;
            var key:String;
            var currvalue:int=0;
            var nextValue:int=0;
            var isUpStar:Boolean=heroData.isUpStar();
            for (var i:int=0; i < len; i++)
            {
                key=tmpArray[i];
                //当前星属性值
                currvalue=_currData[key];
                nextValue=nextArray[i];
                txt=proxy.getChildByName(key + "Value") as TextField;
                if (isUpStar)
                {
                    txt.color=0x00ff00;
                    txt.text="+" + nextValue;
                }
                else
                {
                    txt.color=0xfff831;
                    txt.text="  " + "MAX";
                }
            }
        }
    }
}


