package game.view.heroHall.view
{
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.utils.Constants;

    import game.data.Goods;
    import game.data.HeroData;
    import game.data.PurgeData;
    import game.data.RoleShow;
    import game.data.WidgetData;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.net.message.EquipMessage;
    import game.view.goodsGuide.EquipInfoDlg;
    import game.view.heroHall.HeroDialog;
    import game.view.heroHall.render.HeroIconRender;
    import game.view.loginReward.ResignDlg;
    import game.view.viewBase.AdvanceViewBase;

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    /**
     * 进阶功能版面
     * @author Samuel
     *
     */
    public class AdvanceView extends AdvanceViewBase
    {
        /**父类引用*/
        private var _selfParent:HeroDialog=null;
        /**当前英雄数据*/
        private var _currData:HeroData=null;
        private var _currHeroRender:HeroIconRender;

        public function AdvanceView(parent:HeroDialog)
        {
            _selfParent=parent;
            super();
        }

        /**当前英雄icon*/
        public function get currHeroRender():HeroIconRender
        {
            return _currHeroRender;
        }

        /**初始化*/
        override protected function init():void
        {
            var arr:Array=Langue.getLans("heroLableName");
            lable1.text=arr[2];

            //初始化文本
            propertyTitle.text=arr[4];
            maxTis1.text=arr[5];
            maxTis2.text=arr[5];
            advanceTitle.text=arr[2];
            advanceMateriaTitle.text=arr[6] + ":";
            advanceNumTitle.text=arr[7] + ":";
            advanceGlodTitle.text=arr[8] + ":";

            _currHeroRender=new HeroIconRender(null, false);
            _currHeroRender.x=71;
            _currHeroRender.y=189;
            _currHeroRender.touchable=false;
            addQuiackChild(_currHeroRender);
        }

        /**初始化监听*/
        override protected function addListenerHandler():void
        {
            this.addViewListener(advanceBtn, Event.TRIGGERED, onHeroJinjie);
            this.addViewListener(stoneImageBg, Event.TRIGGERED, onLookGoods);
        }

        /**选中更新英雄信息*/
        public function updata(heroData:HeroData):void
        {
            if (heroData == null)
                return;
            _currData=heroData;
            heroName.text=_currData.name;
            var colneData:HeroData=_currData.clone() as HeroData;
            colneData.seat=0;
            _currHeroRender.data=colneData;
            showHeroInfomation();

            if (_currData.isUpQuality())
            {
                nowHeroHead.visible=true;
                advanceHeroHead.visible=true;
                advanceBtn.visible=true;

                advanceTitle.visible=advanceMateriaTitle.visible=advanceNumTitle.visible=advanceGlodTitle.visible=lable1.visible=true;
                advacejtBtn.visible=moneyIcon.visible=stonebg.visible=stoneImageBg.visible=stoneImage.visible=advanceNum.visible=advanceMateriaName.visible=advanceGlod.visible=true;

                maxTis1.visible=false;
                maxTis2.visible=false;

                updataHeroHead(nowHeroHead, _currData);
                var data:HeroData=_currData.clone() as HeroData;
                data.quality+=1;
                updataHeroHead(advanceHeroHead, data);

                var purgeData:PurgeData=PurgeData.hash.getValue(_currData.quality); //净化数据
                var goods_id:int=purgeData.materials[0][0];
                var count:int=purgeData.materials[0][1];
                var tmp_goods:Goods=Goods.goods.getValue(goods_id) as Goods;

                moneyIcon.texture=AssetMgr.instance.getTexture(purgeData.type == 1 ? "ui_gongyong_jinbi" : "ui_gongyong_zuanshi");
                stoneImageBg.upState=AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (tmp_goods.quality - 1));
                stoneImage.texture=AssetMgr.instance.getTexture(tmp_goods.picture);
                advanceNum.text=WidgetData.pileByType(goods_id) + "/" + count.toString();
                advanceMateriaName.text=tmp_goods.name;
                advanceGlod.text=purgeData.num.toString();
            }
            else
            {
                nowHeroHead.visible=false;
                advanceHeroHead.visible=false;
                advanceBtn.visible=false;

                advanceTitle.visible=advanceMateriaTitle.visible=advanceNumTitle.visible=advanceGlodTitle.visible=lable1.visible=false;
                advacejtBtn.visible=moneyIcon.visible=stonebg.visible=stoneImageBg.visible=stoneImage.visible=advanceNum.visible=advanceMateriaName.visible=advanceGlod.visible=false;

                maxTis1.visible=true;
                maxTis2.visible=true;
            }
        }

        private function updataHeroHead(heroSprite:Sprite, heroData:HeroData):void
        {
            var img_level:Sprite=null;
            var heroBg:Image=heroSprite.getChildByName("heroBg") as Image;
            heroBg.texture=AssetMgr.instance.getTexture("ui_gongyong_100yingxiongkuang_" + (((heroData.quality - 1)) < 0 ? 0 : (heroData.quality - 1)));
            heroBg.touchable=false;
            heroBg.smoothing=Constants.smoothing;
            var heroIcon:Image=heroSprite.getChildByName("heroIcon") as Image;
            heroIcon.texture=AssetMgr.instance.getTexture((RoleShow.hash.getValue(heroData.show) as RoleShow).photo);
            heroIcon.touchable=false;
            heroIcon.smoothing=Constants.smoothing;
        }

        /**
         * 英雄进阶
         *
         */
        private function onHeroJinjie():void
        {
            var purgeData:PurgeData=PurgeData.hash.getValue(_currData.quality); //净化数据

            if (purgeData == null)
                return;
            var goods_id:int=purgeData.materials[0][0];
            var count:int=purgeData.materials[0][1];

            //英雄已经是最高品质
            if (_currData.quality == 7)
            {
                addTips("MAXQUALITY");
                return;
            }

            if (WidgetData.pileByType(goods_id) < count)
            {
                var tmp_goods:Goods=Goods.goods.getValue(goods_id) as Goods;
                tmp_goods.Price=0;
                _selfParent.isVisible=true;
                DialogMgr.instance.open(EquipInfoDlg, tmp_goods);
                //addTips("materialNotEnough"); //材料不足
                return;
            }

            var tip:ResignDlg=DialogMgr.instance.open(ResignDlg) as ResignDlg;
            tip.text=Langue.getLans("herojinjie")[purgeData.type - 1].replace("*", purgeData.num);
            tip.onResign.addOnce(sendJinjieMsg);

            function sendJinjieMsg():void
            {
                //金币不足
                if (purgeData.type == 1 && GameMgr.instance.coin < purgeData.num)
                {
                    addTips("notEnoughCoin");
                    return;
                }

                //钻石不足
                if (purgeData.type == 2 && GameMgr.instance.diamond < purgeData.num)
                {
                    addTips("diamendNotEnough");
                    return;
                }
                EquipMessage.sendJinjieMessage(_currData);
            }
        }


        private function onLookGoods(e:Event):void
        {

            if (_currData)
            {
                var purgeData:PurgeData=PurgeData.hash.getValue(_currData.quality); //净化数据
                var goods_id:int=purgeData.materials[0][0];
                var data:Goods=Goods.goods.getValue(goods_id) as Goods;
                data=data.clone() as Goods;
                data.Price=0;
                DialogMgr.instance.open(EquipInfoDlg, data);
            }
        }


        /**
         * 英雄属性
         *
         */
        private function showHeroInfomation():void
        {
            var tmpArray:Array=_currData.getAttributes();
            //下一品质属性值
            var nextArray:Array=_currData.getNextPurgePropertys(_currData.getUpQuality());
            var len:int=tmpArray.length;
            var txt:TextField;
            var key:String;
            var currValue:uint=0;
            var nextValue:uint=0;
            var isUpQuality:Boolean=_currData.isUpQuality();

            for (var i:int=0; i < len; i++)
            {
                key=tmpArray[i];
                //当前品质属性值
                currValue=_currData[key];
                nextValue=nextArray[i];
                txt=poxyView.getChildByName(key + "Value") as TextField;
                txt.text=currValue.toString();
                txt=poxyView.getChildByName(key + "AddValue") as TextField;

                if (isUpQuality)
                {
                    //变化值
                    txt.text="+" + nextValue;
                }
                else
                {
                    txt.text="";
                }
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
            this.removeViewListener(advanceBtn, Event.TRIGGERED, onHeroJinjie);

            while (this.numChildren > 0)
            {
                this.getChildAt(0).removeFromParent(true);
            }

            _currData=null;
            _currHeroRender=null;
        }
    }
}
