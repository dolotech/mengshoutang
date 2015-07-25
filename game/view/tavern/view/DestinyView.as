package game.view.tavern.view
{
    import com.langue.Langue;
    import com.utils.Constants;

    import flash.geom.Point;

    import game.common.JTLogger;
    import game.common.JTSession;
    import game.data.ConfigData;
    import game.data.Goods;
    import game.dialog.ShowLoader;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.net.data.IData;
    import game.net.data.c.CGetherosoul;
    import game.net.data.c.CHerosoul;
    import game.net.data.s.SGetherosoul;
    import game.net.data.s.SHerosoul;
    import game.net.data.vo.heroSoulList;
    import game.net.message.base.Message;
    import game.view.magicorbs.render.RockTween;
    import game.view.tavern.TavernDialog;
    import game.view.tavern.data.TavernData;
    import game.view.uitils.Res;
    import game.view.viewBase.DestinyViewBase;

    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import treefortress.spriter.SpriterClip;

    /**
     * 命运之轮
     * @author Samuel
     *
     */
    public class DestinyView extends DestinyViewBase
    {

        /**父类引用*/
        private var _selfParent:TavernDialog=null;
        /**转轮*/
        private var _effectSp:SpriterClip=null;
        /**抽取类型*/
        private var _type:uint=0;
        /**是否在刷新*/
        private var isRefresh:Boolean=false;
        /**自己版面*/
        private var _this:DestinyView=null;
        /**是否已经初始化数据*/
        private var isInitData:Boolean;
        /**飞动效果列表*/
        private var flyList:Vector.<IData>=null;



        public function DestinyView(parent:TavernDialog)
        {

            _selfParent=parent;
            _this=this;
            super();
        }

        /**初始化*/
        public function initData():void
        {
            if (!isInitData)
            {
                isInitData=true;
                if (!TavernData.instance.fushData2.isSend)
                {
                    var cmd:CHerosoul=new CHerosoul();
                    cmd.type=0;
                    Message.sendMessage(cmd);
                }
                else
                {
                    TavernData.instance.fushData2.startTime();
                    TavernData.instance.fushData3.startTime();
                    cdTime();
                    cdCoinTime();
                    updata();
                }

                fushNum.text=ConfigData.instance.herosoul_refresh.toString();
                buyNum_0.text=(ConfigData.instance.herosoul_cq * TavernData.instance.hasSoul).toString();
                buyNum_1.text=ConfigData.instance.herosoul_cq.toString();
                buyNum_2.text=ConfigData.instance.herosoul_coin_count.toString();
                desTxt.text=Langue.getLangue("DESTINY_RULE_DES");
            }

        }

        override protected function show():void
        {
            _effectSp=AnimationCreator.instance.create("effect_mingyunzhilun", AssetMgr.instance);
            Starling.juggler.add(_effectSp);
            _effectSp.play("round1");
            _effectSp.animation.id=1;
            _effectSp.animation.looping=true;
            _effectSp.touchable=false;
            _effectSp.x=268;
            _effectSp.y=278;
            addQuiackChildAt(_effectSp, 0);

        }

        /**初始化监听*/
        override protected function addListenerHandler():void
        {

            this.addViewListener(fushBtn, Event.TRIGGERED, onClickHandler);
            this.addViewListener(buyBtn_0, Event.TRIGGERED, onClickHandler);
            this.addViewListener(buyBtn_1, Event.TRIGGERED, onClickHandler);
            this.addViewListener(buyBtn_2, Event.TRIGGERED, onClickHandler);
            this.addContextListener(SHerosoul.CMD.toString(), onHeroSoulHandler);
            this.addContextListener(SGetherosoul.CMD.toString(), onGetherosoulHandler);
        }

        /**刷新返回*/
        private function onHeroSoulHandler(event:Event, info:SHerosoul):void
        {
            switch (info.code)
            {
                case 0: //成功
                    TavernData.instance.heroSoulVector=info.herosoul.sort(function(a:heroSoulList, b:heroSoulList):int
                    {
                        if (a.pos < b.pos)
                        {
                            return -1;
                        }
                        else if (a.pos > b.pos)
                        {
                            return 1;
                        }
                        return 0;
                    });
                    TavernData.instance.fushData2.time=info.time;
                    TavernData.instance.fushData3.time=info.coin_time;
                    TavernData.instance.leftTimes=info.lefttimes;
                    TavernData.instance.fushData2.startTime();
                    TavernData.instance.fushData3.startTime();
                    TavernData.instance.fushData2.isSend=true;
                    if (isRefresh)
                    {
                        isRefresh=false;
                        _effectSp.play("round2");
                        _effectSp.animationComplete.addOnce(animationComplete);

                        var effect:SpriterClip=AnimationCreator.instance.create("effect_mingyunzhilun", AssetMgr.instance);
                        Starling.juggler.add(effect);
                        effect.play("round3");
                        effect.animation.id=2;
                        effect.animation.looping=true;
                        effect.touchable=false;
                        effect.animationComplete.addOnce(onCompletes);
                        effect.x=268;
                        effect.y=278;
                        addQuiackChildAt(effect, 1);
                        cdTime();

                    }
                    else
                    {
                        enbledTouchable(true);
                        buyNum_0.text=(ConfigData.instance.herosoul_cq * TavernData.instance.hasSoul).toString();
                        cdTime();
                        cdCoinTime();
                        updata();
                    }
                    break;
                case 1: //砖石不足
                    addTips(Langue.getLangue("diamendNotEnough"));
                    break;
                case 2: //配置错误
                    addTips(Langue.getLangue("Configuration_ERR"));
                    break;

            }
            ShowLoader.remove();

        }

        /**刷新吃cd*/
        private function cdTime():void
        {
            TavernData.instance.fushData2.cdTime(fushTime); //免费倒计时
            if (TavernData.instance.fushData2.time <= 0)
            {
                onTimeEnd();
                return;
            }
            TavernData.instance.fushData2.onTimeEnd.remove(onTimeEnd);
            TavernData.instance.fushData2.onTimeEnd.addOnce(onTimeEnd);
        }

        private var isRefreshEff:Boolean;

        private function onTimeEnd():void
        {
            TavernData.instance.fushData2.onTimeEnd.remove(onTimeEnd);
            fushTime.text="00:00:00";
            isRefresh=isRefreshEff;
            isRefreshEff=true;
            var cmd:CHerosoul=new CHerosoul();
            cmd.type=0;
            Message.sendMessage(cmd);
        }


        /**金币cd*/
        private function cdCoinTime():void
        {
            TavernData.instance.fushData3.cdTime(buyTimeNum); //免费倒计时
            if (TavernData.instance.fushData3.time <= 0)
            {
                onCoinTimeEnd();
                return;
            }
            TavernData.instance.fushData3.onTimeEnd.remove(onCoinTimeEnd);
            TavernData.instance.fushData3.onTimeEnd.addOnce(onCoinTimeEnd);
        }

        private function onCoinTimeEnd():void
        {
            TavernData.instance.fushData3.onTimeEnd.remove(onCoinTimeEnd);
            buyTimeNum.text="00:00:00";
        }

        /**抽取返回*/
        private function onGetherosoulHandler(event:Event, info:SGetherosoul):void
        {
            getIndex=-1;
            noIndex=-1;
            switch (info.code)
            {
                case 0: //成功
                    var hs:heroSoulList=null;
                    var vect:Vector.<IData>=TavernData.instance.heroSoulVector;
                    var len:int=vect.length;
                    JTLogger.debug("服务端返回位置" + info.pos, " 服务端返回id" + info.id);
                    if (_type == 1 || _type == 2)
                    {
                        if (_type == 1)
                        {
                            //TavernData.instance.fushData3.time=info.time;
                            TavernData.instance.fushData3.time=ConfigData.instance.herosoul_coin_cd;
                            TavernData.instance.fushData3.startTime();
                            cdCoinTime();
                            //TavernData.instance.leftTimes=info.num;
                            TavernData.instance.leftTimes--;
                            if (TavernData.instance.leftTimes <= 0)
                            {
                                TavernData.instance.leftTimes=0;
                            }
                            leftTmies.text=TavernData.instance.leftTimes.toString() + '/' + ConfigData.instance.herosoul_cq_times;
                        }
                        flyList=new Vector.<IData>;
                        con: for (var i:int=0; i < len; i++)
                        {
                            hs=vect[i] as heroSoulList;
                            if (hs.pos == info.pos)
                            {
                                noIndex=i;
                                if (hs.type == 0)
                                {
                                    flyList.push(hs);
                                    hs.type=1; //修改缓存
                                    getIndex=i;
                                    JTLogger.debug("抽到位置" + (i + 1), " 抽到id" + info.id);
                                    break con;
                                }
                            }
                        }
                        startEffect();
                    }
                    else if (_type == 3)
                    {
                        flyList=new Vector.<IData>;
                        for each (hs in vect)
                        {
                            if (hs.type == 0)
                            {
                                flyList.push(hs);
                            }
                            hs.type=1; //修改缓存
                        }
                        startAllEffect();
                    }

                    break;
                case 1: //金币不足
                    enbledTouchable(true);
                    addTips(Langue.getLangue("notEnoughCoin"));
                    break;
                case 2: //钻石不足
                    enbledTouchable(true);
                    addTips(Langue.getLangue("diamendNotEnough"));
                    break;
                case 3: //金币cd未到
                    enbledTouchable(true);
                    addTips(Langue.getLangue("HAS_GOLD_CD"));
                    break;
                case 4: //配置错误 
                    addTips(Langue.getLangue("Configuration_ERR"));
                    break;
                case 5: //其他错误
                    enbledTouchable(true);
                    addTips(Langue.getLangue("diamendNotEnough"));
                    break;
                case 6: //背包不足
                    enbledTouchable(true);
                    addTips(Langue.getLangue("clearPack"));
                    break;
                case 7: //金币抽取次数不足
                    enbledTouchable(true);
                    addTips(Langue.getLangue("NOt_HAS_TIMES"));
                    break;
                case 8: //没有可抽取英雄
                    enbledTouchable(true);
                    addTips("NO_HAS_HERO"); //没有可抽取英雄 请刷新
                    break;

            }
            ShowLoader.remove();
        }


        /**抽取操作cmd*/
        private function getHerosoulCmd(type:uint):void
        {

            var hs:heroSoulList=null;
            var has:Boolean=false;
            for each (hs in TavernData.instance.heroSoulVector)
            {
                if (hs.type == 0)
                {
                    has=true;
                    break;
                }
            }
            if (!has)
            {
                addTips("NO_HAS_HERO"); //没有可抽取英雄 请刷新
                return;
            }
            _type=type;
            if (_type == 1)
            {
                if (TavernData.instance.leftTimes > 0 && TavernData.instance.fushData3.time <= 0)
                {
                    if (GameMgr.instance.coin < ConfigData.instance.herosoul_coin_count)
                    {
                        addTips(Langue.getLangue("notEnoughCoin"));
                        return;
                    }
                }
                else if (TavernData.instance.fushData3.time > 0)
                {
                    addTips("HAS_GOLD_CD"); //"金币cd未到"
                    return;
                }
                else if (TavernData.instance.leftTimes <= 0)
                {

                    addTips(Langue.getLangue("NOt_HAS_TIMES"));
                    return;
                }
                enbledTouchable(false);
            }
            else if (_type == 2)
            {
                if (GameMgr.instance.diamond < ConfigData.instance.herosoul_cq)
                {
                    addTips(Langue.getLangue("diamendNotEnough"));
                    return;
                }


            }
            else if (_type == 3)
            {

                if (GameMgr.instance.diamond < ConfigData.instance.herosoul_cq * TavernData.instance.hasSoul)
                {
                    addTips(Langue.getLangue("diamendNotEnough"));
                    return;
                }

            }
            var cmd:CGetherosoul=new CGetherosoul();
            cmd.type=type;
            Message.sendMessage(cmd);
        }

        /**根据选中的佣兵英雄数据更新UI*/
        public function updata():void
        {
            var vect:Vector.<IData>=TavernData.instance.heroSoulVector;
            var hero:Sprite=null;
            var heroData:heroSoulList=null;
            var img:Image=null;
            var quiaty:Image=null;
            var goods:Goods=null;
            var selectMc:Image=null;
            var txtName:TextField=null;
            var len:int=vect.length;
            for (var i:int=0; i < len; i++)
            {
                hero=this.getChildByName("heroIcon_" + i) as Sprite;
                quiaty=hero.getChildByName("quaity") as Image;
                img=hero.getChildByName("img") as Image;
                txtName=hero.getChildByName("txtName") as TextField
                selectMc=hero.getChildByName("selectMc") as Image;
                selectMc.visible=false;
                heroData=vect[i] as heroSoulList;
                goods=Goods.goods.getValue(heroData.id);
                quiaty.texture=Res.instance.getQualityPhoto(goods.quality);
                if (heroData.type == 0)
                {
                    img.texture=Res.instance.getGoodsPhoto(goods.type);
                    txtName.text="";
                    img.visible=true;
                }
                else
                {
                    txtName.text="";
                    img.visible=false;
                }
                hero.touchable=true;

            }
            buyNum_0.text=(ConfigData.instance.herosoul_cq * TavernData.instance.hasSoul).toString();
            leftTmies.text=TavernData.instance.leftTimes.toString() + '/' + ConfigData.instance.herosoul_cq_times;
        }

        /**点击操作*/
        private function onClickHandler(e:Event):void
        {
            switch (e.currentTarget)
            {
                case fushBtn:
                    if (GameMgr.instance.diamond < ConfigData.instance.herosoul_refresh)
                    {
                        addTips(Langue.getLangue("diamendNotEnough"));
                        return;
                    }
                    var cmd:CHerosoul=new CHerosoul();
                    cmd.type=1;
                    Message.sendMessage(cmd);
                    isRefresh=true;
                    enbledTouchable(false);
                    break;
                case buyBtn_0:
                    getHerosoulCmd(3);
                    break;
                case buyBtn_1:
                    getHerosoulCmd(2);
                    break;
                case buyBtn_2:
                    isRefresh=true;
                    getHerosoulCmd(1);
                    break;
                default:
                    break;
            }

        }

        /**播放动画*/
        private function animationComplete(sp:SpriterClip):void
        {
            _effectSp.animationComplete.remove(animationComplete);
            _effectSp.stop();
            _effectSp.play("round1");

            buyNum_0.text=(ConfigData.instance.herosoul_cq * TavernData.instance.hasSoul).toString();
            cdTime();
            cdCoinTime();

            enbledTouchable(true);
            updata();

        }

        private function flyToPointList():void
        {
            if (flyList && flyList.length > 0)
            {
                var len:int=flyList.length;
                var hs:heroSoulList=null;
                var hero:Sprite=null;
                var img:Image=null;
                var effImg:Image=null;
                for (var i:int=0; i < flyList.length; i++)
                {
                    hs=flyList[i] as heroSoulList;
                    hero=this.getChildByName("heroIcon_" + (hs.pos - 1)) as Sprite;
                    img=hero.getChildByName("img") as Image;
                    var p:Point=stage.globalToLocal(new Point(hero.x, hero.y));
                    effImg=new Image(img.texture);
                    effImg.x=p.x + effImg.width;
                    effImg.y=p.y
                    JTSession.layerGlobal.addQuiackChild(effImg);
                    Starling.juggler.tween(effImg, 0.5, {x: 840 * Constants.scale, y: 10 * Constants.scale, onCompleteArgs: [effImg], onComplete: completeEffect});
                }
            }

        }

        private function completeEffect(img:Image):void
        {
            img.removeFromParent(true);
        }

        /**刷新特效跑完*/
        private function onCompletes(sp:SpriterClip):void
        {
            sp.stop();
            sp.animationComplete.remove(onCompletes);
            Starling.juggler.remove(sp);
            sp.removeFromParent();
        }


        private var starIndex:int=0;
        private var starTime:Number=0.3;
        private var times:uint=4;
        private var getIndex:int=-1;
        private var noIndex:int=-1;
        private var currIndex:int=-1;

        /**启动转圈*/
        private function startEffect():void
        {
            enbledTouchable(false);
            if (getIndex >= 0)
            {
                currIndex=getIndex;
            }
            else
            {
                currIndex=noIndex;
            }
            starIndex == Math.floor(Math.random() * 8);
            starTime=0.3;
            times=3;
            getSelect(starIndex).visible=true;
            Starling.juggler.delayCall(onComplete, starTime);
        }

        /**循环转区*/
        private function onComplete():void
        {
            getSelect(starIndex).visible=false;
            starIndex++;
            starTime-=0.01;
            if (starIndex < 9)
            {
                if (times > 0)
                {
                    getSelect(starIndex).visible=true;
                    Starling.juggler.delayCall(onComplete, starTime);
                }
                else if (times <= 0 && starIndex <= currIndex)
                {
                    getSelect(starIndex).visible=true;
                    if (starIndex < currIndex)
                    {
                        Starling.juggler.delayCall(onComplete, starTime);
                    }
                    else
                    {
                        var rock:RockTween=new RockTween(this.getChildByName("heroIcon_" + currIndex), true);
                        Starling.juggler.delayCall(function():void
                        {
                            JTLogger.debug("执行位置" + (currIndex + 1));
                            rock.stop();
                            effectComplete();
                        }, 1.5)
                    }

                }
            }
            else
            {
                if (times > 0)
                {
                    starIndex=0;
                    times--;
                    if (times == 0)
                    {
                        times=0;
                        starTime=0.3;
                    }
                    getSelect(starIndex).visible=true;
                    if (currIndex == 0)
                    {
                        var rock1:RockTween=new RockTween(this.getChildByName("heroIcon_" + currIndex), true);
                        Starling.juggler.delayCall(function():void
                        {
                            JTLogger.debug("执行位置" + (currIndex + 1));
                            rock1.stop();
                            effectComplete();
                        }, 1.5)
                    }
                    else
                    {
                        Starling.juggler.delayCall(onComplete, starTime);
                    }

                }

            }

        }

        /**转圈特效完毕*/
        private function effectComplete():void
        {

            if (getIndex < 0)
            {
                addTips(Langue.getLangue("NOt_Get_SOUL"));
            }
            enbledTouchable(true);
            updata();
            flyToPointList();

        }

        /**获取选中边框*/
        private function getSelect(index:int):Image
        {
            var hero:Sprite=null;
            var selectMc:Image=null;
            for (var i:int=0; i < 9; i++)
            {
                if (index == i)
                {
                    hero=this.getChildByName("heroIcon_" + i) as Sprite;
                    selectMc=hero.getChildByName("selectMc") as Image;
                    break;
                }
            }
            return selectMc;
        }

        /**启动全部特效震动*/
        private function startAllEffect():void
        {

            var grid:Sprite=null;
            var rock:RockTween=null;
            var selectMc:Image=null;
            var vecRock:Vector.<RockTween>=new Vector.<RockTween>;
            var i:int=0;
            for (i=0; i < 9; i++)
            {
                grid=this.getChildByName("heroIcon_" + i) as Sprite;
                selectMc=grid.getChildByName("selectMc") as Image;
                selectMc.visible=true;
                rock=new RockTween(grid, true);
                vecRock.push(rock);
            }

            Starling.juggler.delayCall(function():void
            {
                for (i=0; i < 9; i++)
                {
                    grid=_this.getChildByName("heroIcon_" + i) as Sprite;
                    selectMc=grid.getChildByName("selectMc") as Image;
                    selectMc.visible=false;
                    rock=vecRock[i] as RockTween;
                    rock.stop();
                }
                updata();
                flyToPointList();
            }, 2);
        }

        /**禁用点击*/
        private function enbledTouchable(bool:Boolean):void
        {
            fushBtn.touchable=bool;
            buyBtn_0.touchable=bool;
            buyBtn_1.touchable=bool;
            buyBtn_2.touchable=bool;
            _selfParent.btn_close.visible=bool;
        }


        /**销毁*/
        override public function dispose():void
        {

            TavernData.instance.fushData2.onTimeEnd.remove(onTimeEnd);
            Starling.juggler.remove(_effectSp);
            _effectSp && _effectSp.removeFromParent();
            super.dispose();
            _type=0;
            isRefresh=false;
            isRefreshEff=false;
            isInitData=false;
            flyList=null;
        }
    }
}
