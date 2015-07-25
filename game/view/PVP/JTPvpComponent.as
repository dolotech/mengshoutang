package game.view.PVP
{
    import com.components.TabButton;
    import com.components.TabMenu;
    import com.dialog.DialogMgr;
    import com.scene.SceneMgr;

    import feathers.core.PopUpManager;

    import game.common.JTFormulaUtil;
    import game.common.JTGlobalDef;
    import game.common.JTGlobalFunction;
    import game.common.JTLogger;
    import game.common.JTScrollerMenu;
    import game.common.JTSession;
    import game.data.ConfigData;
    import game.data.Convert;
    import game.data.Goods;
    import game.data.JTPvpNewRuleData;
    import game.data.Val;
    import game.data.WidgetData;
    import game.dialog.ShowLoader;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.manager.HeroDataMgr;
    import game.managers.JTFunctionManager;
    import game.managers.JTPvpInfoManager;
    import game.managers.JTSingleManager;
    import game.net.GameSocket;
    import game.net.data.IData;
    import game.net.data.c.CColiseumRankInfo;
    import game.net.data.c.CColiseumReport;
    import game.net.data.s.SColiseumChance;
    import game.net.data.s.SColiseumRivalFightInfo;
    import game.net.data.s.SColiseumRivalHero;
    import game.net.data.s.SColiseumSend;
    import game.net.data.vo.ColiseumRankInfo;
    import game.net.data.vo.ColiseumReportList;
    import game.scene.arenaWorld.ArenaBattleLoader;
    import game.view.PVP.ui.JTUIPlayerRanksBackground;
    import game.view.arena.ConvertPropsDlg;
    import game.view.city.CityFace;
    import game.view.dispark.DisparkControl;
    import game.view.dispark.data.ConfigDisparkStep;
    import game.view.rank.JTHerosHallComponent;
    import game.view.viewGuide.ViewGuideManager;
    import game.view.viewGuide.interfaces.IViewGuideView;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;

    import starling.display.Image;
    import starling.events.Event;

    import treefortress.spriter.SpriterClip;

    public class JTPvpComponent extends JTUIPlayerRanksBackground implements IViewGuideView
    {
        public static var instance:JTPvpComponent=null;
        private var scrollerBar:JTScrollerMenu=null;

        private const PVP_RANKS:String="pvp_ranks";
        private const PVP_EQUIPS:String="pvp_equips";
        private const PVP_REVENGES:String="pvp_equips";
        private const PVP_PROGRESS_COUNT:int=5; //PVP进度条节数
        private var type:String=null;
        public static var isRequest:Boolean=false;

        public function JTPvpComponent()
        {
            super();
            initialize();
        }

        private function initialize():void
        {
            onClose=new Signal(JTPvpComponent);
            this.menu_bars.selectedIndex=0;
            this.btn_close.addEventListener(Event.TRIGGERED, onCloseHandler);
            this.menu_bars.addEventListener(Event.CHANGE, onMenuChangeHandler);
            this.tabbtn_regulation0.addEventListener(Event.TRIGGERED, onMenuChangeHandler);
            JTFunctionManager.registerFunction(JTGlobalDef.PVP_BUY_NUM, onBuyPVPNumResponse);
            JTFunctionManager.registerFunction(JTGlobalDef.PVP_PK_FIGHT, onPvpFightResponse);
            JTFunctionManager.registerFunction(JTGlobalDef.PVP_RANKS_LIST, onPvpRanksRsponse);
            JTFunctionManager.registerFunction(JTGlobalDef.PVP_MYSELF_INFO, refreshMyselfInfo);
            JTFunctionManager.registerFunction(JTGlobalDef.PVP_LOOK_HEROS, onLookHerosResponse);
            JTFunctionManager.registerFunction(JTGlobalDef.PVP_REVENGES_LIST, onRevengesResponse);
            JTFunctionManager.registerFunction(JTGlobalDef.PVP_REFRHES_HONOR, onRefreshHornorResponse);
            JTFunctionManager.registerFunction(JTGlobalDef.PVP_REFRESH_INFOS, onRefreshPVPInfosResponse);
            onChangePVPHandler();
        }

        /**
         * 刷新荣誉值
         * @param hornor
         *
         */
        private function onRefreshHornorResponse(hornor:int):void
        {
            var pvpInfoManager:JTPvpInfoManager=JTSingleManager.instance.pvpInfoManager;
            pvpInfoManager.hornor=hornor;
            this.txt_money.text=pvpInfoManager.hornor.toString();
        }

        /**
         * 菜单事件
         * @param e
         *
         */
        private function onMenuChangeHandler(e:Event):void
        {
            if (e.target == tabbtn_regulation0)
            {
                onShowPvpReulation();
                return;
            }
            var tabMenu:TabMenu=e.target as TabMenu;
            var tabButton:TabButton=tabMenu.selectedButton as TabButton;
            if (!tabButton)
            {
                return;
            }
            var tabButtonName:String=tabButton.name;
            /*	if (isRequest)
            {
            this.isChange = true;
            }*/
            switch (tabButtonName)
            {
                case "btn_pvp":
                {
                    onPvpRanksRsponse(null);
                    break;
                }
                case "btn_buy":
                {
                    createPvpEquipments();
                    onChangeBuyHandler();
                    break;
                }
                case "btn_fight":
                {
                    onChangeFightHandler();
                    break;
                }
                case "btn_regulation":
                {
                    tabButton.selected=false;
                    tabButton.selected_click=true;
                    onShowPvpReulation();
                    break;
                }
                default:
                    break;
            }
        }

        /**
         * 刷新PVP信息
         * @param result 1 为PVP 2为复仇
         *
         */
        private function onRefreshPVPInfosResponse(result:Object):void
        {
            var coliseumSend:SColiseumSend=result as SColiseumSend;
            if (coliseumSend.type == 1)
            {
                var coliRanksPackage:CColiseumRankInfo=new CColiseumRankInfo();
                GameSocket.instance.sendData(coliRanksPackage);
            }
            else if (coliseumSend.type == 2)
            {
                var coliseReport:CColiseumReport=new CColiseumReport();
                GameSocket.instance.sendData(coliseReport);
            }
        }

        /**
         * 进入战斗
         * @param result
         *
         */
        private function onPvpFightResponse(result:Object):void
        {
            ShowLoader.remove();
            var pvpInfoManager:JTPvpInfoManager=JTSingleManager.instance.pvpInfoManager;
            var fightInfo:SColiseumRivalFightInfo=result as SColiseumRivalFightInfo;
            pvpInfoManager.enemy_info=pvpInfoManager.getRankInfoById(fightInfo.id);
            ArenaBattleLoader.showBattle(0, fightInfo.id, fightInfo.messege);
        }

        /**
         * 查看英雄
         * @param result
         *
         */
        private function onLookHerosResponse(result:Object):void
        {
            var pvpHeros:SColiseumRivalHero=result as SColiseumRivalHero;
            JTHerosHallComponent.show(this, JTGlobalFunction.converHeros(pvpHeros.heroes));
            JTHerosHallComponent.showTitle(JTPvpInfoManager.hero_title);
        }

        /**
         * 刷新购买PVP战斗次数显示
         * @param reulst
         *
         */
        private function onBuyPVPNumResponse(reulst:SColiseumChance):void
        {
            var pvpInfoManager:JTPvpInfoManager=JTSingleManager.instance.pvpInfoManager;
            //pvpInfoManager.pvpCount = reulst.num;
            pvpInfoManager.pvpCount=reulst.wars;
            pvpInfoManager.buyCount=reulst.num;
            this.txt_count.text=pvpInfoManager.pvpCount.toString();
        }

        private function onChangeBuyHandler():void
        {
            var pvpEquipments:Array=JTSingleManager.instance.pvpInfoManager.pvpEquipemts;
            refreshScrollMenus(JTPvpEquipItemRender, pvpEquipments);
        }

        /**
         *
         * 显示规则面板
         */
        private function onShowPvpReulation():void
        {
            JTPvpRegulationComponent.open();
        }

        /**
         *请求PVP个人
         *
         */
        private function onChangePVPHandler():void
        {
            var pvpInfoManager:JTPvpInfoManager=JTSingleManager.instance.pvpInfoManager;
            if (pvpInfoManager.rankList.length == 0)
            {
                var coliRanksPackage:CColiseumRankInfo=new CColiseumRankInfo();
                GameSocket.instance.sendData(coliRanksPackage);
                ShowLoader.add();
            }
            else
            {
                onPvpRanksRsponse(null);
                refreshMyselfInfo();
            }
        }

        private function onChangeFightHandler():void
        {
            /*var pvpInfoManager:JTPvpInfoManager = JTSingleManager.instance.pvpInfoManager;
            if (!isRequest)
            {*/
            var sendFightPackage:CColiseumReport=new CColiseumReport();
            GameSocket.instance.sendData(sendFightPackage);
            isRequest=true;
            ShowLoader.add();
        /*}
        else
        {
        onRevengesResponse(null);
        }*/
        }

        private function onRevengesResponse(reuslt:Object):void
        {
            ShowLoader.remove();
            var pvpInfoManager:JTPvpInfoManager=JTSingleManager.instance.pvpInfoManager;
            refreshScrollMenus(JTPvpReportItemRender, pvpInfoManager.fightInfos);
        }

        private function onPvpRanksRsponse(result:Object):void
        {
            ShowLoader.remove();
            var pvpInfoManager:JTPvpInfoManager=JTSingleManager.instance.pvpInfoManager;
            var rankInfos:Vector.<IData>=pvpInfoManager.rankList;
            refreshMyselfInfo();

            if (change_type == Val.DROP_PVP_GET)
            {
                change_type="";
                menu_bars.selectedIndex=2;
                return;
            }
            refreshScrollMenus(JTPVPRankItemRender, rankInfos);
            var index:int=0;
            var rankInfo:ColiseumRankInfo=null;
            if (JTPvpInfoManager.pvpRid != 0)
            {
                rankInfo=pvpInfoManager.getRankInfo(JTPvpInfoManager.pvpRid);
                if (!rankInfo)
                {
                    return;
                }
                scrollerBar.verticalScrollPosition=JTScrollerMenu.scrollerV;
            }
            else
            {
                rankInfo=pvpInfoManager.myselfInfo;
                index=rankInfos.indexOf(rankInfo);
                if (index == -1)
                {
                    JTLogger.error("[JTPvpComponent.onPvpRanksResponse] Cant Find The RankInfo!");
                }
                scrollerBar.scrollToDisplayIndex(index);
            }
        }
        /**
         *刷新个人信息
         */
        private var lv_effect:SpriterClip=null;
        private var animation:SpriterClip=null;

        private function refreshMyselfInfo():void
        {
            var pvpInfoManager:JTPvpInfoManager=JTSingleManager.instance.pvpInfoManager;
            this.txt_name.text=GameMgr.instance.arenaname;
            this.txt_count.text=pvpInfoManager.pvpCount.toString();
            this.txt_rank.text=pvpInfoManager.rank.toString();
            var pvpTemplatews:JTPvpNewRuleData=JTPvpNewRuleData.hash.getValue(pvpInfoManager.pvpLv) as JTPvpNewRuleData;
            this.txt_lvl_title.text=pvpTemplatews.title1;
            this.img_img_lvl.texture=AssetMgr.instance.getTexture("ui_iocn_qualifying" + pvpInfoManager.pvpLv);
            pvpInfoManager.timer.cdTime(txt_time);
            pvpInfoManager.timer.startTime();

            var mc_quality:Image=this["img_mc_quality_" + pvpInfoManager.pvpLv] as Image;
            if (!lv_effect)
            {
                lv_effect=AnimationCreator.instance.create("effect_jingjichangtishi", AssetMgr.instance);
                lv_effect.play("effect_jingjichangtishi");
                lv_effect.animation.looping=true;
                lv_effect.name="giftAminition";
                this.addChild(lv_effect);
            }
            lv_effect.x=mc_quality.x - mc_quality.width / 2;
            lv_effect.y=mc_quality.y - (lv_effect.height - mc_quality.height) / 2;
            this.setChildIndex(lv_effect, this.getChildIndex(mc_quality) - 1);
            if (!animation)
            {
                animation=AnimationCreator.instance.create("effect_050", AssetMgr.instance);
                this.addChild(animation);
            }

            var pvpLevl:int=pvpInfoManager.pvpLv;
            var pvpTemplate:JTPvpNewRuleData=JTPvpNewRuleData.getPvpTemplate(pvpLevl);
            var upLines:Array=pvpTemplate.total_num.split("-");
//			if (pvpInfoManager.rank < upLines[1] && pvpInfoManager.rank != 1)
//			{
//				this.animation.visible = true;
//				animation.play("effect_050");
//				animation.animation.looping = true;
//				animation.x = mc_quality.x + mc_quality.width - 10;
//				animation.y = mc_quality.y + (mc_quality.height - animation.height) / 2;
//			}
//			else
            {
                this.animation.visible=false;
            }


            this.scale_mc_progress.scaleX=(JTGlobalDef.PVP_MAX_LV - pvpInfoManager.pvpLv) / PVP_PROGRESS_COUNT;
            //	this.btn_head.upState = AssetMgr.instance.getTexture("ui_pvp_renwutouxiang" + GameMgr.instance.picture);
            var img_head:Image=this.btn_head.getChildByName("head") as Image;
            if (!img_head)
            {
                img_head=new Image(AssetMgr.instance.getTexture("ui_pvp_renwutouxiang" + GameMgr.instance.picture));
                img_head.name="head";
                this.btn_head.addChildAt(img_head, this.btn_head.numChildren - 2);
            }
            else
            {
                img_head.texture=AssetMgr.instance.getTexture("ui_pvp_renwutouxiang" + GameMgr.instance.picture);
            }
            this.textField.text="0";
            this.btn_head.touchable=false;
            this.txt_pvp_count.text="/" + ConfigData.instance.arenaBattleMax.toString();
            this.txt_horn.text=JTFormulaUtil.getRankHonor(pvpInfoManager.rank).toString();
            this.txt_fight.text=HeroDataMgr.instance.getPower().toString();
            this.txt_money.text=pvpInfoManager.hornor.toString();
            //StringUtil.changePriceText(pvpInfoManager.myselfInfo.newexp, txt_money, null);
            createPvpEquipments();
        }

        /**
         *创建PVP装备数据列表
         *
         */
        private function createPvpEquipments():void
        {
            var pvpInfoManager:JTPvpInfoManager=JTSingleManager.instance.pvpInfoManager;
            var pvpEquipments:Array=pvpInfoManager.pvpEquipemts;
            pvpEquipments.length=0;
            var List1:Array=[];
            var List2:Array=[];
            var List4:Array=[];
            var List3:Array=[];
            var List5:Array=[];
            var convers:Vector.<*>=Convert.hash.values();
            var widget:WidgetData=null;
            var pvpLv:int=pvpInfoManager.pvpLv;
            var i:int=0;
            var l:int=convers.length;
            for (i=0; i < l; i++)
            {
                var converTemplate:Convert=convers[i] as Convert;
                if (converTemplate.newlev < pvpLv)
                {
                    continue;
                }
                var good:Goods=Goods.goods.getValue(converTemplate.id);
                widget=new WidgetData(good);
                var equipInfo:Object={};
                equipInfo.widget=widget;
                equipInfo.price=converTemplate.price;
                equipInfo.level=converTemplate.newlev;
                if (widget.tab == 5)
                {
                    if (widget.seat == 1)
                    {
                        List1.push(equipInfo);
                    }
                    else if (widget.seat == 4)
                    {
                        List2.push(equipInfo);
                    }
                    else if (widget.seat == 2)
                    {
                        List3.push(equipInfo);
                    }
                    else if (widget.seat == 3)
                    {
                        List4.push(equipInfo);
                    }
                }
                else if (widget.tab == 1 || widget.tab == 2)
                {
                    List5.push(equipInfo);
                }
            }
            pvpEquipments=pvpEquipments.concat(List3);
            pvpEquipments=pvpEquipments.concat(List4)
            pvpEquipments=pvpEquipments.concat(List1);
            pvpEquipments=pvpEquipments.concat(List2);
            pvpEquipments=pvpEquipments.concat(List5);
            pvpEquipments.sortOn("level", Array.NUMERIC);
            pvpInfoManager.pvpEquipemts=pvpEquipments;
        }

        private function sortConvers(a:Convert, b:Convert):int
        {
            var result:int=0;
            if (a.newlev > b.newlev)
            {
                result=-1;
            }
            else if (a.newlev < b.newlev)
            {
                result=1;
            }
            return result;
        }

        private function refreshScrollMenus(cls:Class, dataList:Object):void
        {
            if (scrollerBar)
            {
                this.scrollerBar.removeFromParent();
                this.scrollerBar.dispose();
                this.scrollerBar=null;
            }
            scrollerBar=JTScrollerMenu.createScrollerMenu(cls, onMouseClickHandler, dataList);
            scrollerBar.setRectange(this.img_mc_ranks);
            if (cls is JTPvpEquipItemRender)
            {
                scrollerBar.layout=scrollerBar.getAutoTiledColumnsLayout();
            }
            else
            {
                scrollerBar.layout=scrollerBar.getDefaultLayout();
            }
            if (cls == JTPVPRankItemRender)
            {
                scrollerBar.registerScroller();
            }
            this.addChild(scrollerBar);
        }

        private function onMouseClickHandler(itemInfo:Object):void
        {
            if (itemInfo is ColiseumRankInfo)
            {
                /*var rankInfo:ColiseumRankInfo = itemInfo as ColiseumRankInfo;
                if (!itemInfo)
                {
                return;
                }
                var lines:Array = (rankInfo.name as String).split(".");
                if (rankInfo.name == "^." + rankInfo.rid + ".$")
                {
                RollTips.showTips("robot");
                return;
                }
                var sendlookHeros:CColiseumRivalHero = new CColiseumRivalHero();
                sendlookHeros.id = rankInfo.rid;
                JTPvpInfoManager.hero_title = rankInfo.name;
                GameSocket.instance.sendData(sendlookHeros);*/
            }
            else if (itemInfo is ColiseumReportList)
            {
                /*var rankReport:ColiseumReportList = itemInfo as ColiseumReportList;
                var sendReportPackage:CColiseumRivalHero = new CColiseumRivalHero();
                sendlookHeros.id = rankReport.id;
                GameSocket.instance.sendData(sendReportPackage);*/
            }
            else if (itemInfo is Object)
            {
                if (itemInfo["widget"] && itemInfo["widget"] is WidgetData)
                {
					DialogMgr.instance.open(ConvertPropsDlg, {goods:itemInfo.widget,price:itemInfo.price});
                }
            }
        }

        private function onCloseHandler(e:Event):void
        {
            //智能判断是否删除功能开放提示图标（斗角场）
            DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep7);
            close();
        }

        public function getViewGuideDisplay(name:String):*
        {
            return tabbtn_regulation0;
        }

        public function executeViewGuideFun(name:String):void
        {

        }

        override public function dispose():void
        {
            super.dispose();
            if (scrollerBar)
            {
                scrollerBar.removeFromParent();
                scrollerBar.dispose();
                scrollerBar=null;
            }
            JTFunctionManager.removeFunction(JTGlobalDef.PVP_BUY_NUM, onBuyPVPNumResponse);
            JTFunctionManager.removeFunction(JTGlobalDef.PVP_PK_FIGHT, onPvpFightResponse);
            JTFunctionManager.removeFunction(JTGlobalDef.PVP_RANKS_LIST, onPvpRanksRsponse);
            JTFunctionManager.removeFunction(JTGlobalDef.PVP_MYSELF_INFO, refreshMyselfInfo);
            JTFunctionManager.removeFunction(JTGlobalDef.PVP_LOOK_HEROS, onLookHerosResponse);
            JTFunctionManager.removeFunction(JTGlobalDef.PVP_REVENGES_LIST, onRevengesResponse);
            JTFunctionManager.removeFunction(JTGlobalDef.PVP_REFRHES_HONOR, onRefreshHornorResponse);
            JTFunctionManager.removeFunction(JTGlobalDef.PVP_REFRESH_INFOS, onRefreshPVPInfosResponse);
            instance=null;
        }

        public static var isPvpSuccess:Boolean=false;
        private static var change_type:String;

        public static function open(type:String=Val.DROP_PVP):void
        {
            if (!instance)
            {
				change_type=type;
                instance=PopUpManager.addPopUp(new JTPvpComponent(), false) as JTPvpComponent;
                //功能引导
                ViewGuideManager.excuteGuide(999999);
            }
        }

        public var onClose:ISignal;

        public static function close():void
        {
            if (instance)
            {
                instance.onClose.dispatch(instance);
                PopUpManager.removePopUp(instance);
                instance.dispose();
                instance=null;
            }
        }

        /**
         *
         * @param isSuccess 是否胜利
         *
         */
        public static function backPvpPanel(isSuccess:Boolean=false):void
        {
            var pvpInfoManager:JTPvpInfoManager=JTSingleManager.instance.pvpInfoManager;
            if (isSuccess)
            {
                JTPvpInfoManager.pvpRid=0;
                JTSingleManager.instance.pvpInfoManager.updateRanks();
                JTSingleManager.instance.pvpInfoManager.rankList=new Vector.<IData>();
            }
            else
            {
                if (JTPvpInfoManager.type == JTPvpInfoManager.TYPE_FIGHT && JTSession.isPvped)
                {
                    JTSession.isPvped=false;
                    JTPvpInfoManager.pvpRid=0;
                    JTSingleManager.instance.pvpInfoManager.updateRanks();
                    JTSingleManager.instance.pvpInfoManager.rankList=new Vector.<IData>();
                }
            }
            DialogMgr.instance.closeAllDialog();
            SceneMgr.instance.changeScene(CityFace);
            JTPvpComponent.open();
            JTSession.isPvp=false;
        }
    }
}
