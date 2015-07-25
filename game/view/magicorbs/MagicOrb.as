package game.view.magicorbs {
    import com.components.RollTips;
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.mvc.interfaces.INotification;
    import com.sound.SoundManager;
    import com.utils.Constants;
    import com.utils.TouchProxy;
    import com.view.base.event.EventType;

    import feathers.controls.Scroller;
    import feathers.data.ListCollection;
    import feathers.layout.TiledColumnsLayout;
    import feathers.layout.TiledRowsLayout;

    import game.data.BagsData;
    import game.data.ForgeData;
    import game.data.Goods;
    import game.data.IconData;
    import game.data.JewelLevData;
    import game.data.MagicorbsData;
    import game.data.WidgetData;
    import game.dialog.DialogBackground;
    import game.dialog.ShowLoader;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.net.GameSocket;
    import game.net.data.IData;
    import game.net.data.c.CBags;
    import game.net.data.c.CForge;
    import game.net.data.c.CGetMagicOrbs;
    import game.net.data.c.CJewelry;
    import game.net.data.c.CMagicOrbsState;
    import game.net.data.c.COversellItem;
    import game.net.data.s.SBags;
    import game.net.data.s.SForge;
    import game.net.data.s.SGetMagicOrbs;
    import game.net.data.s.SJewelry;
    import game.net.data.s.SMagicOrbsState;
    import game.net.data.s.SOversellItem;
    import game.net.data.s.SStrengthen;
    import game.net.data.vo.forgeDoneIds;
    import game.net.data.vo.forgeIds;
    import game.net.data.vo.magicOrbsStateVO;
    import game.view.comm.GetGoodsAwardEffectDia;
    import game.view.comm.menu.MenuFactory;
    import game.view.dispark.DisparkControl;
    import game.view.dispark.data.ConfigDisparkStep;
    import game.view.magicorbs.data.GetMagicOrbs;
    import game.view.magicorbs.render.MagicRender;
    import game.view.magicorbs.render.MagicSynthesRender;
    import game.view.pack.PackTips;
    import game.view.uitils.FunManager;
    import game.view.viewBase.MagicCompositeViewBase;
    import game.view.viewBase.MagicObrGetViewBase;
    import game.view.viewBase.MagicOrbDlaBGBase;
    import game.view.viewBase.MagicSwallowViewBase;
    import game.view.widget.ViewWidget;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;

    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.events.Event;
    import starling.text.TextField;
    import starling.textures.Texture;

    import treefortress.spriter.SpriterClip;

    /**
     *宝珠获取|合成 |吞噬
     * @author liufurong
     */
    public class MagicOrb extends MagicOrbDlaBGBase {
        /**
         *
         * @default
         */
        public static const FOUSE:int = 1;
        /**
         *
         * @default
         */
        public static const TUSHI:int = 2;
        private var isSend:Boolean; //客服端，只请求一次
        private var magicState:Vector.<IData>; //保存宝珠状态
        private var stateVo:magicOrbsStateVO;
        private var magicGetObrDlgBase:MagicObrGetViewBase; //抽取宝珠装备
        private var magicCompositeDlgBase:MagicCompositeViewBase; //宝珠合成
        private var magicSwallowBase:MagicSwallowViewBase; //宝珠吞噬
        private var currentpageIndex:int = 1; //当前页数
        private var currentPageImage:Image; //翻页的标志
        private var dataVector:Vector.<IconData> = null;
        private var factory:MenuFactory = null;

        /**
         *
         */
        public function MagicOrb() {
            background = new DialogBackground();
            isVisible = true;

            _closeButton = btn_close;
            text_diamond.text = GameMgr.instance.diamond + ""; //钻石
            text_coin.text = GameMgr.instance.coin + ""; //金币
            magicGetObrDlgBase = new MagicObrGetViewBase();
            addQuiackChild(magicGetObrDlgBase);
            magicGetObrDlgBase.visible = true;
            magicGetObrDlgBase.txt6.text = Langue.getLangue("magicAutomatic");
            magicGetObrDlgBase.text_over.text = Langue.getLangue("batchSelect");
            magicGetObrDlgBase.cancel.visible = false;
            magicGetObrDlgBase.cancel.addEventListener(Event.TRIGGERED, onCancelSelect);

            magicCompositeDlgBase = new MagicCompositeViewBase();
            addQuiackChild(magicCompositeDlgBase);
            magicCompositeDlgBase.visible = false;

            magicSwallowBase = new MagicSwallowViewBase();
            addQuiackChild(magicSwallowBase);
            magicSwallowBase.visible = false;
        }


        override public function close():void {
            super.close();
        }

        // 宝珠获取|合成 |吞噬菜单按钮
        private function createMenu(index:int = 0):void {
            var onFocus:ISignal = new Signal();
            factory = new MenuFactory();

            var defaultSkin:Texture = AssetMgr.instance.getTexture("ui_button_tiebaomutouanjian");
            var downSkin:Texture = AssetMgr.instance.getTexture("ui_button_tiebaomutouanjian_liang");

            factory.onFocus = onFocus;
            var arr:Array = Langue.getLans("magicEquipSynthesis");
            factory.factory([{"defaultSkin": defaultSkin, "downSkin": downSkin, x: 28, y: 8, onClick: upEquipmentList, isSelect: index == 0,
                                 size: 32, color: 0xFFE7D0, text: arr[0], scale: 1}, {"defaultSkin": defaultSkin, "downSkin": downSkin,
                                 x: 178, y: 8, onClick: upSynthesisList, isSelect: index == 1, size: 32, color: 0xFFE7D0,
                                 text: arr[1], scale: 1}, {"defaultSkin": defaultSkin, "downSkin": downSkin, x: 328, y: 8,
                                 onClick: upSwallowList, isSelect: index == 2, size: 32, color: 0xFFE7D0, text: arr[2], scale: 1}]);
            addChild(factory);

            DisparkControl.dicDisplay["magic_table_0"] = factory.tableButtons[0];
            DisparkControl.dicDisplay["magic_table_1"] = factory.tableButtons[1];
            DisparkControl.dicDisplay["magic_table_2"] = factory.tableButtons[2];

            //智能判断是否添加功能开放提示图标（抽取）
            DisparkControl.instance.addDisparkHandler(ConfigDisparkStep.DisparkStep14);
            //智能判断是否添加功能开放提示图标（合成）
            DisparkControl.instance.addDisparkHandler(ConfigDisparkStep.DisparkStep18);
            //智能判断是否添加功能开放提示图标（吞噬）
            DisparkControl.instance.addDisparkHandler(ConfigDisparkStep.DisparkStep20);
        }
        private var _currentMenuIndex:int = -1;

        override public function open(container:DisplayObjectContainer, parameter:Object = null, okFun:Function = null, cancelFun:Function = null):void {
            createMenuMagicButton();
            _factory.visible = false;

            super.open(container, parameter, okFun, cancelFun);

            if (parameter) {

                createMenu(parameter[0]);
                factory.selectedIndex = parameter[0];
                if (parameter.length == 2)
                    _parameter = parameter[1];
                upSwallowList(null);
            } else {
                createMenu();
                factory.selectedIndex = 0;
                upEquipmentList(null);
            }
            setToCenter();

            for (var i:int = 0; i < 5; i++) {
                if (1 <= i <= 5) {
                    this["Page" + (i + 1)].texture = AssetMgr.instance.getTexture("ui_gongyong_yemianqiehuan2");
                }
            }

        }

        // 创建宝珠背包 
        private function createGrid():void {
            var goodsList:Vector.<Goods> = WidgetData.getMagicBalls(4, 2); // 获取背包里现有的宝珠
            var len:int = 120;
            var orgLen:int = goodsList.length;
            var magicArray:Array = [];
            var defaultItem:GetMagicOrbs;

            for (var i:int = 0; i < len; i++) {
                var magicOrbs:GetMagicOrbs = new GetMagicOrbs();
                if (i < orgLen) {
                    var widget:Goods = goodsList[i];
                    magicOrbs.id = widget.id;
                    magicOrbs.level = widget.level;
                    magicOrbs.type = widget.type;
                    magicOrbs.pile = widget.pile;
                    magicOrbs.quality = widget.quality;
                    magicOrbs.exp = widget.exp;
                    if (_id > 0 && magicOrbs.id == _id) {
                        defaultItem = magicOrbs;
                    } else if (_parameter is WidgetData && (_parameter as WidgetData).id == magicOrbs.id) {
                        defaultItem = magicOrbs;
                    }
                }
                magicOrbs.gridLock = i >= GameMgr.instance.bagprop;
                magicArray[i] = magicOrbs;
            }

            if (widget && widget.type >= 0) {
                magicArray.sortOn(["quality", "level", "type", "exp"], Array.DESCENDING);
                isNullOrb(false);
            } else {
                isNullOrb(true);
            }
            var index:int = magicArray.indexOf(defaultItem);
            if (index > -1) {
                list_bag.scrollToDisplayIndex(index);
            }

            list_bag.dataProvider = new ListCollection(magicArray);
            if (defaultItem) {
                list_bag.selectedItem = defaultItem;
                _id = defaultItem.id;
            } else {
                list_bag.selectedIndex = 0;
                _id = magicArray.length > 0 ? magicArray[0].id : 0;
            }
            GameMgr.instance.onUpateMoney.add(updateMoney);
        }

        private function updateMoney():void {
            text_diamond.text = GameMgr.instance.diamond + ""; //钻石
            text_coin.text = GameMgr.instance.coin + ""; //金币
        }

        override protected function init():void {
            const listLayout:TiledRowsLayout = new TiledRowsLayout();
            listLayout.gap = 15;
            listLayout.paddingTop = 20;
            listLayout.useSquareTiles = false;
            listLayout.useVirtualLayout = true;
            listLayout.verticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.paging = TiledColumnsLayout.PAGING_HORIZONTAL; //自动排列			
            list_bag.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON; //横向滚动 
            list_bag.layout = listLayout;
            list_bag.itemRendererFactory = itemRendererFactory;
            function itemRendererFactory():MagicRender {
                const renderer:MagicRender = new MagicRender();
                return renderer;
            }
            list_bag.snapToPages = true; //启动翻页
            list_bag.addEventListener(Event.SCROLL, onMoveChange); //翻页滚动监听
            list_bag.addEventListener(Event.TRIGGERED, onBuyGrid); //购买格子
            list_bag.addEventListener(Event.SELECT, onSelected); //选中要出售的宝珠
            list_bag.addEventListener(EventType.SELECTED_DEFAULT, onSeletedDefault);
        }

        private function onSeletedDefault(e:Event):void {
            var d:GetMagicOrbs = e.data as GetMagicOrbs;
            if (d) {
                setMagic(d);
                if (_id == 0) {
                    _id = d.id;
                }
            }
        }

        // 页面提示图标切换
        private function onMoveChange():void {
            if ((list_bag.horizontalPageIndex + 1) == currentpageIndex) {
                this["Page" + currentpageIndex].texture = AssetMgr.instance.getTexture("ui_gongyong_yemianqiehuan1"); //默认第一页
                currentPageImage = this["Page" + currentpageIndex];
            } else if (currentPageImage && list_bag.horizontalPageIndex != -1) {
                currentPageImage.texture = AssetMgr.instance.getTexture("ui_gongyong_yemianqiehuan2");
                currentpageIndex = (list_bag.horizontalPageIndex + 1);
                currentPageImage = this["Page" + currentpageIndex];
            }
        }

        // 购买格子
        private function onBuyGrid(e:Event):void {
            isVisible = true;
            var tip:PackTips = DialogMgr.instance.open(PackTips) as PackTips;
            var num:int = GameMgr.instance.bagprop;
            tip.text = Langue.getLangue("okOpenGrid").replace("*", BagsData.hash.getValue(num / 8 + 1).price);
            tip.onOk.addOnce(buyGrid);
        }

        private var _indexNumber:int; //获取当前最高等级宝珠的下标
        private var _isTarget:Boolean;

        // 点击当前可以获取的宝珠
        private function onSiphon(e:Event = null):void {
            var index:int;
            if (!_isTarget) {
                index = int((e.currentTarget as Button).name);
            } else {
                index = _indexNumber;
                _isTarget = false;
            }
            var magicData:MagicorbsData = MagicorbsData.hash.getValue(index);
            var goodsList:Vector.<Goods> = WidgetData.getMagicBalls(4, 2);

            if (magicData.coinType == 2 && GameMgr.instance.diamond < magicData.coinCount) {
                RollTips.add(Langue.getLangue("diamendNotEnough")); //钻石不足
            } else if (goodsList.length >= GameMgr.instance.bagprop) {
                RollTips.add(Langue.getLangue("orbCaps")); //宝珠获取上限
            } else {
                var cmd:CGetMagicOrbs = new CGetMagicOrbs();
                cmd.level = index;
                GameSocket.instance.sendData(cmd);

                if (index != 1) //如果抽取宝珠1级,则当前等级的宝珠,设置为未开启状态,重置显示宝珠状态,只要大于1的宝珠等级,只能抽取一次
                {
                    stateVo = magicState[index - 1] as magicOrbsStateVO;
                    stateVo.state = 0; //未开启
                    showMagicState();
                }
                ShowLoader.add();
            }
        }

        // 请求魔法宝珠状态
        private function stateSend():void {
            var cmd:CMagicOrbsState = new CMagicOrbsState();
            GameSocket.instance.sendData(cmd);
            ShowLoader.add();
        }

        // 显示宝珠状态
        private function showMagicState():void {
            if (getChildByName("openAction"))
                getChildByName("openAction").removeFromParent(true);
            var length:int = magicState.length;
            for (var i:int = 0; i < length; i++) {
                stateVo = magicState[i] as magicOrbsStateVO;
                //宝珠未开启
                if (stateVo.state == 0) {
                    magicGetObrDlgBase["mask" + (stateVo.level - 1)].visible = true; //头像变暗,头像遮罩
                    magicGetObrDlgBase["up" + (stateVo.level - 1)].texture = AssetMgr.instance.getTexture("ui_zhuangshi_baozhuhuoqu_jiantou2"); //箭头变灰
                } else { //宝珠开启
                    if (stateVo.level != 1) //如果宝珠开启的等级不是1级,就变亮
                    {
                        magicGetObrDlgBase["mask" + (stateVo.level - 1)].visible = false; //头像遮罩去掉
                        magicGetObrDlgBase["up" + (stateVo.level - 1)].texture = AssetMgr.instance.getTexture("ui_zhuangshi_baozhuhuoqu_jiantou1"); //箭头变

                        if (getChildByName("openAction"))
                            getChildByName("openAction").removeFromParent(true);
                        createAction(magicGetObrDlgBase["button" + (stateVo.level)], "openAction");
                    }
                }
            }
        }

        private function createAction(child:DisplayObject, name:String):SpriterClip {
            //这是点击想获取宝珠上的效果
            var action:SpriterClip = AnimationCreator.instance.create("effect_030", AssetMgr.instance);
            action.play("effect_030");
            Starling.juggler.add(action);
            action.x = child.x + child.width / 2;
            action.y = child.y + child.height / 2;
            addQuiackChildAt(action, magicGetObrDlgBase.button1.numChildren - 1);
            action.touchable = false;
            action.animation.looping = true;
            action.name = name;
            return action;
        }

        // 添加一个宝珠
        private function updateAnimation(id:int, goods:Goods):void {
            var oldArr:Array = (list_bag.dataProvider.data as Array);
            var len:int = oldArr.length;
            var iconData:IconData = null;
            dataVector = new Vector.<IconData>;
            for (var i:int = 0; i < len; i++) {
                var oldData:GetMagicOrbs = oldArr[i];
                if (oldData.id == id) {
                    oldData.animation = true;
                    list_bag.dataProvider.updateItem(oldData);

                    iconData = new IconData();
                    iconData.IconId = oldData.id;
                    iconData.QualityTrue = "ui_gongyong_90wupingkuang" + (goods.quality - 1);
                    iconData.IconTrue = goods.picture;
                    iconData.HeroSignTrue = "";
                    iconData.Num = "Lv " + 1;
                    iconData.IconType = goods.type;
                    iconData.Name = goods.name;
                    dataVector.push(iconData);
                    break;
                }
            }
        }

        //获取宝珠
        private function getMagicDataOrbs(info:SGetMagicOrbs):void {
            if (0 == info.code) {
                //抽取成功，获得宝珠
                if (info.type > 0) //小于,没有宝珠
                {
                    var goods:Goods = Goods.goods.getValue(info.type);
//					RollTips.add(Langue.getLangue("Congratulations_to_get") + goods.name); //提示获得什么宝珠
                    createGrid();
                    updateAnimation(info.id, goods); //把宝珠数据储存取出来用于显示宝珠
                    if (goods.quality >= 4) {
                        var effectData:Object = {vector: dataVector, effectPoint: null, effectName: "effect_036", effectSound: "baoxiangkaiqihuode",
                                effectFrame: 299};
                        isVisible = true;
                        DialogMgr.instance.open(GetGoodsAwardEffectDia, effectData, null, null, "translucence", 0x000000,
                                                1);
                    }
                }
                if (info.level > 1) //大于1，开启下一个宝珠等级
                {
                    stateVo = magicState[info.level - 1] as magicOrbsStateVO;
                    stateVo.state = 1; //开启
                    showMagicState(); //重置
                }
            } else if (1 == info.code) {
                RollTips.add(Langue.getLangue("notEnoughCoin")); //金币不足
            } else if (2 == info.code) {
                RollTips.add(Langue.getLangue("notEnoughCoin")); //钻石不足
            } else if (3 == info.code) {
                RollTips.add(Langue.getLangue("packFulls")); //背包已满
                showMagicState(); //重置
            } else if (127 <= info.code) {
//				RollTips.add(Langue.getLangue("codeError") + info.code); //程序异常
            }
            ShowLoader.remove();
        }

        // 智能抽取当前可以抽取最高的宝珠 
        private function upAutomaticMagic(e:Event):void {
            var typeOrb:int = 0;
            for (var i:int = 0; i < 5; i++) {
                if (i != 4) {
                    if (magicGetObrDlgBase["mask" + (i + 1)].visible == false) {
                        _indexNumber = i + 2;
                    } else {
                        typeOrb++;
                    }
                }
            }
            if (4 == typeOrb) {
                _indexNumber = 1;
            }
            typeOrb = 0;
            _isTarget = true;
            onSiphon();
        }

        // 获取宝珠状态
        private function getMagicOrbsState(info:SMagicOrbsState):void {
            isSend = true;
            magicState = info.magicOrbs; //保存状态
            showMagicState(); //显示状态
            ShowLoader.remove();
        }

        override protected function addListenerHandler():void {
            super.addListenerHandler();
            magicGetObrDlgBase.btn_automatic.addEventListener(Event.TRIGGERED, upAutomaticMagic); // 抽取最高的宝珠
            magicGetObrDlgBase.btn_sell.addEventListener(Event.TRIGGERED, onSell); //全部出售
            magicSwallowBase.btn_addOrb.addEventListener(Event.TRIGGERED, addOrb);
        }

        private function addOrb():void {
            createMenu(0);
            factory.selectedIndex = 0;
            magicGetObrDlgBase.visible = true;
            magicSwallowBase.visible = false;
        }

        //请求购买道具格子
        private function buyGrid():void {
            isVisible = false;
            var cmd:CBags = new CBags();
            var num:int = GameMgr.instance.bagprop;
            cmd.line = num / 8 + 1;
            cmd.tab = TYPE_GRID;
            cmd.type = 1;
            GameSocket.instance.sendData(cmd);
            ShowLoader.add();
        }

        private var _selectList:Vector.<int>; //选中的物品

        override public function handleNotification(_arg1:INotification):void {
            var effectData:Object = null;
            if (_arg1.getName() == String(SStrengthen.CMD)) {
                var sst:SStrengthen = _arg1 as SStrengthen;
                if (7 == sst.code) {
                    RollTips.add(Langue.getLangue("magicLevelLimit"));
                }
            }

            // 吞噬成功后
            else if (_arg1.getName() == String(SJewelry.CMD)) {
                var jewelry:SJewelry = _arg1 as SJewelry;
                var wi:WidgetData = WidgetData.hash.getValue(_id);
                var iconData:IconData = null;
                dataVector = new Vector.<IconData>;
                if (0 == jewelry.code) {
//					RollTips.add(Langue.getLangue("successEngulf") + wi.name); // 成功

                    iconData = new IconData();
                    iconData.IconId = wi.id;
                    iconData.QualityTrue = "ui_gongyong_90wupingkuang" + (wi.quality - 1);
                    iconData.IconTrue = wi.picture;
                    iconData.HeroSignTrue = "";
                    iconData.Num = "Lv " + jewelry.level;
                    iconData.IconType = wi.type;
                    iconData.Name = wi.name;
                    dataVector.push(iconData);
                    effectData = {vector: dataVector, effectPoint: null, effectName: "effect_036", effectSound: "baoxiangkaiqihuode",
                            effectFrame: 299};
                    DialogMgr.instance.open(GetGoodsAwardEffectDia, effectData, null, null, "translucence", 0x000000, 1);
                } else if (1 == jewelry.code) {
                    RollTips.add(Langue.getLangue("noGoEngulf")); //失败
                } else if (2 == jewelry.code) {
                    RollTips.add(Langue.getLangue("NOT_ENOUGH_MAG")); //宝珠不足
                } else if (4 == jewelry.code) {
                    RollTips.add(Langue.getLangue("notEnoughCoin")); //金币不足
                } else if (5 == jewelry.code) {
                    RollTips.add(Langue.getLangue("diamendNotEnough")); //钻石不足
                } else if (127 <= jewelry.code) {
//					RollTips.add(Langue.getLangue("activityCode127")); //程序异常
                }
                wi.exp = jewelry.exp;
                wi.level = jewelry.level;
                createGrid();
                updataExpBar(null);
            }

            // 请求合成成功的后
            else if (_arg1.getName() == String(SForge.CMD)) {
                var sfo:SForge = _arg1 as SForge;
                if (2 == sfo.code) {
                    RollTips.add(Langue.getLangue("NOT_ENOUGH")); //材料不足
                } else if (3 == sfo.code) {
                    RollTips.add(Langue.getLangue("packFulls")); //背包已满
                } else if (4 == sfo.code) {
                    RollTips.add(Langue.getLangue("notEnoughCoin")); //金币不足
                } else if (5 == sfo.code) {
                    RollTips.add(Langue.getLangue("diamendNotEnough")); //钻石不足
                } else if (127 <= sfo.code) {
                    RollTips.add(Langue.getLangue("noMagicFusion")); //批量的合成材料不足
                }
                magicCompositeDlgBase.list_magic.dataViewPort.dataProvider_refreshItemHandler(); //刷新List整页数据
                magicCompositeDlgBase.list_magic.dataProvider.updateItem(magicCompositeDlgBase.list_magic.selectedIndex);

                var props:Vector.<IData> = sfo.ids;
                var sflen:int = props.length;
                var forgeDoneData:forgeDoneIds;
                for (var sf:int = 0; sf < sflen; ++sf) {
                    forgeDoneData = props[sf] as forgeDoneIds;
                    if (0 == forgeDoneData.type) {
//						RollTips.add(Langue.getLangue("FORGE_SUCCESS")); //合成成功
                        effectData = {vector: dataVector, effectPoint: null, effectName: "effect_036", effectSound: "baoxiangkaiqihuode",
                                effectFrame: 299};
                        DialogMgr.instance.open(GetGoodsAwardEffectDia, effectData, null, null, "translucence", 0x000000,
                                                1);
                    } else if (1 == forgeDoneData.type) {
                        RollTips.add(Langue.getLangue("FORGE_FAIL")); //合成失败
                    }
                }
                upDataTypeface();
                ShowLoader.remove();
            }

            // 购买格子成功
            else if (_arg1.getName() == String(SBags.CMD)) {
                var sbags:SBags = _arg1 as SBags;
                if (0 == sbags.code) {
                    GameMgr.instance.bagprop = sbags.bags;
                    RollTips.add(Langue.getLangue("openGrid"));
                } else if (1 == sbags.code) {
                    RollTips.add(Langue.getLangue("diamendNotEnough"));
                } else if (127 <= sbags.code) {
//					RollTips.add(Langue.getLangue("codeError") + sbags.code);
                }
                createGrid();
                isSelectPage();
            }

            //宝珠状态
            else if (_arg1.getName() == String(SMagicOrbsState.CMD)) {
                getMagicOrbsState(_arg1 as SMagicOrbsState);
            } else if (_arg1.getName() == String(SGetMagicOrbs.CMD)) {
                getMagicDataOrbs(_arg1 as SGetMagicOrbs);
            }

            //出售宝珠飞到桶的体验表现
            else if (_arg1.getName() == SOversellItem.CMD.toString()) {
                var sellItem:SOversellItem = _arg1 as SOversellItem;
                if (0 == sellItem.code) {
                    var count:int = 0;
                    var oldArr:Array = (list_bag.dataProvider.data as Array).concat();
                    var len:int = oldArr.length;
                    var k:int = 0;
                    for (var i:int = 0; i < len; i++) {
                        var oldData:GetMagicOrbs = oldArr[i];
                        if (oldData.type == 0)
                            break;
                        if (_selectList.indexOf(oldData.id) != -1) {
                            var goods:Goods = Goods.goods.getValue(oldData.type);
                            var widget:ViewWidget = new ViewWidget(goods);
                            var v:int = ((i % 24) % 8) * (15 + 90) + list_bag.x;
                            var h:int = ((i % 24) / 8) * (15 + 90) + list_bag.y + 20;
                            widget.x = v;
                            widget.y = h;
                            k++;
                            addQuiackChild(widget);
                            Starling.juggler.tween(widget, 0.3, {x: 785, y: 410, onCompleteArgs: [widget], onComplete: complete});
                        }
                    }
                    createGrid();

                    function complete(widget:ViewWidget):void {
                        widget.removeFromParent(true);
                        count++;
                        if (count == k) {
                            onCancelSelect(); //出售成功关闭桶
                            SoundManager.instance.playSound("deal");
                        }
                    }
                    RollTips.add(Langue.getLangue("sellOk"));
                } else {
                    RollTips.add(Langue.getLangue("codeError") + sellItem.code);
                }
            }
            ShowLoader.remove();
        }

        // 这也是监听事件
        override public function listNotificationName():Vector.<String> {
            var vect:Vector.<String> = new Vector.<String>;
            vect.push(SMagicOrbsState.CMD, SBags.CMD, SForge.CMD, SOversellItem.CMD, SGetMagicOrbs.CMD, SJewelry.CMD, SStrengthen.CMD);
            return vect;
        }

        //购买格子定位当前页
        private function isSelectPage():void {
            var _index:int = (currentpageIndex - 1) * 24;
            list_bag.scrollToDisplayIndex(_index);
            list_bag.dataViewPort.dataProvider_refreshItemHandler();
        }

        private var _isSelect:Boolean = false; // 标志当前是否选择被吞噬状态  true  为选择被吞噬状态
        private const TYPE_GRID:int = 2;

        //取消选择
        private function onCancelSelect(e:Event = null):void {
            var sellButton:Button = magicGetObrDlgBase.btn_sell;
            var overTxt:TextField = magicGetObrDlgBase.text_over;
            var closeButton:Button = magicGetObrDlgBase.cancel;
            if (magicGetObrDlgBase.getChildByName("action")) {
                magicGetObrDlgBase.getChildByName("action").removeFromParent(true);
            }
            sellButton.visible = true;
            closeButton.visible = false;
            _isSelect = false;
            overTxt.text = Langue.getLangue("batchSelect");
            unRock();
        }

        // 不抖动
        private function unRock():void {
            if (list_bag.dataProvider && list_bag.dataProvider.data) {
                var oldArr:Array = (list_bag.dataProvider.data as Array);
                var len:int = oldArr.length;
                for (var i:int = 0; i < len; i++) {
                    var oldData:GetMagicOrbs = oldArr[i];
                    if (oldData.type > 0) {
                        oldData.rock = false;
                        oldData.selected = false;
                        list_bag.dataProvider.updateItem(oldData);
                    } else {
                        break;
                    }
                }
            }

        }

        // 抖动
        private function rock():void {
            var oldArr:Array = (list_bag.dataProvider.data as Array);
            var len:int = oldArr.length;
            for (var i:int = 0; i < len; i++) {
                var oldData:GetMagicOrbs = oldArr[i];
                if (oldData.type > 0) {
                    oldData.rock = true;
                    list_bag.dataProvider.updateItem(oldData);
                } else {
                    break;
                }
            }
        }

        private var _totalCoin:int;

        private function calcCoin(getMagicOrbs:GetMagicOrbs):void {
            var widget:WidgetData = WidgetData.hash.getValue(getMagicOrbs.id);
            var arrayJew:JewelLevData = JewelLevData.JewelLevHash.getValue(widget.level + "" + widget.quality);
            getMagicOrbs.selected ? _totalCoin += arrayJew.coin : _totalCoin -= arrayJew.coin;
            magicSwallowBase.text_money.text = _totalCoin + "";
            magicSwallowBase.text_money.color = _totalCoin < GameMgr.instance.coin ? 0xFFFFCC : 0xFF0000;
        }

        // 选中要出售的宝珠 || 吞噬的材料
        private function onSelected(e:Event):void {
            var getMagicOrbs:GetMagicOrbs = e.data as GetMagicOrbs;
            if (_currentMenuIndex == 2 && getMagicOrbs && getMagicOrbs.rock && _id > 0 && _id == getMagicOrbs.id) {
                RollTips.add(Langue.getLangue("onCannotSwallow"));
                return;
            }
            var widget:WidgetData = WidgetData.hash.getValue(getMagicOrbs.id);

            if (_currentMenuIndex == 2 && getMagicOrbs.id == _id)
                return;
            if (getMagicOrbs.type > 0 && _isSelect) {
                getMagicOrbs.selected = !getMagicOrbs.selected;
                list_bag.dataProvider.updateItem(getMagicOrbs);

                var oldArr:Array = (list_bag.dataProvider.data as Array);
                var len:int = oldArr.length;
                var existSelected:Boolean = false;
                for (var i:int = 0; i < len; i++) {
                    var oldData:GetMagicOrbs = oldArr[i];
                    if (oldData.type == 0) {
                        break;
                    }

                    if (oldData.selected) {
                        existSelected = true;
                        break;
                    }
//					if (getMagicOrbs.quality < oldData.quality)
//					{
//						var tip : ResignDlg = DialogMgr.instance.open(ResignDlg) as ResignDlg;
//						tip.text = getLangue("OkSwallow");
//						tip.onResign.addOnce(isOkClick);
//						tip.onClose.addOnce(isonClose);
//					}
                }
                var closeButton:Button = magicGetObrDlgBase.cancel;
                if (existSelected) {
                    magicGetObrDlgBase.text_over.text = Langue.getLangue("allOversell");
                    closeButton.visible = true;
                } else {
                    magicGetObrDlgBase.text_over.text = Langue.getLangue("batchSelect");
                    closeButton.visible = false;
                }
            }
            var arrayJew:Vector.<*> = JewelLevData.JewelLevHash.values();
            var lenJe:int = arrayJew.length;
            var tmpJewData:JewelLevData;

            var addExp:int;
            for (var j:int = 0; j < lenJe; ++j) {
                tmpJewData = arrayJew[j] as JewelLevData;
            }

            if (_isSelect && getMagicOrbs.type > 0) {
                updataExpBar(getMagicOrbs);
                calcCoin(getMagicOrbs);
            }
        }

        //点击批量出售
        private function onSell(e:Object):void {
            var action:SpriterClip = AnimationCreator.instance.create("effect_021", AssetMgr.instance, true);
            action.scaleX = 0.7;
            action.scaleY = 0.7;
            var sellButton:Button = magicGetObrDlgBase.btn_sell;
            var overTxt:TextField = magicGetObrDlgBase.text_over;
            _selectList = new Vector.<int>;
            var oldArr:Array = (list_bag.dataProvider.data as Array);
            var len:int = oldArr.length;
            var isExist:Boolean = false;

            for (var i:int = 0; i < len; i++) {
                var oldData:GetMagicOrbs = oldArr[i];
                if (oldData.type == 0) {
                    break;
                }

                isExist = true;
                if (oldData.selected) {
                    _selectList.push(oldData.id);
                }
            }

            if (!_isSelect) {
                if (!isExist) {
                    RollTips.add(Langue.getLangue("currentPageNogoods"));
                    return;
                }
                rock();
                action.play("effect_021");
                Starling.juggler.add(action);
                action.x = sellButton.x + sellButton.width / 2 - 2;
                action.y = sellButton.y + sellButton.height / 2;
                action.name = "action";
                magicGetObrDlgBase.addChildAt(action, magicGetObrDlgBase.getChildIndex(overTxt));
                sellButton.visible = false;
                action.touchable = true;
                var touch:TouchProxy = new TouchProxy(action);
                touch.onClick.addOnce(onSell);

                action.addCallback(function():void {
                    action.stop();
                }, 327, true);
                _isSelect = true;
            } else {
                unRock();
                _isSelect = false;

                if (0 == _selectList.length) {
                    RollTips.add(Langue.getLangue("noSelectSellGoods"));
                    if (magicGetObrDlgBase.getChildByName("action")) {
                        magicGetObrDlgBase.getChildByName("action").removeFromParent(true);
                        sellButton.visible = true;
                    }
                } else {
                    var cmd:COversellItem = new COversellItem();
                    cmd.ids = _selectList;
                    cmd.tab = TYPE_GRID;
                    GameSocket.instance.sendData(cmd);
                    ShowLoader.add();
                }
            }
        }

        // 宝珠抽取的操作
        private function upEquipmentList(evt:Event):void {

            if (!isSend) {
                stateSend();
            } else {
                showMagicState();
            }

            for (var i:int = 0; i < 5; i++) //宝珠等级注册touch
            {
                magicGetObrDlgBase["button" + (i + 1)].addEventListener(Event.TRIGGERED, onSiphon);
                magicGetObrDlgBase["button" + (i + 1)].name = (i + 1) + ""; //用来请求时，发送服务端的等级
                magicGetObrDlgBase["txt" + (i + 1)].text = (MagicorbsData.hash.getValue((i + 1)) as MagicorbsData).coinCount;
            }
            _currentMenuIndex = 0;
            if (getChildByName("openAction"))
                getChildByName("openAction").visible = true;
            list_bag.visible = true;
            _factory.visible = false;
            magicGetObrDlgBase.visible = true;
            magicGetObrDlgBase.cancel.visible = false;
            magicCompositeDlgBase.visible = false;
            magicSwallowBase.visible = false;

            createGrid();
            _isSelect = false;
            PageVisible(true);
        }

        // 宝珠合成的操作
        private function upSynthesisList(evt:Event):void {

            //功能开放是否开放
            if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep20)) {
                createMenu(_currentMenuIndex);
                return;
            }
            //智能判断是否删除功能开放提示图标（合成）
            DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep20);

            if (getChildByName("openAction"))
                getChildByName("openAction").visible = false;
            _currentMenuIndex = 1;
            createMenuMagicButton();
            onCancelSelect();
            unRock();
            getDataForgeList();
            getMagicDataList(2);

            list_bag.visible = false;
            magicGetObrDlgBase.visible = false;
            magicCompositeDlgBase.visible = true;
            magicSwallowBase.visible = false;
            _factory.visible = true;
            magicCompositeDlgBase.txt_Rule.text = Langue.getLangue("magicRule"); // 规则
            magicCompositeDlgBase.txt_Prompt.text = Langue.getLangue("magicPrompt"); // 提示
            magicCompositeDlgBase.txt_siphon.text = Langue.getLangue("magicSiphon"); // 批量合成
            magicCompositeDlgBase.txt_reform.text = Langue.getLangue("magicReform"); // 合成

            magicCompositeDlgBase.list_magic.addEventListener(Event.SELECT, onSelectOrb); //选中的宝珠
            magicCompositeDlgBase.btn_batch.addEventListener(Event.TRIGGERED, onBatchMagicList); // 批量合成
            magicCompositeDlgBase.btn_Reform.addEventListener(Event.TRIGGERED, onReform); //合成单个宝珠
            GameMgr.instance.onUpateMoney.add(updateMoney);
            PageVisible(false);
        }

        // 宝珠吞噬操作
        private function upSwallowList(e:Event):void {
            //功能开放是否开放
            if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep18)) {
                createMenu(_currentMenuIndex);
                return;
            }
            //智能判断是否删除功能开放提示图标（吞噬）
            DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep18)


            if (getChildByName("openAction"))
                getChildByName("openAction").visible = false;
            _id = 0;
            _currentMenuIndex = 2;
            magicSwallowBase.bgNextExp.width = 0;
            magicSwallowBase.bgCurrentExp.width = 0;

            onCancelSelect();
            _factory.visible = false;
            list_bag.visible = true;
            magicGetObrDlgBase.visible = false;
            magicCompositeDlgBase.visible = false;
            magicSwallowBase.visible = true;

            magicSwallowBase.text_addOrb.text = Langue.getLangue("add_OrbMagic"); //加入宝珠
            magicSwallowBase.text_Prompt.text = Langue.getLangue("add_orb_Prompt"); //提示
            magicSwallowBase.text_CurrentLevel.text = Langue.getLangue("CurrentLevel"); //当前等级
            magicSwallowBase.text_NextLevel.text = Langue.getLangue("NextLevel"); //下一等级
            magicSwallowBase.text_fixEngulfMagic.text = Langue.getLangue("fixEngulfMagic"); //确定吞噬
            magicSwallowBase.text_useup.text = Langue.getLangue("useup"); //消耗
            magicSwallowBase.text_selectMagic.text = Langue.getLangue("selectMagic"); //选择宝珠

            magicSwallowBase.btn_Select.addEventListener(Event.TRIGGERED, onBtnSelect); //选择要进行吞噬的宝珠材料
            magicSwallowBase.cancel.addEventListener(Event.TRIGGERED, onSwallow); //取消
            magicSwallowBase.btn_Fix.addEventListener(Event.TRIGGERED, onBtnFix); //确定吞噬

            createGrid();
            onSwallow();
            magicSwallowBase.btn_Select.visible = false;
            magicSwallowBase.text_selectMagic.visible = false;
            PageVisible(true);
        }

        private var Locking:Boolean = false; //点击选择宝珠就锁定要吞噬的宝珠
        private var _id:int; //选中要升级的宝珠ID

        //选择一个吞噬升级的宝珠
        private function onMagicSelect(e:Event):void {
            var getMagicOrbs:GetMagicOrbs = e.data as GetMagicOrbs;
            if (!getMagicOrbs.rock) {
                _id = getMagicOrbs.id;
            }

            var goods:Goods = Goods.goods.getValue(getMagicOrbs.type);
            var goodsVector:Vector.<*> = Goods.goods.values();
            var length:int = goodsVector.length;
            for (var i:int = 0; i < length; i++) {
                dataGoodsOrb = goodsVector[i] as Goods;
                // 过滤宝珠
                if (dataGoodsOrb.tab == 2 && dataGoodsOrb.sort == 4 && !getMagicOrbs.gridLock && getMagicOrbs.type > 0) {
                    dataGoodsOrb = goods;
                    break;
                }
            }
            setMagic(getMagicOrbs);
            if (getMagicOrbs && getMagicOrbs.type > 0) {
                updataExpBar(null);
            }
        }

        private function setMagic(getMagicOrbs:GetMagicOrbs):void {
            if (!Locking && !getMagicOrbs.gridLock && !_isSelect && getMagicOrbs.type > 0) {
                var goods:Goods = WidgetData.hash.getValue(getMagicOrbs.id);
                if (goods && goods.type > 0) {
                    isNullOrb(false);
                    magicSwallowBase.SelectQuality.texture = AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (goods.quality - 1));
                    magicSwallowBase.SelectIco.texture = AssetMgr.instance.getTexture(goods.picture);
                }
                // goods.magicIndex代表的是  1攻击,  2血量 , 3防御 , 4穿刺,  5命中 , 6闪避,  7暴击 , 8暴强 , 9免爆 , 10韧性
                var textArray:Array = Langue.getLans("MAGICBALL");
                if (goods.tab == 2 && goods.sort == 4) {
                    magicSwallowBase.text_attack1.text = magicSwallowBase.text_attack2.text = textArray[goods.magicIndex - 1];
                }
            }
        }

        private function TextNull():void {
            var selectedWidget:WidgetData = WidgetData.hash.getValue(_id); // 获取当前升级的宝珠
            var arrayJew:JewelLevData = JewelLevData.JewelLevHash.getValue(selectedWidget.level + "" + selectedWidget.quality);
            magicSwallowBase.text_Lv1.text = Langue.getLangue("magicLevel") + selectedWidget.level + "";
            magicSwallowBase.text_Lv2.text = Langue.getLangue("magicLevel") + selectedWidget.level + "";
            magicSwallowBase.text_Lv3.text = Langue.getLangue("magicLevel") + Langue.getLangue("Orb_Top_Level");
            magicSwallowBase.text_Lv3.fontSize = 18;
            magicSwallowBase.text_Lv3.x = 655;
            magicSwallowBase.text_Lv3.y = 530;
            magicSwallowBase.text_currentProperty.text = selectedWidget.propertyValue + "";
            magicSwallowBase.text_nextProperty.text = selectedWidget.propertyValue + "";
            magicSwallowBase.bgCurrentExp.width = magicSwallowBase.bg.width - 15;
            magicSwallowBase.text_currentExp.text = "";
        }

        private var _totalExp:int;
        private var _tExp:int;
        private var _isExpTop:Boolean;

        /**
         * 刷新宝珠吞噬升级进度显示
         * @param currentExp
         * @param addExp
         * @param nextExp
         */
        private function updataExpBar(getMagicOrbs:GetMagicOrbs):void {
            if (_id == 0)
                return;
            if (_currentMenuIndex != 2)
                return;
            var selectedWidget:WidgetData = WidgetData.hash.getValue(_id); // 获取当前升级的宝珠
            var arrayJew:JewelLevData = JewelLevData.JewelLevHash.getValue(selectedWidget.level + "" + selectedWidget.quality);
            if (arrayJew.exp == 0) {
                TextNull();
                return;
            } else {
                magicSwallowBase.text_Lv3.fontSize = 24;
                magicSwallowBase.text_Lv3.x = 648;
                magicSwallowBase.text_Lv3.y = 528;
            }

            if (getMagicOrbs) {
                var widget:WidgetData = WidgetData.hash.getValue(getMagicOrbs.id);
                arrayJew = JewelLevData.JewelLevHash.getValue(widget.level + "" + widget.quality);
                getMagicOrbs.selected ? _totalExp += arrayJew.provide : _totalExp -= arrayJew.provide; // 计算所有被选中的宝珠升级经验
            }
            var arr:Vector.<*> = JewelLevData.JewelLevHash.values();
            var len:int = arr.length;
            var tArr:Array = [];
            var g:int = 0;
            //  筛选宝珠吞噬表里适合的宝珠升级数据，相同品级、弃用等级无用数据，并进行排序
            for (var i:int = 0; i < len; i++) {
                var tData:JewelLevData = arr[i] as JewelLevData;
                if (tData.quality == selectedWidget.quality) {
                    if (tData.exp != 0 && tData.level >= selectedWidget.level) {
                        tArr[g++] = tData;
                    }
                }
            }
            tArr.sortOn(["quality", "level"], Array.NUMERIC); //数组默认是按照字符串排序
            len = tArr.length;
            var frontExp:int = 0;
            var nextJewelLevData:JewelLevData;
            var tExp:int = 0;
            for (i = 0; i < len; i++) {
                tData = tArr[i] as JewelLevData;
                nextJewelLevData = tData;
                frontExp = tExp;
                tExp += tData.exp;
                if (_totalExp + selectedWidget.exp < tExp) {
                    nextJewelLevData = tData;
                    break;
                }
            }

            if (_totalExp + selectedWidget.exp > tExp) {
                _isExpTop && getMagicOrbs.selected && RollTips.add(Langue.getLangue("Orb_Exp_top"));
                _isExpTop = true;
            } else {
                _isExpTop = false;
            }

            magicSwallowBase.text_Lv1.text = Langue.getLangue("magicLevel") + selectedWidget.level + ""; // 当前等级
            magicSwallowBase.text_Lv2.text = Langue.getLangue("magicLevel") + nextJewelLevData.level + "";
            var property:int = selectedWidget.propertyValue; // 当前属性值
            magicSwallowBase.text_currentProperty.text = property + "";

            var nextSumProperty:int = FunManager.jewelry_upgrade(selectedWidget.control2, nextJewelLevData.level + 1); //下一个宝珠属性总值
            magicSwallowBase.text_Lv3.text = Langue.getLangue("magicLevel") + (nextJewelLevData.level + 1); // 下个等级
            var _nextProperty:int = nextSumProperty - property; //下一个宝珠等级要加的属性值
            magicSwallowBase.text_nextProperty.text = property + " + " + _nextProperty + "";
            var add:int = 0;
            var bgW:int = magicSwallowBase.bg.width - 15;
            if (selectedWidget.level != nextJewelLevData.level) {
                add = _totalExp + selectedWidget.exp - frontExp;
                var addExpW:int = bgW * (add / nextJewelLevData.exp);
                magicSwallowBase.bgNextExp.width = addExpW > bgW ? bgW : addExpW; //中间层 绿色条

                var currentExpW:int = bgW * (selectedWidget.exp / nextJewelLevData.exp);
//				magicSwallowBase.bgCurrentExp .width = currentExpW > bgW ? bgW : currentExpW;	//最上层 黄色条
                magicSwallowBase.bgCurrentExp.width = 0;
                magicSwallowBase.bgNextExp.x = 250;
            } else {
                add = _totalExp - frontExp;
                addExpW = bgW * (add / nextJewelLevData.exp);
                currentExpW = bgW * (selectedWidget.exp / nextJewelLevData.exp);
                magicSwallowBase.bgCurrentExp.width = currentExpW > bgW ? bgW : currentExpW; //最上层 黄色条

                magicSwallowBase.bgNextExp.width = addExpW > bgW - magicSwallowBase.bgCurrentExp.width ? bgW - magicSwallowBase.bgCurrentExp.width : addExpW; //中间层 绿色条
                magicSwallowBase.bgNextExp.x = magicSwallowBase.bgCurrentExp.x + magicSwallowBase.bgCurrentExp.width;
            }
            magicSwallowBase.text_currentExp.text = selectedWidget.exp + " ( + " + add + " ) " + " / " + nextJewelLevData.exp;
        }

        // 选择要吞噬的宝珠材料
        private function onBtnSelect(e:Event):void {
            if (_id == 0) {
                RollTips.add(Langue.getLangue("Orb_please_select"));
                return;
            }
            var selectedWidget:WidgetData = WidgetData.hash.getValue(_id); // 获取当前升级的宝珠
            var arrayJew:JewelLevData = JewelLevData.JewelLevHash.getValue(selectedWidget.level + "" + selectedWidget.quality);
            if (arrayJew.exp == 0) {
                RollTips.add(Langue.getLangue("Orb_Level_top"));
                TextNull();
            } else {
                BtnVisible(true);
                Locking = true;
                rock();
                _isSelect = true;
                list_bag.removeEventListener(Event.SELECT, onMagicSelect); //选择要进行吞噬升级的宝珠
            }
        }

        // 确定吞噬宝珠
        private function onBtnFix(e:Event):void {
            var _jwselectList:Vector.<int> = new Vector.<int>;
            var oldArr:Array = (list_bag.dataProvider.data as Array);
            var len:int = oldArr.length;
            var isExist:Boolean = false;
            for (var i:int = 0; i < len; i++) {
                var oldData:GetMagicOrbs = oldArr[i];
                if (oldData.type == 0) {
                    break;
                }

                isExist = true;
                if (oldData.selected) {
                    _jwselectList.push(oldData.id);
                }
            }

            if (_isSelect) {
                if (0 == _jwselectList.length) {
                    RollTips.add(Langue.getLangue("noSelectfixEngulfMagic"));
                } else {
                    if (_totalCoin > GameMgr.instance.coin) {
                        RollTips.add(Langue.getLangue("notEnoughCoin")); //金币不足
                        return;
                    } else {
                        var cmd:CJewelry = new CJewelry();
                        var ids:Vector.<int> = new Vector.<int>();
                        cmd.id = _id;
                        cmd.ids = _jwselectList;
                        ids.push(cmd);
                        GameSocket.instance.sendData(cmd);
                        ShowLoader.add();
                    }
                }
                onSwallow();
                createGrid();
            }
        }

        // 取消选择要吞噬的宝珠
        private function onSwallow():void {
            BtnVisible(false);
            Locking = false;
            _isSelect = false;
            unRock();
            magicSwallowBase.text_money.text = "";
            _totalCoin = 0;
            _totalExp = 0;
            _tExp = 0;
            updataExpBar(null);
            list_bag.addEventListener(Event.SELECT, onMagicSelect); //选择要进行吞噬升级的宝珠
        }

        private function PageVisible(vis:Boolean = false):void {
            var len:int = 5;
            for (var i:int = 0; i < len; ++i) {
                this["Page" + (i + 1)].visible = vis;
                this["onPage" + (i + 1)].visible = vis;
            }
        }

        private function BtnVisible(boo:Boolean = false):void {
            if (!boo) {
                magicSwallowBase.btn_Select.visible = true;
                magicSwallowBase.text_selectMagic.visible = true;

                magicSwallowBase.text_fixEngulfMagic.visible = false;
                magicSwallowBase.text_useup.visible = false;
                magicSwallowBase.text_money.visible = false;
                magicSwallowBase.cancel.visible = false;
                magicSwallowBase.moneyIco.visible = false;
                magicSwallowBase.btn_Fix.visible = false;
            } else {
                magicSwallowBase.btn_Select.visible = false;
                magicSwallowBase.text_selectMagic.visible = false;

                magicSwallowBase.text_fixEngulfMagic.visible = true;
                magicSwallowBase.text_useup.visible = true;
                magicSwallowBase.text_money.visible = true;
                magicSwallowBase.cancel.visible = true;
                magicSwallowBase.moneyIco.visible = true;
                magicSwallowBase.btn_Fix.visible = true;
            }
        }

        private function isNullOrb(boo:Boolean = false):void {
            if (!boo) {
                magicSwallowBase.btn_Select.visible = true;
                magicSwallowBase.text_selectMagic.visible = true;
                magicSwallowBase.SelectIco.visible = true;
                magicSwallowBase.SelectQuality.visible = true;
                magicSwallowBase.btn_Select.touchable = true;
                magicSwallowBase.bg.visible = true;
                magicSwallowBase.text_CurrentLevel.visible = true;
                magicSwallowBase.text_NextLevel.visible = true;
                magicSwallowBase.text_Lv1.visible = true;
                magicSwallowBase.text_Lv2.visible = true;
                magicSwallowBase.text_Lv3.visible = true;
                magicSwallowBase.text_currentExp.visible = true;
                magicSwallowBase.text_attack1.visible = true;
                magicSwallowBase.text_attack2.visible = true;
                magicSwallowBase.text_currentProperty.visible = true;
                magicSwallowBase.text_nextProperty.visible = true;
                magicSwallowBase.bgNextExp.visible = true;
                magicSwallowBase.bgCurrentExp.visible = true;
                magicSwallowBase.btn_addOrb.visible = false;
                magicSwallowBase.text_addOrb.visible = false;
                magicSwallowBase.text_Prompt.visible = false;

            } else {
                magicSwallowBase.btn_Select.visible = false;
                magicSwallowBase.text_selectMagic.visible = false;
                magicSwallowBase.SelectIco.visible = false;
                magicSwallowBase.SelectQuality.visible = false;
                magicSwallowBase.btn_Select.touchable = false;
                magicSwallowBase.bg.visible = false;
                magicSwallowBase.text_CurrentLevel.visible = false;
                magicSwallowBase.text_NextLevel.visible = false;
                magicSwallowBase.text_Lv1.visible = false;
                magicSwallowBase.text_Lv2.visible = false;
                magicSwallowBase.text_Lv3.visible = false;
                magicSwallowBase.text_currentExp.visible = false;
                magicSwallowBase.text_attack1.visible = false;
                magicSwallowBase.text_attack2.visible = false;
                magicSwallowBase.text_currentProperty.visible = false;
                magicSwallowBase.text_nextProperty.visible = false;
                magicSwallowBase.btn_addOrb.visible = true;
                magicSwallowBase.text_addOrb.visible = true;
                magicSwallowBase.text_Prompt.visible = true;
                magicSwallowBase.bgNextExp.visible = false;
                magicSwallowBase.bgCurrentExp.visible = false;
            }
        }

        /*=========================================合成============================================================*/
        // 宝珠合成的显示列表
        private function getDataForgeList():void {
            const listLayout:TiledRowsLayout = new TiledRowsLayout();
            listLayout.gap = 50;
            listLayout.paddingTop = 25;
            listLayout.useSquareTiles = false;
            listLayout.useVirtualLayout = true;
            listLayout.verticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.paging = TiledColumnsLayout.PAGING_HORIZONTAL; //自动排列			
            magicCompositeDlgBase.list_magic.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON; //横向滚动 
            magicCompositeDlgBase.list_magic.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF; //禁止垂直滚动
            magicCompositeDlgBase.list_magic.layout = listLayout;
            magicCompositeDlgBase.list_magic.itemRendererFactory = itemRendererFactory;
            function itemRendererFactory():MagicSynthesRender {
                const renderer:MagicSynthesRender = new MagicSynthesRender();
                return renderer;
            }
        }

        private var _factory:MenuFactory;

        // 宝珠合成的等级 菜单按钮 
        private function createMenuMagicButton():void {
            var onFocus:ISignal = new Signal();
            _factory = new MenuFactory();
            var defaultSkin1:Texture = AssetMgr.instance.getTexture("ui_button_orb_1_1");
            var downSkin1:Texture = AssetMgr.instance.getTexture("ui_button_orb_1");

            var defaultSkin2:Texture = AssetMgr.instance.getTexture("ui_button_orb_2_1");
            var downSkin2:Texture = AssetMgr.instance.getTexture("ui_button_orb_2");

            var defaultSkin3:Texture = AssetMgr.instance.getTexture("ui_button_orb_3_1");
            var downSkin3:Texture = AssetMgr.instance.getTexture("ui_button_orb_3");

            var defaultSkin4:Texture = AssetMgr.instance.getTexture("ui_button_orb_4_1");
            var downSkin4:Texture = AssetMgr.instance.getTexture("ui_button_orb_4");

            var name2:String = "TwoLv";
            var name3:String = "ThreeLv";
            var name4:String = "FourLv";
            var name5:String = "FiveLv";

            _factory.onFocus = onFocus;
            _factory.factory([{"defaultSkin": defaultSkin1, "downSkin": downSkin1, "name": name2, x: 61, y: 94, onClick: clickMagicLevelList,
                                  isSelect: true}, {"defaultSkin": defaultSkin2, "downSkin": downSkin2, "name": name3, x: 61,
                                  y: 191, onClick: clickMagicLevelList}, {"defaultSkin": defaultSkin3, "downSkin": downSkin3,
                                  "name": name4, x: 61, y: 288, onClick: clickMagicLevelList}, {"defaultSkin": defaultSkin4,
                                  "downSkin": downSkin4, "name": name5, x: 61, y: 385, onClick: clickMagicLevelList},]);
            addChild(_factory);
        }

        //请求合成宝珠
        private function onReform(e:Event):void {
            var numOrb:int = WidgetData.pileByType(dataGoodsOrb.type - 1);
            if (numOrb < forge.magicNumber) {
                RollTips.add(Langue.getLangue("NOT_ENOUGH")); //材料不足
                return;
            } else {
                var cmd:CForge = new CForge();
                var ids:Vector.<IData> = new Vector.<IData>();
                var data:forgeIds = new forgeIds();
                data.id = dataGoodsOrb.type;
                ids.push(data);
                cmd.ids = ids;
                GameSocket.instance.sendData(cmd);
                ShowLoader.add();
            }
        }

        // 批量合成宝珠
        private function onBatchMagicList(e:Event):void {
            var len:int = magicDataArray.length;
            var idsId:Vector.<IData> = new Vector.<IData>();
            var iconData:IconData = null;
            dataVector = new Vector.<IconData>;
            for (var i:int = 0; i < len; i++) {
                var tmpGoods:Goods = magicDataArray[i] as Goods;
                var dataId:forgeIds = new forgeIds();
                var numberOrbGoods:int = WidgetData.pileByType(tmpGoods.type - 1);
                if (numberOrbGoods >= forge.magicNumber) {
                    dataId.id = tmpGoods.type;
                    idsId.push(dataId);

                    iconData = new IconData();
                    iconData.IconId = tmpGoods.id;
                    iconData.QualityTrue = "ui_gongyong_90wupingkuang" + (tmpGoods.quality - 1);
                    iconData.IconTrue = tmpGoods.picture;
                    iconData.HeroSignTrue = "";
                    iconData.Num = "x " + 1;
                    iconData.IconType = tmpGoods.type;
                    iconData.Name = tmpGoods.name;
                    dataVector.push(iconData);
                }
            }
            var cmd:CForge = new CForge();
            cmd.ids = idsId;
            GameSocket.instance.sendData(cmd);
            ShowLoader.add();
        }

        private function upDataTypeface():void {
            var numOrb:int = WidgetData.pileByType(dataGoodsOrb.type - 1);
            magicCompositeDlgBase.txt_Need.text = numOrb + "/" + forge.magicNumber;

            magicCompositeDlgBase.txt_Need.fontSize = numOrb >= 99 ? 16 : 20;
            magicCompositeDlgBase.txt_Need.color = numOrb >= forge.magicNumber ? 0x66FF00 : 0xFF0000;
        }

        private var dataGoodsOrb:Goods;
        private var forge:ForgeData;

        //选中的宝珠合成
        private function onSelectOrb(e:Event):void {
            dataGoodsOrb = (e.data as Goods);
            var forgrArr:Vector.<*> = ForgeData.hash.values();
            var len:int = forgrArr.length;
            var tmpForge:ForgeData;
            var iconData:IconData = null;
            dataVector = new Vector.<IconData>;
            for (var i:int = 0; i < len; i++) {
                tmpForge = forgrArr[i] as ForgeData;
                // 过滤宝珠
                if (tmpForge.maxSort == 3 && tmpForge.miniSort == dataGoodsOrb.quality - 1) {
                    iconData = new IconData();
                    iconData.IconId = dataGoodsOrb.id;
                    iconData.QualityTrue = "ui_gongyong_90wupingkuang" + (dataGoodsOrb.quality - 1);
                    iconData.IconTrue = dataGoodsOrb.picture;
                    iconData.HeroSignTrue = "";
                    iconData.Num = "x " + 1;
                    iconData.IconType = dataGoodsOrb.type;
                    iconData.Name = dataGoodsOrb.name;
                    dataVector.push(iconData);

                    forge = tmpForge;
                    break;
                }
            }
            upDataTypeface();
            magicCompositeDlgBase.txt_Diamond.text = forge.price + ""; //更新当前合成需要的钻石
            magicCompositeDlgBase.txt_SuccessRate.text = forge.successRate + "%"; //当前合成的宝珠成功率
            // 当前阶段的宝珠
            magicCompositeDlgBase.needNumber.texture = AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (dataGoodsOrb.quality - 2));
            magicCompositeDlgBase.needNumberIco.texture = AssetMgr.instance.getTexture(dataGoodsOrb.picture);
            // 下一个阶段的宝珠
            magicCompositeDlgBase.nextQuality.texture = AssetMgr.instance.getTexture("ui_gongyong_90wupingkuang" + (dataGoodsOrb.quality - 1));
            magicCompositeDlgBase.nextQualityIco.texture = AssetMgr.instance.getTexture(dataGoodsOrb.picture);
        }

        // 点击要获取的等级宝珠
        private function clickMagicLevelList(evt:Event):void {
            var button:Button = ((evt.currentTarget) as Button);
            if (button.name == "TwoLv") {
                getMagicDataList(2);
            } else if (button.name == "ThreeLv") {
                getMagicDataList(3);
            } else if (button.name == "FourLv") {
                getMagicDataList(4);
            } else if (button.name == "FiveLv") {
                getMagicDataList(5);
            }
        }

        private var magicDataArray:Array;

        // 点击获取等级的宝珠列表
        private function getMagicDataList(typelv:int):void {
            var arrOrb:Vector.<*> = Goods.goods.values();
            var length:int = arrOrb.length;
            var j:int = 0;
            magicDataArray = [];
            for (var i:int = 0; i < length; i++) {
                var tmpGoods:Goods = arrOrb[i] as Goods;
                // 2:类别(材料 道具)  4:分类(道具 武器  碎片 强化石...) type:品质
                if (tmpGoods.tab == 2 && tmpGoods.sort == 4 && tmpGoods.quality == typelv) {
                    magicDataArray[j++] = tmpGoods;
                }
            }
            magicDataArray.sortOn("type");
            magicCompositeDlgBase.list_magic.dataProvider = new ListCollection(magicDataArray);
            magicCompositeDlgBase.list_magic.selectedIndex = 0;
        }

        override public function dispose():void {
            magicGetObrDlgBase.cancel.removeEventListener(Event.TRIGGERED, onCancelSelect);
            list_bag.removeEventListener(Event.SCROLL, onMoveChange); //翻页滚动监听
            list_bag.removeEventListener(Event.TRIGGERED, onBuyGrid); //购买格子
            list_bag.removeEventListener(Event.SELECT, onSelected); //选中要出售的宝珠
            list_bag.removeEventListener(EventType.SELECTED_DEFAULT, onSeletedDefault);
            magicGetObrDlgBase.btn_automatic.removeEventListener(Event.TRIGGERED, upAutomaticMagic); // 抽取最高的宝珠
            magicGetObrDlgBase.btn_sell.removeEventListener(Event.TRIGGERED, onSell); //全部出售
            magicCompositeDlgBase.list_magic.removeEventListener(Event.SELECT, onSelectOrb); //选中的宝珠
            magicCompositeDlgBase.btn_batch.removeEventListener(Event.TRIGGERED, onBatchMagicList); // 批量合成
            magicCompositeDlgBase.btn_Reform.removeEventListener(Event.TRIGGERED, onReform); //合成宝珠
            magicSwallowBase.btn_Select.removeEventListener(Event.TRIGGERED, onBtnSelect); //选择要进行吞噬的宝珠材料
            magicSwallowBase.btn_Fix.removeEventListener(Event.TRIGGERED, onBtnFix); //确定吞噬
            magicSwallowBase.cancel.removeEventListener(Event.TRIGGERED, onSwallow); //取消
            isSend = false;
            magicState = null;
            stateVo = null;
            magicGetObrDlgBase = null;
            magicCompositeDlgBase = null;
            magicSwallowBase = null;
            currentpageIndex = 0;
            currentPageImage = null;
            _selectList = null;
            _isSelect = false;
            _totalCoin = 0;
            Locking = false;
            _id = 0;
            _totalExp = 0;
            _tExp = 0;
            _isExpTop = false;
            _factory = null;
            dataGoodsOrb = null;
            forge = null;
            magicDataArray = null;

            super.dispose();
        }

        override public function get height():Number {
            return 630 * (Constants.isScaleWidth ? Constants.scale_x : Constants.scale);
        }
    }
}
