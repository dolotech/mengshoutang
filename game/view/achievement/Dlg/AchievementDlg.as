package game.view.achievement.Dlg {
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.utils.Constants;
    import com.utils.StringUtil;

    import feathers.controls.Scroller;

    import game.common.JTGlobalDef;
    import game.dialog.DialogBackground;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.managers.JTFunctionManager;
    import game.view.achievement.Overall;
    import game.view.achievement.Section;
    import game.view.achievement.data.AchievementData;
    import game.view.comm.menu.MenuButton;
    import game.view.comm.menu.MenuFactory;
    import game.view.new2Guide.NewGuide2Manager;
    import game.view.viewBase.AchievementDlgBase;
    import game.view.vip.VipDlg;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;

    import starling.core.Starling;
    import starling.display.DisplayObjectContainer;
    import starling.display.Quad;
    import starling.events.Event;
    import starling.textures.Texture;

    /**
     *
     * 成就弹出窗
     * @author litao
     *
     */
    public class AchievementDlg extends AchievementDlgBase {
        protected var _section:Section;
        private var first:Boolean = true;

        public function AchievementDlg() {
            super();
            _section = new Section();
            addChild(_section);
            _closeButton = btnClose;
            isVisible = true;
            initChargeButtonEvent();
            background = new DialogBackground();
        }

        override public function close():void {
            JTFunctionManager.executeFunction(JTGlobalDef.PLAY_CITY_ANIMATABLE);
            super.close();
        }

        private function initChargeButtonEvent():void {
            Recharge.addEventListener(Event.TRIGGERED, onChargeButtonClick);
        }

        private function onChargeButtonClick(e:Event):void {
            DialogMgr.instance.open(VipDlg, VipDlg.CHARGE);
        }

        override public function open(container:DisplayObjectContainer, parameter:Object = null, okFun:Function = null, cancelFun:Function = null):void {
            super.open(container, parameter, okFun, cancelFun);
            updateMoney();
            GameMgr.instance.onUpateMoney.add(updateMoney);
            createMenu(); //创建菜单按钮
            addSection(1);
            setToCenter();
            JTFunctionManager.executeFunction(JTGlobalDef.STOP_CITY_ANIMATABLE, false);
        }

        private function createMenu():void {
            var onFocus:ISignal = new Signal();
            var factory:MenuFactory = new MenuFactory();
            factory.onFocus = onFocus;

            var defaultSkin:Texture = AssetMgr.instance.getTexture("ui_butten_rongyufenleianniu1");
            var downSkin:Texture = AssetMgr.instance.getTexture("ui_butten_rongyufenleianniu2");

            addChildAt(factory, getChildIndex(menuIcon1) - 1);
            factory.factory([{"defaultSkin": defaultSkin, "downSkin": downSkin, x: 34, y: 125, isSelect: true, onClick: onSection,
                                 name: "1"}, {"defaultSkin": defaultSkin, "downSkin": downSkin, x: 34, y: 206, onClick: onSection,
                                 name: "4"}, {"defaultSkin": defaultSkin, "downSkin": downSkin, x: 34, y: 288, onClick: onSection,
                                 name: "5"}, {"defaultSkin": defaultSkin, "downSkin": downSkin, x: 34, y: 370, onClick: onSection,
                                 name: "6"}]);
            var arr:Array = Langue.getLans("AchievementMenu");

            for (var i:int = 0; i < arr.length; i++) {
                this["menuTxt" + (i + 1)].text = arr[i];
            }
        }

        //选择菜单
        private function onSection(e:Event):void {
            var type:int = int((e.target as MenuButton).name);
            addSection(type);
        }

        //切换显示不同的成就任务
        private function addSection(type:int):void {
            _section.createSection(type);
        }

        //更新金币
        private function updateMoney():void {
            StringUtil.changePriceText(GameMgr.instance.coin, money, k);
            StringUtil.changePriceText(GameMgr.instance.diamond, diamond, k1, false);
        }

        override public function dispose():void {
            GameMgr.instance.onUpateMoney.remove(updateMoney);
            _section && _section.dispose();
            super.dispose();
        }


        /**
         * 新手引导
         * @param name
         * @return
         *
         */
        override public function getGuideDisplay(name:String):* {
            if (name.indexOf("成就") >= 0) {
                var overall:Overall = _section.face as Overall;

                if (!overall.list.isCreated)
                    overall.list.validate();
                overall.list.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;

                //没有可以领取的成就，直接跳转下一步
                if (!AchievementData.instance.isReceive) {
                    NewGuide2Manager.sendNextSeverStep();
                    Starling.juggler.delayCall(gotoNext, 0.3);
                }
                var q:Quad = new Quad(92, 91);
                q.x = overall.list.x + 560;
                q.y = overall.list.y + 10;
                overall.addChild(q);
                return q;
            }
            return null;
        }

        override public function get height():Number {
            return 637 * (Constants.isScaleWidth ? Constants.scale_x : Constants.scale);
        }
    }
}
