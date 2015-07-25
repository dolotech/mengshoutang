package game.view.luckyStar {
    import com.components.RollTips;
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.mvc.interfaces.INotification;
    import com.sound.SoundManager;
    import com.utils.Constants;
    import com.utils.ObjectUtil;

    import game.common.JTFastBuyComponent;
    import game.data.ConfigData;
    import game.data.Goods;
    import game.data.HeroData;
    import game.data.LuckyStarData;
    import game.data.RoleShow;
    import game.data.WidgetData;
    import game.dialog.DialogBackground1;
    import game.dialog.ShowLoader;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.net.GameSocket;
    import game.net.data.c.CLuckInitInfo;
    import game.net.data.c.CLuck_start;
    import game.net.data.s.SGet_game_luck;
    import game.net.data.s.SLuckInitInfo;
    import game.net.data.s.SLuck_start;
    import game.view.comm.GraphicsNumber;
    import game.view.dispark.DisparkControl;
    import game.view.dispark.data.ConfigDisparkStep;
    import game.view.uitils.Res;
    import game.view.widget.BagWidget;

    import starling.core.Starling;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import treefortress.spriter.SpriterClip;

    public class LuckyStarDlg extends LuckyStarDlgBase {
        private const turnNum:int = 14;
        private var _data:StarData = StarData.instance;
        private var start:SpriterClip
        //添加动画
        private var valuesSp:Sprite;
        //请求幸运星基本信息
        private var index:int = 0;
        private var getGoods:SpriterClip;

        public function LuckyStarDlg() {
            super();
            isVisible = true;
            _closeButton = closeButton;
            buyButton.addEventListener(Event.TRIGGERED, onBuy);
            background = new DialogBackground1();
        }

        override public function handleNotification(_arg1:INotification):void {
            if (_arg1.getName() == String(SLuckInitInfo.CMD)) {
                var info:SLuckInitInfo = _arg1 as SLuckInitInfo;
                _data.isSend = true;
                _data.id = info.id;
                _data.values = info.values;
                _data.star = info.luck;
                showGoods();
                addValues();
                updateMoney();
            } else if (_arg1.getName() == String(SLuck_start.CMD)) {
                var startData:SLuck_start = _arg1 as SLuck_start;
                if (startData.code == 0) {
                    if (index > 0)
                        replaceTexture((this["box" + index + "Image"] as Image), index);
                    turn(turnNum + startData.pos);
                    start.visible = false;
                    _data.values = startData.diamond;
                    addValues();
                    this.closeButton.visible = false;
                    SoundManager.instance.playSound("xingyunxin");
                } else if (startData.code == 1) {
                    // DialogMgr.instance.open(StarBuyDlg);
                    DialogMgr.instance.open(JTFastBuyComponent, JTFastBuyComponent.FAST_BUY_STAR);
                    RollTips.add(Langue.getLangue("NO_LUCK"));
                } else if (startData.code == 3) {
                    RollTips.add(Langue.getLangue("packFulls"));
                } else if (startData.code >= 127) {
                    RollTips.add(Langue.getLangue("codeError") + startData.code);
                }
            } else if (_arg1.getName() == String(SGet_game_luck.CMD)) {
                var star:SGet_game_luck = _arg1 as SGet_game_luck;
                _data.star = star.luck;
                updateMoney();
            }
            ShowLoader.remove();
        }

        override public function listNotificationName():Vector.<String> {
            var vect:Vector.<String> = new Vector.<String>;
            vect.push(SLuckInitInfo.CMD, SLuck_start.CMD, SGet_game_luck.CMD);
            return vect;
        }

        override public function open(container:DisplayObjectContainer, parameter:Object = null, okFun:Function = null, cancelFun:Function = null):void {
            super.open(container, parameter, okFun, cancelFun);
            if (!_data.isSend) {
                sendInitInfo(); //请求幸运星基本信息
            } else {
                showGoods();
                addValues();
                updateMoney();
            }
            Starling.juggler.delayCall(function():void {
                addChild(new RichList);
                addChild(new LastList);
            }, 0.2);
            GameMgr.instance.onUpateMoney.add(updateMoney);
            updateMoney
            showText();

            setToCenter();
        }

        override public function get height():Number {
            return 637 * (Constants.isScaleWidth ? Constants.scale_x : Constants.scale);
        }

        override public function dispose():void {
            valuesSp && valuesSp.dispose();
            start && start.dispose();
            getGoods && getGoods.dispose();
            GameMgr.instance.onUpateMoney.remove(updateMoney);
            super.dispose();
        }

        private function addAction():void {
            start = AnimationCreator.instance.create("effect_011", AssetMgr.instance);
            start.play("effect_011");
            start.animation.looping = true;
            Starling.juggler.add(start);
            start.x = startButton.x + startButton.width / 2 - 5;
            start.y = startButton.y + startButton.height / 2;
            addChild(start);
            getGoods = AnimationCreator.instance.create("effect_014", AssetMgr.instance);
            getGoods.x = width / 2 / Constants.scale - 2;
            getGoods.y = height / 2 / Constants.scale;
            addChildAt(getGoods, numChildren - 1);
            getGoods.visible = false;
        }

        private function sendInitInfo():void {
            var cmd:CLuckInitInfo = new CLuckInitInfo;
            GameSocket.instance.sendData(cmd);
            ShowLoader.add();
        }

        private function addValues():void {
            valuesSp && valuesSp.removeFromParent(true);
            valuesSp = GraphicsNumber.instance().getNumber(_data.values + 1, "ui_gongyong_xingyunxingshuzi");
            addChild(valuesSp);
            valuesSp.x = 35;
            valuesSp.y = 500;
            diamondImage.x = valuesSp.x + valuesSp.width;
        }

        private function showGoods():void {
            var goodsList:Vector.<LuckyStarData> = _data.goodsList;
            var image:Image;
            var widget:BagWidget;
            var luckstar:LuckyStarData;
            var nameTxt:TextField;
            var numTxt:TextField;
            //        var filters:Array = [new GlowFilter(0x0, 1, 5, 5, 4)];
            for (var i:int = 0; i < goodsList.length; i++) {

                luckstar = goodsList[i];
                widget = new BagWidget(null, false);
                widget.touchable = false;
                image = this["box" + luckstar.pos + "Image"];
                image.texture = AssetMgr.instance.getTexture("ui_gongyong_xingyunchoujiangkuang");
                var quality:Image = new Image(Res.instance.getQualityPhoto(luckstar.quality));
                addChild(quality);
                addChild(widget);

                if (luckstar.type == 1) {
                    widget.inits(AssetMgr.instance.getTexture("ui_tubiao_jinbi_da"), false);
                    numTxt = new TextField(100, 35, luckstar.num + "", "", 16, 0xffffff);
                    addChild(numTxt);
                    ObjectUtil.setToCenter(image, numTxt);
                    numTxt.y = image.y + image.height - 45;
                        //                numTxt.nativeFilters = filters;
                } else if (luckstar.type == 2) {
                    widget.inits(AssetMgr.instance.getTexture("ui_tubiao_zuanshi_da"));
                    numTxt = new TextField(60, 35, luckstar.num + "", "", 16, 0xffffff);
                    addChild(numTxt);
                    ObjectUtil.setToCenter(image, numTxt);
                    numTxt.y = image.y + image.height - 45;
                        //                numTxt.nativeFilters = filters;
                } else if (luckstar.type == 3) {
                    widget.inits(AssetMgr.instance.getTexture("ui_tubiao_fanlibiaozhi"));
                    nameTxt = new TextField(100, 35, luckstar.name, "", 16, 0xffffff);
                    addChild(nameTxt);
                    ObjectUtil.setToCenter(image, nameTxt);
                    nameTxt.y = image.y + image.height - 45;
                        //                nameTxt.nativeFilters = filters;
                } else if (luckstar.type == 5) {
                    var heroData:HeroData = HeroData.hero.getValue(luckstar.type1);
                    var photo:String = (RoleShow.hash.getValue(heroData.show) as RoleShow).photo;
                    widget.inits(AssetMgr.instance.getTexture(photo));
                    numTxt = new TextField(100, 35, "x 1", "", 16, 0xffffff);
                    addChild(numTxt);
                    ObjectUtil.setToCenter(image, numTxt);
                    numTxt.x += 25;
                    numTxt.y = image.y + 10;

                    nameTxt = new TextField(100, 35, luckstar.name, "", 16, 0xffffff);
                    addChild(nameTxt);
                    ObjectUtil.setToCenter(image, nameTxt);
                    nameTxt.y = image.y + image.height - 45;

                } else {
                    var wg:WidgetData = new WidgetData(Goods.goods.getValue(luckstar.type));
                    widget.setWidgetData(wg);
                    numTxt = new TextField(50, 35, "x " + luckstar.num, "", 16, 0xffffff);
                    addChild(numTxt);
                    ObjectUtil.setToCenter(image, numTxt);
                    numTxt.x += 25;
                    numTxt.y = image.y + 10;
                    //                numTxt.nativeFilters = filters;

                    nameTxt = new TextField(100, 35, luckstar.name, "", 16, 0xffffff);
                    addChild(nameTxt);
                    ObjectUtil.setToCenter(image, nameTxt);
                    nameTxt.y = image.y + image.height - 45;
                        //                nameTxt.nativeFilters = filters;
                }
                ObjectUtil.setToCenter(image, quality);
                ObjectUtil.setToCenter(image, widget);
                this.swapChildren(widget, quality);
            }
            addAction();
        }

        //开始抽奖
        private function showText():void {
            no1_1Txt.text = Langue.getLans("justYouUseOneLuckyStar")[0];
            no1_2Txt.text = ConfigData.instance.starCumulative + "";
            no1_3Txt.text = Langue.getLans("justYouUseOneLuckyStar")[1];
            no2_1Txt.text = Langue.getLans("fromVolumeStart")[0];

            no2_2Txt.text = ConfigData.instance.starBack + "";
            no2_3Txt.text = Langue.getLans("fromVolumeStart")[1];
            no3_1Txt.text = Langue.getLans("selectVolume")[0];
            no3_2Txt.text = Langue.getLans("selectVolume")[1];
            startCTxt.text = Langue.getLans("start")[0];
            startETxt.text = Langue.getLans("start")[1];
            nameTxt.text = Langue.getLans("rankTitles")[1];
            awardTxt.text = Langue.getLangue("award");
            startButton.addEventListener(Event.TRIGGERED, onStart); //抽奖
        }

        private function turn(num:int, boxIndex:int = 1):void {
            (this["box" + boxIndex + "Image"] as Image).texture = AssetMgr.instance.getTexture("ui_button_wupinkuang"); //抽奖时候的图片走动
            if (boxIndex == 1) {
                replaceTexture((this["box" + turnNum + "Image"] as Image), 14);
            } else {
                replaceTexture((this["box" + (boxIndex - 1) + "Image"] as Image), boxIndex - 1);
            }

            index = boxIndex;
            --num;
            ++boxIndex;
            if (num == 0) {
                getGoods.visible = true;
                goodsIcon(_data.goodsList[index - 1]);
                getGoods.play("effect_014");
                getGoods.animation.looping = true;
                Starling.juggler.add(getGoods);
                SoundManager.instance.playSound("cheers");
                getGoods.animationComplete.add(onComplete);
                function onComplete():void {
                    start.visible = true;
                    getGoods.visible = false;
                    getGoods.stop();
                    Starling.juggler.remove(getGoods);
                    getGoods.animation.looping = false;
                    closeButton.visible = true;
                }
                return;
            }
            if (boxIndex >= 15)
                boxIndex = 1;
            if (num > 5)
                Starling.juggler.delayCall(turn, 0.1, num, boxIndex);
            else
                Starling.juggler.delayCall(turn, 0.3, num, boxIndex);
        }

        private function goodsIcon(data:LuckyStarData):void {
            if (getGoods.getChildByName("goods"))
                getGoods.getChildByName("goods").removeFromParent(true);

            var widget:BagWidget;
            var luckstar:LuckyStarData = data;
            var nameTxt:TextField;
            var numTxt:TextField;
            var qualityBg:Image;
            var sp:Sprite;
            var box:Image;
            widget = new BagWidget(null, false);
            qualityBg = new Image(AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang"));
            sp = new Sprite();
            box = new Image(AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (data.quality - 1)));
            sp.addQuiackChild(qualityBg);
            sp.addChild(widget);
            sp.addChild(box);
            sp.name = "goods";
            if (data.type == 1) {
                widget.inits(AssetMgr.instance.getTexture("ui_tubiao_jinbi_da"), false);
                numTxt = new TextField(100, 35, luckstar.num + "", "", 16, 0xffffff);
                sp.addChild(numTxt);
                ObjectUtil.setToCenter(box, numTxt);
                numTxt.y = box.y + box.height - 40;
                    //            numTxt.nativeFilters = [new GlowFilter(0x0, 1, 5, 5, 4)];
            } else if (data.type == 2) {
                widget.inits(AssetMgr.instance.getTexture("ui_tubiao_zuanshi_da"));
                numTxt = new TextField(60, 35, luckstar.num + "", "", 16, 0xffffff);
                sp.addChild(numTxt);
                ObjectUtil.setToCenter(box, numTxt);
                numTxt.y = box.y + box.height - 40;
                    //            numTxt.nativeFilters = [new GlowFilter(0x0, 1, 5, 5, 4)];
            } else if (data.type == 3) {
                widget.inits(AssetMgr.instance.getTexture("ui_tubiao_fanlibiaozhi"));
                nameTxt = new TextField(100, 35, luckstar.name, "", 16, 0xffffff);
                sp.addChild(nameTxt);
                ObjectUtil.setToCenter(box, nameTxt);
                nameTxt.y = box.y + box.height - 45;
                    //            nameTxt.nativeFilters = [new GlowFilter(0x0, 1, 5, 5, 4)];
            } else if (data.type == 5) {
                var heroData:HeroData = HeroData.hero.getValue(data.type1);
                var photo:String = (RoleShow.hash.getValue(heroData.show) as RoleShow).photo;
                widget.inits(AssetMgr.instance.getTexture(photo));
                numTxt = new TextField(100, 35, "x 1", "", 16, 0xffffff);
                sp.addChild(numTxt);
                ObjectUtil.setToCenter(box, numTxt);
                numTxt.x += 25;
                numTxt.y = box.y + 10;

                nameTxt = new TextField(100, 35, luckstar.name, "", 16, 0xffffff);
                sp.addChild(nameTxt);
                ObjectUtil.setToCenter(box, nameTxt);
                nameTxt.y = box.y + box.height - 45;
            } else {
                var wg:WidgetData = new WidgetData(Goods.goods.getValue(luckstar.type));
                widget.setWidgetData(wg);
                numTxt = new TextField(50, 35, "x " + luckstar.num, "", 16, 0xffffff);
                sp.addChild(numTxt);
                ObjectUtil.setToCenter(box, numTxt);
                numTxt.x += 25;
                numTxt.y = box.y + 10;
                //            numTxt.nativeFilters = [new GlowFilter(0x0, 1, 5, 5, 4)];

                nameTxt = new TextField(100, 35, luckstar.name, "", 16, 0xffffff);
                sp.addChild(nameTxt);
                ObjectUtil.setToCenter(box, nameTxt);
                nameTxt.y = box.y + box.height - 45;
                    //            nameTxt.nativeFilters = [new GlowFilter(0x0, 1, 5, 5, 4)];
            }
            getGoods.addChild(sp);
            sp.x = -50;
            sp.y = -50;
        }

        private function replaceTexture(target:Image, pos:int):void {
            var luckstar:LuckyStarData = _data.goodsList[pos - 1];
            target.texture = AssetMgr.instance.getTexture("ui_gongyong_xingyunchoujiangkuang");
        }

        private function updateMoney():void {
            diamondTxt.text = GameMgr.instance.star + "";
        }

        private function onBuy(e:Event):void {
            DialogMgr.instance.open(JTFastBuyComponent, JTFastBuyComponent.FAST_BUY_STAR);
            // DialogMgr.instance.open(StarBuyDlg);
        }

        private var isStart:Boolean = false;

        private function onStart(e:Event):void {
            if (isStart) {
                return;
            }
            if (GameMgr.instance.star == 0) {
                DialogMgr.instance.open(JTFastBuyComponent, JTFastBuyComponent.FAST_BUY_STAR);
                RollTips.add(Langue.getLangue("NO_LUCK"));
                return;
            }
            isStart = true;
            var cmd:CLuck_start = new CLuck_start;
            GameSocket.instance.sendData(cmd);
            Starling.current.juggler.delayCall(onDelayComplete, 1);
            //JTLogger.info("[LuckyStarDlg.onStart]  cmd");
            //ShowLoader.add();
        }

        override public function close():void {
            //智能判断是否添加功能开放提示图标（幸运星）
            DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep5);
            super.close();
        }

        private function onDelayComplete():void {
            isStart = false;
        }
    }
}
