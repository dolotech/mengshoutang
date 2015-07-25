package game.view.blacksmith {
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.utils.Constants;
    import com.view.base.event.EventType;

    import feathers.controls.Scroller;
    import feathers.data.ListCollection;
    import feathers.layout.TiledRowsLayout;

    import game.data.Goods;
    import game.data.HeroData;
    import game.data.WidgetData;
    import game.dialog.DialogBackground;
    import game.manager.GameMgr;
    import game.net.message.EquipMessage;
    import game.view.blacksmith.render.NewEquipRender;
    import game.view.blacksmith.render.NewHeroBodyEquipRender;
    import game.view.blacksmith.render.NewHeroList;
    import game.view.blacksmith.view.BodyEquipView;
    import game.view.blacksmith.view.EquipGemView;
    import game.view.blacksmith.view.EquipViewBase;
    import game.view.blacksmith.view.FusionView;
    import game.view.blacksmith.view.StrengthenView;
    import game.view.dispark.DisparkControl;
    import game.view.dispark.data.ConfigDisparkStep;
    import game.view.goodsGuide.EquipInfoDlg;
    import game.view.viewBase.NewBlacksmithDlgBase;

    import starling.display.Quad;
    import starling.events.Event;

    /**
     * 新的铁匠铺
     * @author hyy
     *
     */
    public class BlacksmithDlg extends NewBlacksmithDlgBase {
        public static const EQUIP:int = 0;
        public static const FORGE:int = 1;
        public static const STRENGTHEN:int = 2;
        public static const GEM:int = 3;

        public static var curr_hero:HeroData;
        private var list_hero:NewHeroList;
        private var curr_view:EquipViewBase;
        private var view_replceEquip:BodyEquipView;
        private var view_fusion:FusionView;
        private var view_strengthen:StrengthenView;
        private var view_gem:EquipGemView;
        private var selected_equip_index:int = -1;
        private var currLable:int = 0;
        /**
         * 当前选中人物身上装备
         */
        private var curr_body_equip:WidgetData;
        private var curr_bag_equip:Goods;

        public function BlacksmithDlg() {
            super();
        }

        override protected function init():void {
            isVisible = true;
            _closeButton = btn_close;
            background = new DialogBackground();

            text_diamond.text = GameMgr.instance.diamond + ""; //钻石
            text_coin.text = GameMgr.instance.coin + ""; //金币

            //拥有的英雄列表
            list_hero = new NewHeroList();
            list_hero.setSize(850, 110);
            list_hero.move(35, 520);
            addQuiackChild(list_hero);

            //是否有武器装备栏
            const listLayout:TiledRowsLayout = new TiledRowsLayout();
            listLayout.gap = 5;
            listLayout.useSquareTiles = false;
            listLayout.useVirtualLayout = true;
            listLayout.paddingTop = 3;
            listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
            list_equip.layout = listLayout;
            list_equip.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
            list_equip.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
            list_equip.itemRendererFactory = tileListItemRendererFactory;

            function tileListItemRendererFactory():NewHeroBodyEquipRender {
                var itemRender:NewHeroBodyEquipRender = new NewHeroBodyEquipRender();
                itemRender.setSize(100, 100);
                return itemRender;
            }

            //物品列表
            const layout:TiledRowsLayout = new TiledRowsLayout();
            layout.paddingTop = 5;
            layout.useSquareTiles = false;
            layout.useVirtualLayout = true;
            layout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            layout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
            list_bag.layout = layout;
            list_bag.itemRendererFactory = listItemRendererFactory;

            function listItemRendererFactory():NewEquipRender {
                var itemRender:NewEquipRender = new NewEquipRender(true);
                itemRender.setSize(100, 125);
                return itemRender;
            }
            GameMgr.instance.onUpateMoney.add(updateMoney);
        }

        private function updateMoney():void {
            text_diamond.text = GameMgr.instance.diamond + ""; //钻石
            text_coin.text = GameMgr.instance.coin + ""; //金币
        }

        override protected function show():void {
            setToCenter();
            updateCostMoney(0, 0);

            if (_parameter is Array) {
                //标签类型|英雄|装备
                var arr:Array = _parameter as Array;

                if (arr.length > 2)
                    selected_equip_index = arr[2];

                if (arr.length > 0)
                    tabMenu_hero.selectedIndex = arr[0];

                if (arr.length > 1)
                    list_hero.selectedIndex = int(arr[1]) < 0 ? 0 : arr[1];

                _parameter = null;
            } else {
                tabMenu_hero.selectedIndex = 0;
                list_hero.selectedIndex = 0;
            }
            currLable = tabMenu_hero.selectedIndex;

            //功能开放引导
            DisparkControl.dicDisplay["equintment_table_0"] = tab_1;
            DisparkControl.dicDisplay["equintment_table_1"] = tab_2;
            DisparkControl.dicDisplay["equintment_table_2"] = tab_3;
            DisparkControl.dicDisplay["equintment_table_3"] = tab_4;

            //智能判断是否添加功能开放提示图标（强化）
            DisparkControl.instance.addDisparkHandler(ConfigDisparkStep.DisparkStep1);
            //智能判断是否添加功能开放提示图标（合成）
            DisparkControl.instance.addDisparkHandler(ConfigDisparkStep.DisparkStep15);
            //智能判断是否添加功能开放提示图标（镶嵌）
            DisparkControl.instance.addDisparkHandler(ConfigDisparkStep.DisparkStep17);
        }

        override protected function addListenerHandler():void {
            super.addListenerHandler();
            //英雄选择
            this.addContextListener(EventType.UPDATE_HERO_SELECTED, onHeroSelected);
            //玩家替换装备
            this.addContextListener(EventType.NOTIFY_HERO_EQUIP, updateAtuoEquipHander);
            //玩家身上装备选中
            this.addContextListener(EventType.UPDATE_BODYEQUIP_SELECTED, onHeroEquipClick);
            //卸载宝珠
            this.addContextListener(EventType.UPDATE_EQUIP_GEM, onUnGemNotify);
            //背包选中
            this.addContextListener(EventType.UPDATE_BAGEQUIP_SELECTED, onBagClick);
            //合成操作
            this.addContextListener(EventType.NOTIFY_FORGE_EQUIP, onReturnForgeEquip);
            //强化装备
            this.addContextListener(EventType.NOTIFY_STRENGTHEN, onStrengthenNotify);
            //卸载强化石
            this.addContextListener(EventType.UN_STONE_SELECTED, onUnStrengthenNotify);
            //更新金币
            this.addContextListener(EventType.UPDATE_MONEY, onUpdateMoney);

            this.addViewListener(tabMenu_hero, Event.CHANGE, onTabMenuSelected);
            this.addViewListener(btn_click, Event.TRIGGERED, onBtnClickHandler);
            this.addViewListener(list_bag, Event.SCROLL, listBagScroll);
        }

        private var verticalScrollPosition:Number = 0;

        /**
         * 记录背包滚动位置
         *
         */
        private function listBagScroll():void {
            verticalScrollPosition = list_bag.verticalScrollPosition;
        }

        public function onUnStrengthenNotify(evt:Event, goods:Goods):void {
            list_bag.dataProvider.updateItem(goods);
        }

        /**
         * 强化装备
         * @param evt
         *
         */
        private function onStrengthenNotify(evt:Event, returnObj:Object):void {
            var widget:WidgetData = WidgetData.hash.getValue(returnObj.id);

            if (widget)
                list_equip.dataProvider.updateItem(widget);
        }

        /**
         *
         * @param evt
         * @param stone
         *
         */
        private function onUnGemNotify(evt:Event):void {
            onHeroEquipClick(null, curr_body_equip);
        }

        /**
         * 合成操作
         * @param evt
         * @param isSuccess
         *
         */
        private function onReturnForgeEquip(evt:Event, isSuccess:Boolean):void {
            if (curr_bag_equip == null) {
                warn("当前合成装备为空");
                return;
            }

            list_bag.dataViewPort.dataProvider_refreshItemHandler();
//            list_bag.dataProvider.updateItem(curr_bag_equip);
            view_fusion && view_fusion.onReturnForgeEquip(isSuccess);
        }

        /**
         * 标签选择
         * 装备/合成/强化/镶嵌
         */
        private function onTabMenuSelected():void {
            curr_bag_equip = null;
            curr_view && curr_view.removeFromParent();

            switch (tabMenu_hero.selectedIndex) {
                case 0:
                    if (view_replceEquip == null)
                        view_replceEquip = new BodyEquipView();
                    curr_view = view_replceEquip;
                    btn_click.text = getLangue("noreplceNull");
                    break;
                case 1:
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep15)) { //装备合成能是否开启
                        tabMenu_hero.selectedIndex = currLable;
                        return;
                    }
                    //智能判断是否删除功能开放提示图标（合成）
                    DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep15);

                    if (view_fusion == null)
                        view_fusion = new FusionView();
                    curr_view = view_fusion;
                    break;
                case 2:
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep1)) { //装备强化能是否开启
                        tabMenu_hero.selectedIndex = currLable;
                        return;
                    }
                    //智能判断是否删除功能开放提示图标（强化）
                    DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep1);

                    if (view_strengthen == null)
                        view_strengthen = new StrengthenView();
                    curr_view = view_strengthen;
                    break;
                case 3:
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep17)) { //装备镶嵌能是否开启
                        tabMenu_hero.selectedIndex = currLable;
                        return;
                    }
                    //智能判断是否删除功能开放提示图标（合成）
                    DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep17);

                    if (view_gem == null)
                        view_gem = new EquipGemView();
                    curr_view = view_gem;
                    break;
                default:
                    break;
            }
            currLable = tabMenu_hero.selectedIndex;

            btn_click.visible = tabMenu_hero.selectedIndex != 3;
            //按钮名字
            btn_click.text = Langue.getLans("blacksmith")[tabMenu_hero.selectedIndex];
            //设置界面金币处理函数
            curr_view.m_updateCostMoney = updateCostMoney;
            //清理滚动位置
            verticalScrollPosition = 0;
            //清除消耗金币
            updateCostMoney(0, 0);
            addChild(curr_view);
            onHeroEquipClick(null, curr_body_equip);
        }

        /**
         * 按钮点击
         *
         */
        private function onBtnClickHandler():void {
            switch (tabMenu_hero.selectedIndex) {
                //装备
                case 0:
                    //卸下装备
                    if (btn_click.text == getLangue("noreplceNull")) {
                        //身上装备
                        if (curr_body_equip == null || curr_body_equip.type == 0) {
                            addTips("SELECED_EQUIP_TIPS");
                            return;
                        }
                        EquipMessage.sendReplaceEquip(curr_body_equip.seat, curr_hero, 0);
                        return;
                    }
                    //替换装备
                    if (curr_bag_equip == null) {
                        addTips("SELECED_EQUIP");
                        return;
                    }
                    //穿戴等级不够
                    if (curr_hero.level < curr_bag_equip.limitLevel) {
                        addTips(getLangue("needLevel") + curr_bag_equip.limitLevel);
                        return;
                    }
                    EquipMessage.sendReplaceEquip(curr_body_equip.seat, curr_hero, curr_bag_equip.id);
                    break;
                //合成
                case 1:
                    view_fusion.sendForgeGoods();
                    break;
                //强化
                case 2:
                    view_strengthen.sendStrengthenEquip();
                    break;
                default:
                    break;
            }
        }

        /**
         * 英雄装备点击
         *
         */
        private function onHeroEquipClick(evt:Event, widgetData:WidgetData):void {
            curr_body_equip = widgetData;

            if (widgetData == null)
                return;

            if (tabMenu_hero.selectedIndex == 0)
                btn_click.text = getLangue("noreplceNull");
            var tmp_list:Array = curr_view.getEquipList(curr_body_equip);
            list_bag.dataProvider = new ListCollection(tmp_list);
            list_bag.selectedIndex = -1;
            list_bag.verticalScrollPosition = verticalScrollPosition;
            selected_equip_index = list_equip.selectedIndex;
            curr_bag_equip = null;
            curr_view.curr_widget = widgetData;
        }

        /**
         * 背包装备选中
         * @param evt
         * @param goods
         *
         */
        private function onBagClick(evt:Event, goods:Goods):void {
            if (goods.isLookInfo) {
                var tmp_goods:Goods = goods.clone() as Goods;
                tmp_goods.Price = 0;
                DialogMgr.instance.open(EquipInfoDlg, tmp_goods);
                return;
            }
            this.curr_bag_equip = goods;

            if (goods == null)
                return;
            curr_view.data = goods;

            if (curr_view == view_replceEquip)
                btn_click.text = Langue.getLans("blacksmith")[0];
            else if (curr_view == view_strengthen || curr_view == view_gem)
                list_bag.dataProvider.updateItem(goods);
        }

        /**
         * 英雄列表选择
         * @param view
         * @param heroData
         *
         */
        private function onHeroSelected(view:Event, heroData:HeroData):void {
            curr_hero = heroData;
            updateHeroEquip(heroData);
            curr_view.resetView();
        }

        /**
         * 更新金币
         *
         */
        public function onUpdateMoney():void {
            updateCostMoney(int(txt_money.text), int(txt_diamond.text));
        }

        public function updateCostMoney(money:int, diamond:int):void {
            txt_money.text = money + "";
            txt_diamond.text = diamond + "";
            txt_money.color = GameMgr.instance.coin > money ? 0xffffff : 0xff0000;
            txt_diamond.color = GameMgr.instance.diamond > diamond ? 0xffffff : 0xff0000;
            txt_money.visible = money > 0;
            tag_money.visible = txt_money.visible;
            txt_diamond.visible = diamond > 0;
            tag_diamond.visible = txt_diamond.visible;
        }

        /**
         * 更新玩家装备
         * @param heroData
         *
         */
        private function updateHeroEquip(heroData:HeroData):void {
            var tmp_list:Array = heroData.getHeroCurrEquipList();
            tmp_list.length = 4;
            list_equip.dataProvider = new ListCollection(tmp_list);
            list_equip.selectedIndex = selected_equip_index == -1 ? 0 : selected_equip_index;
        }

        /**
         * 玩家替换装备
         * @param evt
         * @param heroData
         *
         */
        private function updateAtuoEquipHander(evt:Event, heroData:HeroData):void {
            updateHeroEquip(heroData);
        }

        override public function close():void {
            super.close();
        }


        override public function dispose():void {
            NewHeroBodyEquipRender.selectedAnimation && NewHeroBodyEquipRender.selectedAnimation.removeFromParent(true);
            NewHeroBodyEquipRender.selectedAnimation = null;
            dispatch(EventType.UPDATE_HERO_INDEX, list_hero.list_hero.selectedIndex);
            view_replceEquip && view_replceEquip.dispose();
            view_strengthen && view_strengthen.dispose();
            view_fusion && view_fusion.dispose();
            view_gem && view_gem.dispose();
            super.dispose();
            curr_hero = null;
            curr_view = null;
            view_replceEquip = null;
            view_fusion = null;
            view_strengthen = null;
            view_gem = null;
            curr_body_equip = null;
            curr_bag_equip = null;
        }

        /**
         * 新手引导专用函数
         * @param id
         * type 1自动布阵
         * type 2开始战斗
         */
        override public function executeGuideFun(name:String):void {
            if (name == "英雄之家") {
                this.close();
            }
        }

        /**
         * 新手引导
         * @param name
         * @return
         *
         */
        override public function getGuideDisplay(name:String):* {
            if (name == "强化标签") {
                addGuideEvent(tabMenu_hero, Event.CHANGE);
                return tab_3;
            } else if (name.indexOf("强化石") >= 0 || name.indexOf("背包装备") >= 0) {
                //list_hero.selectedIndex = 1;
                var index:int = name.split(",")[1];
                addGuideContextEvent(EventType.UPDATE_BAGEQUIP_SELECTED);
                !list_bag.isCreated && list_bag.validate();
                list_bag.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
                var q:Quad = new Quad(100, 120);
                this.addChild(q);
                q.x = list_bag.x + index * 100;
                q.y = list_bag.y;
                return q;
            } else if (name == "强化按钮" || name == "装备按钮") {
                if (btn_click.text == getLangue("noreplceNull"))
                    return null;
                return btn_click;
            } else if (name == "退出按钮") {
                return btn_close;
            }
            return null;
        }

        override public function executeViewGuideFun(name:String):void {
            if (name == "附魔界面")
                tabMenu_hero.selectedIndex = 3;
        }

        override public function get height():Number {
            return 637 * (Constants.isScaleWidth ? Constants.scale_x : Constants.scale);
        }

        override public function get backParam():Object {
            return [tabMenu_hero.selectedIndex, list_hero.selectedIndex, list_equip.selectedIndex];
        }

    }
}
