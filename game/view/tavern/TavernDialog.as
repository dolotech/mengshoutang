package game.view.tavern
{
    import com.langue.Langue;
    import com.utils.Constants;

    import game.common.JTGlobalDef;
    import game.dialog.DialogBackground;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.managers.JTFunctionManager;
    import game.view.comm.menu.MenuButton;
    import game.view.comm.menu.MenuFactory;
    import game.view.dispark.DisparkControl;
    import game.view.dispark.data.ConfigDisparkStep;
    import game.view.tavern.view.DestinyView;
    import game.view.tavern.view.EngageView;
    import game.view.tavern.view.ExtractView;
    import game.view.viewBase.TavernDialogBase;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;

    import starling.display.DisplayObjectContainer;
    import starling.events.Event;
    import starling.textures.Texture;

    /**
     *酒馆
     * @author lfr
     */
    public class TavernDialog extends TavernDialogBase
    {
        //酒馆界面
        private var _extractPanel:ExtractView=null;
        //雇佣界面
        private var _engagePanel:EngageView=null;
        //命运之轮
        private var _destinyPanel:DestinyView=null;
        //菜单按钮
        private var _factory:MenuFactory=null;
        //当前标签
        private var _lablePage:uint=0;

        public function TavernDialog()
        {
            super();
        }

        override protected function init():void
        {
            background=new DialogBackground();
            isVisible=false;

            text_diamond.text=GameMgr.instance.diamond + ""; //钻石
            text_coin.text=GameMgr.instance.coin + ""; //金币

            var onFocus:ISignal=new Signal();
            _factory=new MenuFactory();
            _factory.onFocus=onFocus;
            addChild(_factory);

            _extractPanel=new ExtractView(this);
            _engagePanel=new EngageView(this);
            _destinyPanel=new DestinyView(this);
            addQuiackChild(_extractPanel);
            addQuiackChild(_engagePanel);
            addQuiackChild(_destinyPanel);

            _extractPanel.visible=true;
            _engagePanel.visible=false;
            _destinyPanel.visible=false;

            setChildIndex(_factory, this.numChildren - 1);

            _closeButton=btn_close;
            isVisible=true;
            GameMgr.instance.onUpateMoney.add(updateMoney);
        }

        private function updateMoney():void
        {
            text_diamond.text=GameMgr.instance.diamond + ""; //钻石
            text_coin.text=GameMgr.instance.coin + ""; //金币
        }

        override protected function addListenerHandler():void
        {
            super.addListenerHandler();
        }

        /**外部接口设置跳转默认界面*/
        public function selectPanel(lableIndex:int):void
        {
            var defaultSkin:Texture=AssetMgr.instance.getTexture("ui_button_tiebaomutouanjian");
            var downSkin:Texture=AssetMgr.instance.getTexture("ui_button_tiebaomutouanjian_liang");
            var arr:Array=Langue.getLans("tavernLables");
            var labs:Array=[];
            for (var i:int=0; i < 3; i++)
            {
                labs.push({"defaultSkin": defaultSkin, "downSkin": downSkin, x: 15 + i * 150, y: 18, onClick: selectLablePanel, isSelect: i == lableIndex ? true : false, size: i == 2 ? 28 : 32, color: 0xFFE7D0, text: arr[i], name: "lable_" + i});
            }
            _factory.factory(labs);

            //功能开放引导
            DisparkControl.dicDisplay["tavern_table_0"]=_factory.tableButtons[0];
            DisparkControl.dicDisplay["tavern_table_1"]=_factory.tableButtons[1];
            DisparkControl.dicDisplay["tavern_table_2"]=_factory.tableButtons[2];

            //智能判断是否添加功能开放提示图标（酒馆购买）
            DisparkControl.instance.addDisparkHandler(ConfigDisparkStep.DisparkStep3);
            //智能判断是否添加功能开放提示图标（雇佣兵）
            DisparkControl.instance.addDisparkHandler(ConfigDisparkStep.DisparkStep4);
            //智能判断是否添加功能开放提示图标（命运之轮）
            DisparkControl.instance.addDisparkHandler(ConfigDisparkStep.DisparkStep21);

            selectLableHandler(lableIndex);
        }

        /**选中英雄功能版面*/
        private function selectLablePanel(e:Event):void
        {
            selectLableHandler(int((e.target as MenuButton).name.split("_")[1]));
        }

        /**选择操作*/
        private function selectLableHandler(lableIndex:int):void
        {
            switch (lableIndex)
            {
                case 0:
                    _extractPanel.visible=true;
                    _engagePanel.visible=false;
                    _destinyPanel.visible=false;
                    _extractPanel.initData();
                    _lablePage=0;
                    //智能判断是否删除功能开放提示图标（酒馆购买）
                    DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep3);
                    break;
                case 1:
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep4)) //雇佣兵功能是否开启
                    {
                        selectPanel(_lablePage);
                        return;
                    }
                    //智能判断是否删除功能开放提示图标（雇佣兵）
                    DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep4);

                    _extractPanel.visible=false;
                    _engagePanel.visible=true;
                    _destinyPanel.visible=false;
                    _engagePanel.initData();
                    _lablePage=1;
                    break;
                case 2:
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep21)) //命运之轮功能是否开启
                    {
                        selectPanel(_lablePage);
                        return;
                    }
                    //智能判断是否删除功能开放提示图标（命运之轮）
                    DisparkControl.instance.removeDisparkHandler(ConfigDisparkStep.DisparkStep21);

                    _extractPanel.visible=false;
                    _engagePanel.visible=false;
                    _destinyPanel.visible=true;
                    _destinyPanel.initData();
                    _lablePage=2;
                    break;
            }
        }

        override public function open(container:DisplayObjectContainer, parameter:Object=null, okFun:Function=null, cancelFun:Function=null):void
        {

            super.open(container, parameter, okFun, cancelFun);
            if (parameter && parameter is int)
            {
                _lablePage=parameter as int;
            }
            selectPanel(_lablePage);
        }


        /**打开显示*/
        override protected function show():void
        {
            JTFunctionManager.executeFunction(JTGlobalDef.STOP_CITY_ANIMATABLE);
            setToCenter();
        }

        override public function close():void
        {
            super.close();
            JTFunctionManager.executeFunction(JTGlobalDef.PLAY_CITY_ANIMATABLE);
        }

        override public function get height():Number
        {
            return 635 * (Constants.isScaleWidth ? Constants.scale_x : Constants.scale);
        }

        /**销毁*/
        override public function dispose():void
        {
            super.dispose();
            _extractPanel=null;
            _engagePanel=null;
            _destinyPanel=null;
        }
    }
}


