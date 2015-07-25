package game.view.activity {
    import com.dialog.DialogMgr;
    import com.mvc.interfaces.INotification;
    import com.utils.Constants;
    import com.utils.StringUtil;
    
    import feathers.controls.List;
    import feathers.controls.Scroller;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ListCollection;
    import feathers.layout.TiledColumnsLayout;
    import feathers.layout.TiledRowsLayout;
    
    import game.dialog.DialogBackground;
    import game.dialog.ShowLoader;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.net.GameSocket;
    import game.net.data.c.CStartFest;
    import game.net.data.s.SStartFest;
    import game.net.data.vo.FestIds;
    import game.view.activity.base.AcitivityItemRendBase;
    import game.view.activity.base.ActivityDlgBase;
    import game.view.vip.VipDlg;
    
    import starling.core.Starling;
    import starling.display.DisplayObjectContainer;
    import starling.events.Event;

    public class ActivityDlg extends ActivityDlgBase {
        public var section:ActivitySection;
        private var activityList:Array = [];

        public function ActivityDlg() {
            super();
            _closeButton = closeButton;
            section = new ActivitySection();
            isVisible = true;
            addChild(section);
            RechargeButton.addEventListener(Event.TRIGGERED, onRecharge);
            background = new DialogBackground();
        }

        private function onRecharge(e:Event):void {
            DialogMgr.instance.open(VipDlg, VipDlg.CHARGE);
        }

        override public function open(container:DisplayObjectContainer, parameter:Object = null, okFun:Function = null, cancelFun:Function = null):void {
            super.open(container, parameter, okFun, cancelFun);
            send();
            updateMoney();
            GameMgr.instance.onUpateMoney.add(updateMoney);
            setToCenter();
        }
		
		override public function get height() : Number
		{
			return 620 * (Constants.isScaleWidth ? Constants.scale_x : Constants.scale);
		}
		
        private var list:List;

        private function send():void {
            var cmd:CStartFest = new CStartFest();
            GameSocket.instance.sendData(cmd);
            ShowLoader.add();
        }

        override public function handleNotification(_arg1:INotification):void {
            var info:SStartFest = _arg1 as SStartFest;
            var i:int = 0;
            activityList.length = 0;
            var len:int = info.ids.length;
            var fest:FestIds;

            for (i; i < len; i++) {
                fest = info.ids[i] as FestIds;
                activityList[i] = fest.id;
            }
            activityList.sort(Array.NUMERIC);
            createList();
            ShowLoader.remove();
        }

        override public function listNotificationName():Vector.<String> {
            var vect:Vector.<String> = new Vector.<String>;
            vect.push(SStartFest.CMD);
            return vect;
        }

        private function createList():void {
            const listLayout:TiledColumnsLayout = new TiledColumnsLayout();
            listLayout.gap = 8;
            listLayout.useSquareTiles = false;
            listLayout.useVirtualLayout = true;
            listLayout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
            listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;

            list = new List();
            list.x = 32;
            list.y = 135;
            list.width = 198;
            list.height = 464;
            addChild(list);
            list.layout = listLayout;
            list.paddingLeft = 10;
            list.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;

            list.itemRendererFactory = tileListItemRendererFactory;
            list.addEventListener(Event.CHANGE, onSelect);
            refreshListData();
        }

        private function refreshListData():void {
            const collection:ListCollection = new ListCollection(activityList);
            list.dataProvider = collection;

            Starling.juggler.delayCall(function():void {
                if (activityList.length > 0) {
                    list.selectedIndex = _parameter && _parameter.length > 0 ? _parameter[0] : 0;
                    var i:int = 0;
                    var len:int = activityList.length;
                    var item:ActivityItemRender
                    var skin:AcitivityItemRendBase;

                    for (i; i < len; i++) {
                        item = list.dataViewPort.getChildAt(i) as ActivityItemRender;

                        if (item.data == list.selectedItem) {
                            skin = item.defaultSkin as AcitivityItemRendBase;
                            skin.ckButton.upState = AssetMgr.instance.getTexture("ui_butten_activities_Package4");

                            skin.ckButton.getChildAt(0).width = 155;
                            skin.ckButton.getChildAt(0).height = 92;
                        }
                    }
                }
            }, 0.2);

        }


        private function onSelect(e:Event):void {
            if (list.selectedIndex == -1)
                return;

            section.section(int(list.selectedItem), (_parameter && _parameter.length > 1 ? _parameter[1] : -1));
        }

        protected function tileListItemRendererFactory():IListItemRenderer {
            const renderer:ActivityItemRender = new ActivityItemRender();
            renderer.setSize(171, 107);
            return renderer;
        }

        //更新金币
        private function updateMoney():void {
            StringUtil.changePriceText(GameMgr.instance.coin, moneyTxt, kTxt);
            StringUtil.changePriceText(GameMgr.instance.diamond, diamondTxt, k1Txt, false);
        }

        override public function dispose():void {
            GameMgr.instance.onUpateMoney.remove(updateMoney);
            super.dispose();
        }
    }
}
import feathers.controls.renderers.DefaultListItemRenderer;

import game.data.ActivityListData;
import game.manager.AssetMgr;
import game.view.activity.base.AcitivityItemRendBase;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

import starling.events.Event;


class ActivityItemRender extends DefaultListItemRenderer {

    public static var onChange:ISignal = new Signal();

    public function ActivityItemRender() {
        defaultSkin = new AcitivityItemRendBase;
        var d:AcitivityItemRendBase = defaultSkin as AcitivityItemRendBase;
        d.addEventListener(Event.TRIGGERED, onChange1);
        d.ckButton.downState = null;
        d.Image1Button.downState = null;
        d.ckButton.upState = AssetMgr.instance.getTexture("ui_butten_activities_Package5");
        d.ckButton.getChildAt(0).width = 166;
        d.ckButton.getChildAt(0).height = 108;
        onChange.add(function(value:AcitivityItemRendBase):void {
            if (value == d)
                return;
            d.ckButton.upState = AssetMgr.instance.getTexture("ui_butten_activities_Package5");
            d.ckButton.getChildAt(0).width = 166;
            d.ckButton.getChildAt(0).height = 108;
        });
    }

    private function onChange1(e:Event):void {
        var d:AcitivityItemRendBase = defaultSkin as AcitivityItemRendBase;
        d.ckButton.upState = AssetMgr.instance.getTexture("ui_butten_activities_Package4");
        onChange.dispatch(d);
        d.ckButton.getChildAt(0).width = 155;
        d.ckButton.getChildAt(0).height = 92;
    }

    override public function set data(value:Object):void {
        super.data = value;

        if (value == null)
            return;
        var skin:AcitivityItemRendBase = defaultSkin as AcitivityItemRendBase;
        var activityData:ActivityListData = ActivityListData.hash.getValue(value);
        skin.Image1Button.upState = AssetMgr.instance.getTexture(activityData.Icon);
    }

    override public function dispose():void {
        onChange.removeAll();
        super.dispose();
    }
}
