package game.view.gameover
{
    import com.dialog.Dialog;
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.scene.BaseScene;
    import com.scene.SceneMgr;

    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.manager.HeroDataMgr;
    import game.net.message.GameMessage;
    import game.uils.LocalShareManager;
    import game.view.blacksmith.BlacksmithDlg;
    import game.view.dispark.DisparkControl;
    import game.view.dispark.data.ConfigDisparkStep;
    import game.view.heroHall.HeroDialog;
    import game.view.magicorbs.MagicOrb;
    import game.view.tavern.TavernDialog;
    import game.view.viewBase.NewLostRenderBase;

    import starling.events.Event;

    public class NewLostRender extends NewLostRenderBase
    {
        public function NewLostRender()
        {
            super();
            btn_ok.addEventListener(Event.TRIGGERED, onClick);
        }

        private function onClick():void
        {

            var dlg:Dialog;
            //0英雄数量|1装备等级|2强化等级|3英雄品质|4宝珠品质|5宝珠等级
            switch (data)
            {
                case 0:
                    if (HeroDataMgr.instance.getFreeBattleHero().length == 0)
                    {
                        if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep3))
                            return;
                        dlg=DialogMgr.instance.open(TavernDialog) as Dialog;
                    }
                    else
                    {
                        GameMessage.gotoTollgateData(GameMgr.instance.tollgateData.id);
						return;
                    }
                    break;
                case 1:
                    dlg=DialogMgr.instance.open(HeroDialog, HeroDialog.HERO) as Dialog;
                    break;
                case 2:
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep1))
                        return;
                    dlg=DialogMgr.instance.open(BlacksmithDlg, [BlacksmithDlg.STRENGTHEN]) as Dialog;
                    break;
                case 3:
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep12))
                        return;
                    dlg=DialogMgr.instance.open(HeroDialog, HeroDialog.JINHUA) as Dialog;
                    break;
                case 4:
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep20))
                        return;
                    dlg=DialogMgr.instance.open(MagicOrb, [MagicOrb.FOUSE]) as Dialog;
                    break;
                case 5:
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep18))
                        return;
                    dlg=DialogMgr.instance.open(MagicOrb, [MagicOrb.TUSHI]) as Dialog;
                    break;
                case 6:
                    LocalShareManager.getInstance().save(LocalShareManager.BEAST_BATTLE, 1);
                    GameMessage.gotoTollgateData(GameMgr.instance.tollgateData.id);
                    break;
                default:
                    break;
            }

            BaseScene(SceneMgr.instance.getCurScene()).visible=false;
            dlg && dlg.addEventListener(Dialog.CLOSE_CONTAINER, onClose);

            function onClose():void
            {
                BaseScene(SceneMgr.instance.getCurScene()).visible=true;
                dlg.removeEventListener(Dialog.CLOSE_CONTAINER, onClose)
            }
        }

        override public function set data(value:Object):void
        {
            super.data=value;

            switch (data)
            {
                case 0:
                case 3:
                    icon.texture=AssetMgr.instance.getTexture("ui_yindao_yingxiong");
                    break;
                case 1:
                case 2:
                    icon.texture=AssetMgr.instance.getTexture("ui_yindao_zhuangbei");
                    break;
                case 4:
                case 5:
                    icon.texture=AssetMgr.instance.getTexture("ui_yindao_zhuangbei");
                    break;
                default:
                    icon.texture=AssetMgr.instance.getTexture("ui_button_look_iocn");
                    break;
            }
            icon.readjustSize();
            txt_des.text=Langue.getLans("GUIDE_TYPE")[int(value)];
        }
    }
}

