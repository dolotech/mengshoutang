package game.view.pack {
    import com.components.RollTips;
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.mvc.interfaces.INotification;
    import com.sound.SoundManager;
    import com.utils.Constants;
    import com.utils.ObjectUtil;
    import com.utils.StringUtil;
    import com.utils.TouchProxy;
    import com.view.base.event.EventType;

    import flash.geom.Rectangle;

    import game.data.BagsData;
    import game.data.ConfigData;
    import game.data.WidgetData;
    import game.dialog.DialogBackground;
    import game.dialog.ShowLoader;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.net.GameSocket;
    import game.net.data.c.CBags;
    import game.net.data.c.COversellItem;
    import game.net.data.s.SBags;
    import game.net.data.s.SOversellItem;
    import game.view.comm.menu.MenuFactory;
    import game.view.goodsGuide.EquipInfoDlg;
    import game.view.pageList.PageList;
    import game.view.tipPanel.TipPanelDlg;
    import game.view.uiAction.ShowAction;
    import game.view.viewBase.PackDlgBase;
    import game.view.vip.VipDlg;
    import game.view.widget.BagWidget;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;

    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Quad;
    import starling.events.Event;
    import starling.textures.Texture;

    import treefortress.spriter.SpriterClip;

    /**
     * 背包
     * @author litao
     *
     */
    public class PackDlg extends PackDlgBase {
        private var pageList:PageList;

        public function PackDlg() {
            super();
            isVisible = true;
            _closeButton = btn_close;
            over.text = Langue.getLangue("batchSelect");
            /*cancelButton.text = Langue.getLangue("cancelSelect");
               cancelButton.textBounds = new Rectangle(23,20,100,30);
               cancelButton.fontSize = 30;
             cancelButton.fontColor = 0xffffff;*/
            cancel.visible = false;
            cancel.addEventListener(Event.TRIGGERED, onCancelSelect);
            initChargeButtonEvent();

            background = new DialogBackground();
        }

        private function initChargeButtonEvent():void {
            Recharge.addEventListener(Event.TRIGGERED, onChargeButtonClick);
        }

        private function onChargeButtonClick(e:Event):void {
            DialogMgr.instance.open(VipDlg, VipDlg.CHARGE);
        }

        override protected function addListenerHandler():void {
            super.addListenerHandler();
            this.addContextListener(EventType.SELL_GOODS, onSellGoodsNofiy);
            this.addContextListener(EventType.NOTIFY_FORGE_EQUIP, onForgeNotify);
        }

        private function onForgeNotify():void {
            getData();
            switch (type) {
                case 1:
                    onMaterial(null);
                    break;
                case 2:
                    onWidget(null);
                    break;
                case 5:
                    onEquip(null);
                    break;
                default:
                    break;
            }
        }

        private function set selectedIndex(value:int):void {
            factory.selectedIndex = value;
            switch (value) {
                case 0:
                    onEquip(null);
                    break;
                case 1:
                    onWidget(null);
                    break;
                case 2:
                    onMaterial(null);
                    break;
            }
        }

        override public function open(container:DisplayObjectContainer, parameter:Object = null, okFun:Function = null, cancelFun:Function = null):void {
            super.open(container, parameter, okFun, cancelFun);
            GameMgr.instance.onUpateMoney.add(updateMoney); //玩家货币更新监听
            updateMoney(); //更新玩家货币
            addButtons(); //添加装备，材料，道具按钮
            createGrid(); //创建背包格子
            getData(); //获取装备，道具，材料 数据
            sell.addEventListener(Event.TRIGGERED, onSell); //点击出售
            selectedIndex = _parameter ? int(_parameter) : 0;
            setToCenter();
        }

        //请求购买格子 , 1:材料，2:道具,5:武器
        private function sendGrid(type:int):void {
            var cmd:CBags = new CBags();
            var num:int

            if (type == 5) {
                num = GameMgr.instance.bagequ;
            } else if (type == 2) {
                num = GameMgr.instance.bagprop;
            } else if (type == 1) {
                num = GameMgr.instance.bagmat;
            }
            cmd.line = num / 8 + 1;
            cmd.tab = type;
            cmd.type = 1;
            GameSocket.instance.sendData(cmd);
            ShowLoader.add();
        }

        override public function handleNotification(_arg1:INotification):void {
            if ((_arg1.getName()) == SBags.CMD.toString()) {
                var sbags:SBags = _arg1 as SBags;

                if (sbags.code == 0) {
                    RollTips.add(Langue.getLangue("openGrid"));

                    if (type == 5)
                        openGrid = GameMgr.instance.bagequ = sbags.bags;
                    else if (type == 2)
                        openGrid = GameMgr.instance.bagprop = sbags.bags;
                    else if (type == 1)
                        openGrid = GameMgr.instance.bagmat = sbags.bags;
                    showGoods(openGrid, currentPage, currentPageNumber);
                } else if (sbags.code == 1) {
                    RollTips.add(Langue.getLangue("diamendNotEnough"));
                } else if (sbags.code >= 127) {
                    RollTips.add(Langue.getLangue("codeError") + sbags.code);
                }
                DialogMgr.instance.deleteDlg(TipPanelDlg);
            } else if (_arg1.getName() == SOversellItem.CMD.toString()) {
                var sellItem:SOversellItem = _arg1 as SOversellItem;

                if (sellItem.code == 0) {
                    SoundManager.instance.playSound("deal");
                    var length:int = selectList.length;
                    var i:int = 0;

                    while (selectList.length) {
                        var grid:PackGrid = selectList[0];
                        var wiget:BagWidget = new BagWidget();

                        wiget.setWidgetData(grid.data as WidgetData);
                        ObjectUtil.setToCenter(grid, wiget);
                        addChild(wiget);

                        selectList.splice(0, 1)[0].select();
                        Starling.juggler.tween(wiget, 0.3, {x: 836, y: 533, onCompleteArgs: [wiget], onComplete: complete});
                        i++;
                    }

                    while (widgetList.length) {
                        onChange(widgetList.splice(0, 1)[0]);
                    }

                    function complete(wiget:BagWidget):void {
                        wiget.removeFromParent();
                        sell.visible = true;

                        if (i == length) {
                            var action:SpriterClip = getChildByName("action") as SpriterClip;
                            Starling.juggler.remove(action);

                            if (action) {
                                action.play("effect_021", 327);
                                Starling.juggler.add(action);
                                action.animationComplete.addOnce(function():void {
                                    action.stop();
                                    action.removeFromParent(true);
                                    _closeButton.touchable = true;
                                });
                            }
                        }
                    }
                    over.text = Langue.getLangue("batchSelect");
                    cancel.visible = false;
                    RollTips.add(Langue.getLangue("sellOk"));
                } else
                    RollTips.add(Langue.getLangue("codeError") + sellItem.code);
            }
            ShowLoader.remove();
        }

        //取消选择
        private function onCancelSelect(e:Event):void {
            currentPage.stopTween();

            if (getChildByName("action"))
                getChildByName("action").removeFromParent(true);
            sell.visible = true;
            cancel.visible = false;
            _closeButton.touchable = true;
            isSelect = false;
            over.text = Langue.getLangue("batchSelect");

            while (selectList.length) {
                selectList.splice(0, 1)[0].select();
            }
        }

        override public function listNotificationName():Vector.<String> {
            var vect:Vector.<String> = new Vector.<String>;
            vect.push(SBags.CMD);
            vect.push(SOversellItem.CMD);
            return vect;
        }

        //创建背包格子
        private function createGrid():void {
            pageList = new game.view.pageList.PageList(PackGrids);
            pageList.onInit.addOnce(onInit);
            addChildAt(pageList, getChildIndex(over) - 1);
            pageList.clipRect = new Rectangle(43, 130, 880, 385);
            pageList.Prev.add(onPrev);
            pageList.Next.add(onNext);
            pageList.currentNext.add(onCurrentNext);
            pageList.currentPrev.add(onCurrentPrev);
            pageList.addEventListener(Event.TRIGGERED, onSelect);
        }

        private var selectList:Array = []; //选中的物品

        private function onSelect(e:Event):void {
            if (pageList.isTriggered)
                return;
            var packGrid:PackGrid = (e.target as DisplayObject).parent as PackGrid;

            if (isSelect && packGrid.data) {
                packGrid.select();

                if (selectList.indexOf(packGrid) == -1)
                    selectList.push(packGrid);
                else
                    selectList.splice(selectList.indexOf(packGrid), 1);

                if (selectList.length > 0) {
                    over.text = Langue.getLangue("allOversell");
                    cancel.visible = true;
                } else {
                    over.text = Langue.getLangue("batchSelect");
                    cancel.visible = false;
                }
                return;
            }

            if (packGrid.data) {
                isVisible = true;
                DialogMgr.instance.open(EquipInfoDlg, packGrid.data);
            } else if (packGrid.isOff) {
                openGridHandler();
            }
        }

        private function openGridHandler():void {
            isVisible = true;
            var tip:PackTips = DialogMgr.instance.open(PackTips) as PackTips;

            var num:int

            if (type == 5) {
                num = GameMgr.instance.bagequ;
            } else if (type == 2) {
                num = GameMgr.instance.bagprop;
            } else if (type == 1) {
                num = GameMgr.instance.bagmat;
            }
            tip.text = Langue.getLangue("okOpenGrid").replace("*", BagsData.hash.getValue(num / 8 + 1).price);
            tip.onOk.addOnce(okBug);
        }

        private function okBug():void {
            isVisible = false;

            sendGrid(type);
        }

        private function onSellGoodsNofiy(evt:Event, widget:WidgetData):void {
            onChange(widget);
        }

        private function onChange(widget:WidgetData):void {
            if (parent == null)
                return;

            if (currentData.indexOf(widget) != -1) {
                var len:int = currentData.length;
                currentData.splice(currentData.indexOf(widget), 1);
                currentData.push(null);
            }
            showGoods(openGrid, currentPage, currentPageNumber);
        }

        private var openGrid:int;
        private var currentPageNumber:int = 1;

        private var currentRoundPage:PackGrids;
        private var isMove:Boolean; //正在滚动中

        private function onCurrentNext(target:DisplayObject):void {
            currentRoundPage = target as PackGrids;
            var page:int = currentPageNumber;
            page++;
            var max:int;

            if (type == 5)
                max = ConfigData.instance.equipPageMax;
            else if (type == 2)
                max = ConfigData.instance.propsPageMax;
            else if (type == 1)
                max = ConfigData.instance.materialPageMax;
            page = page > max ? 1 : page;
            showGoods(openGrid, currentRoundPage, page);

            if (isSelect && !currentRoundPage.isTween)
                currentRoundPage.tween();
            isMove = true;
        }

        private function onCurrentPrev(target:DisplayObject):void {
            currentRoundPage = target as PackGrids;
            var page:int = currentPageNumber;
            page--;
            var max:int;

            if (type == 5)
                max = ConfigData.instance.equipPageMax;
            else if (type == 2)
                max = ConfigData.instance.propsPageMax;
            else if (type == 1)
                max = ConfigData.instance.materialPageMax;

            page = page <= 0 ? max : page;
            showGoods(openGrid, currentRoundPage, page);

            if (isSelect && !currentRoundPage.isTween)
                currentRoundPage.tween();
            isMove = true;
        }

        private function pageSkin():void {
            var max:int;

            if (type == 5)
                max = ConfigData.instance.equipPageMax;
            else if (type == 2)
                max = ConfigData.instance.propsPageMax;
            else if (type == 1)
                max = ConfigData.instance.materialPageMax;
            visiblePage();

            for (var i:int = 0; i < max; i++) {
                this["page" + (i + 1)].visible = true;

                if (currentPageNumber != i + 1)
                    this["page" + (i + 1)].texture = AssetMgr.instance.getTexture("ui_gongyong_yemianqiehuan2");
                else
                    this["page" + (i + 1)].texture = AssetMgr.instance.getTexture("ui_gongyong_yemianqiehuan1");
            }
        }

        private function onPrev(target:DisplayObject):void {
            isSelect = false;
            currentPage.stopTween();
            currentPage = target as PackGrids;
            currentPageNumber++;
            var max:int;

            if (type == 5)
                max = ConfigData.instance.equipPageMax;
            else if (type == 2)
                max = ConfigData.instance.propsPageMax;
            else if (type == 1)
                max = ConfigData.instance.materialPageMax;

            var page:int = currentPageNumber = currentPageNumber > max ? 1 : currentPageNumber;
            showGoods(openGrid, currentPage, page);
            pageSkin();

            if (!isSelect && currentPage.isTween)
                currentPage.stopTween();
            isMove = false;

            while (selectList.length) {
                selectList.splice(0, 1)[0].select();
            }

            if (getChildByName("action"))
                getChildByName("action").removeFromParent(true);
            sell.visible = true;
            cancel.visible = false;
            _closeButton.touchable = true;
            over.text = Langue.getLangue("batchSelect");
        }

        private function onNext(target:DisplayObject):void {
            isSelect = false;
            currentPage.stopTween();
            currentPage = target as PackGrids;
            currentPageNumber--;

            var max:int;

            if (type == 5)
                max = ConfigData.instance.equipPageMax;
            else if (type == 2)
                max = ConfigData.instance.propsPageMax;
            else if (type == 1)
                max = ConfigData.instance.materialPageMax;

            var page:int = currentPageNumber = currentPageNumber <= 0 ? max : currentPageNumber;

            showGoods(openGrid, currentPage, page);
            pageSkin();

            if (!isSelect && currentPage.isTween)
                currentPage.stopTween();
            isMove = false;

            while (selectList.length) {
                selectList.splice(0, 1)[0].select();
            }

            if (getChildByName("action"))
                getChildByName("action").removeFromParent(true);
            sell.visible = true;
            cancel.visible = false;
            _closeButton.touchable = true;
            over.text = Langue.getLangue("batchSelect");
        }

        protected var currentPage:PackGrids; //当前页面

        private function onInit(target:DisplayObject):void {
            currentPage = target as PackGrids;
            currentData = equipDataList;
            showGoods(GameMgr.instance.bagequ, currentPage);
            openGrid = GameMgr.instance.bagequ;
            pageSkin();
            type = 5;
        }

        private var currentData:Vector.<Object>; //当前页面的数据

        private function showGoods(openGrid:int, pageDisplay:PackGrids, page:int = 1):void {
            if (currentPage == null)
                return;
            pageDisplay.addGoodIcon(currentData, openGrid, page);
        }

        private var equipDataList:Vector.<Object> = new Vector.<Object>(8 * (ConfigData.instance.equipPageMax * 3)); //装备数据
        private var goodsDataList:Vector.<Object> = new Vector.<Object>(8 * (ConfigData.instance.propsPageMax * 3)); //道具数据
        private var matDataList:Vector.<Object> = new Vector.<Object>(8 * (ConfigData.instance.materialPageMax * 3)); //材料数据

        //获取装备，材料，道具数据
        private function getData():void {
            var equip:int = GameMgr.instance.bagequ;
            var goods:int = GameMgr.instance.bagprop;
            var mat:int = GameMgr.instance.bagmat;
            var i:int;
            var j:int;
            var k:int;

            var widgetArr:Vector.<*> = WidgetData.hash.values();
            var widget:WidgetData;

            for each (widget in widgetArr) {
                //装备
                if (widget.tab == 5 && i < equip) {
                    if (widget.equip == 0) // 英雄身上的装备不在背包里显示
                    {
                        equipDataList[i] = widget;
                        i++;
                    }
                }
                //道具
                else if (widget.tab == 2 && j < goods) {
                    goodsDataList[j] = widget;
                    j++;
                }
                //材料
                else if (widget.tab == 1 && k < mat) {
                    matDataList[k] = widget;
                    k++;
                }
            }
            equipDataList = sort(equipDataList);
            goodsDataList = sort(goodsDataList);
            matDataList = sort(matDataList);
        }

        //排序
        private function sort(vect:Vector.<Object>):Vector.<Object> {
            var arr:Array = [];
            var len:int = vect.length
            for (var i:int = 0; i < len; i++) {
                if (vect[i])
                    arr.push({quality: vect[i].quality, level: vect[i].level, type: vect[i].type, widget: vect[i]});
            }
            arr.sortOn(["quality", "level", "type"], Array.DESCENDING);
            var arrLen:int = arr.length;
            for (i = 0; i < arrLen; i++) {
                vect[i] = arr[i].widget;
            }
            return vect;
        }

        //隐藏页面提示
        private function visiblePage():void {
            for (var i:int = 0; i < 5; i++) {
                this["page" + (i + 1)].visible = false;
            }
        }
        protected var factory:MenuFactory; //新手引导暴露

        //添加装备，材料，道具按钮
        private function addButtons():void {
            var onFocus:ISignal = new Signal();
            factory = new MenuFactory();
            factory.onFocus = onFocus;

            var defaultSkin:Texture = AssetMgr.instance.getTexture("ui_gongyong_yibanmubanhentiao_anniu2");
            var downSkin:Texture = AssetMgr.instance.getTexture("ui_gongyong_yibanmubanhentiao_anniu1");

            addChild(factory);
            factory.factory([{"defaultSkin": defaultSkin, "downSkin": downSkin, x: 53, y: 554, size: 32, color: 0xffffff,
                                 text: Langue.getLangue("EQUIP"), onClick: onEquip, isSelect: true}, {"defaultSkin": defaultSkin,
                                 "downSkin": downSkin, x: 179, y: 554, size: 32, color: 0xffffff, text: Langue.getLangue("WIDGET"),
                                 onClick: onWidget, name: "goods"}, {"defaultSkin": defaultSkin, "downSkin": downSkin, x: 310,
                                 y: 554, size: 32, color: 0xffffff, text: Langue.getLangue("material"), onClick: onMaterial}]);
        }

        private var type:int = 0;

        //点击装备
        private function onEquip(e:Event):void {
            currentPage.stopTween();
            currentData = equipDataList;
            showGoods(GameMgr.instance.bagequ, currentPage);
            openGrid = GameMgr.instance.bagequ;
            currentPageNumber = 1;
            type = 5;
            pageSkin();
            isSelect = false;
            onCancelSelect(null);
        }

        //点击道具
        public function onWidget(e:Event):void {
            currentPage.stopTween();
            currentData = goodsDataList;
            showGoods(GameMgr.instance.bagprop, currentPage);
            openGrid = GameMgr.instance.bagprop;
            currentPageNumber = 1;
            type = 2;
            pageSkin();
            isSelect = false;
            onCancelSelect(null);
        }

        //点击材料
        private function onMaterial(e:Event):void {
            currentPage.stopTween();
            currentData = matDataList;
            showGoods(GameMgr.instance.bagmat, currentPage);
            openGrid = GameMgr.instance.bagmat;
            currentPageNumber = 1;
            type = 1;
            pageSkin();
            isSelect = false;
            onCancelSelect(null);
        }

        //添加背包标题
        private function addTitle():void {
            var title:PackTitle = new PackTitle();
            addChild(title);
            //播放标题动画
            ShowAction.upDown(title, {y: title.y, transition: "easeOutBounce"});
            //面板关闭时动画
            _cancelFunction = function():void {
                Starling.juggler.tween(title, 0.5, {y: -150});
            }
        }

        //更新金币
        private function updateMoney():void {
            StringUtil.changePriceText(GameMgr.instance.coin, money, k);
            StringUtil.changePriceText(GameMgr.instance.diamond, diamond, k1, false);
        }

        private var isSelect:Boolean;
        private var widgetList:Vector.<WidgetData> = new Vector.<WidgetData>;

        //点击出售
        private function onSell(e:Object):void {
            var action:SpriterClip = AnimationCreator.instance.create("effect_021", AssetMgr.instance);

            if (!isSelect) {

                currentPage.tween();

                if (currentPage.tweenLength == 0) {
                    RollTips.add(Langue.getLangue("currentPageNogoods"));
                    return;
                }
                _closeButton.touchable = false;
                action.play("effect_021");
                action.animation.looping = true;
                Starling.juggler.add(action);
                action.x = sell.x + sell.width / 2;
                action.y = sell.y + sell.height / 2;
                action.name = "action";
                addChildAt(action, getChildIndex(over));
                sell.visible = false;
                action.touchable = true;
                var touch:TouchProxy = new TouchProxy(action);
                touch.onClick.addOnce(onSell);

                action.addCallback(function():void {
                    action.stop();
                }, 327, true);
                isSelect = true;
            } else {
                currentPage.stopTween();
                isSelect = false;

                if (selectList.length == 0) {
                    RollTips.add(Langue.getLangue("noSelectSellGoods"));

                    if (getChildByName("action")) {
                        getChildByName("action").removeFromParent(true);
                        _closeButton.touchable = true;
                        sell.visible = true;
                    }
                    return;
                }
                var vect:Vector.<int> = new Vector.<int>;
                var grid:PackGrid;

                for (var i:int = 0; i < selectList.length; i++) {
                    grid = selectList[i];

                    if (grid.isSelect) {
                        vect.push(grid.data.id);
                        widgetList.push(grid.data);
                    }
                }
                var cmd:COversellItem = new COversellItem;
                cmd.ids = vect;
                cmd.tab = type;
                GameSocket.instance.sendData(cmd);
                ShowLoader.add();
            }
        }

        override public function dispose():void {
            factory && factory.dispose();
            GameMgr.instance.onUpateMoney.remove(updateMoney);

            super.dispose();
        }

        /**
         * 新手引导专用函数
         * @param id
         * type 1自动布阵
         * type 2开始战斗
         */
        override public function executeGuideFun(name:String):void {
            //背包第三行格子开了的直接跳过
            if (GameMgr.instance.bagequ > 16)
                return;

            if (name == "购买格子" && isVisible) {
                sendGrid(5);
                DialogMgr.instance.deleteDlg(PackTips);
            }
        }

        /**
         * 新手引导
         * @param name
         * @return
         *
         */
        override public function getGuideDisplay(name:String):* {
            //背包第三行格子开了的直接跳过
            if (GameMgr.instance.bagequ > 16)
                return null;

            if (name.indexOf("背包行") >= 0) {
                var index:int = name.split(",")[1];
                var child:DisplayObject = pageList._select.data.getChildAt((index - 1) * 8);
                pageList.addEventListener(Event.TRIGGERED, onGuideSelect);
                function onGuideSelect():void {
                    pageList.removeEventListener(Event.CHANGE, onGuideSelect);
                    gotoNext();
                }

                var q:Quad = new Quad(child.width * 9, child.height);
                q.x = child.x - child.width * .5;
                q.y = child.y - child.height * .5;
                child.parent.addChild(q);
                q.visible = false;
                return q;
            } else if (name == "确认按钮") {
                var tip:PackTips = DialogMgr.instance.getDlg(PackTips) as PackTips;
                tip.parent == null && openGridHandler();
                return tip.btn_ok;
            }
            return null;
        }

        override public function get height():Number {
            return 600 * (Constants.isScaleWidth ? Constants.scale_x : Constants.scale);
        }

        override public function get backParam():Object {
            return type == 1 ? 2 : (type == 2 ? 1 : 0);
        }
    }
}
