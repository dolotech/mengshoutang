package game.view.dailyDo {
    import com.components.RollTips;
    import com.dialog.DialogMgr;
    import com.langue.Langue;
    import com.scene.SceneMgr;
    import com.view.base.event.EventType;
    import com.view.base.event.ViewDispatcher;

    import game.data.Attain;
    import game.data.ConfigData;
    import game.dialog.ShowLoader;
    import game.manager.GameMgr;
    import game.net.GameSocket;
    import game.net.data.c.CAttain_get;
    import game.scene.world.NewFbScene;
    import game.scene.world.NewMainWorld;
    import game.view.dispark.DisparkControl;
    import game.view.dispark.data.ConfigDisparkStep;
    import game.view.loginReward.Dla.LoginRewardDlg;
    import game.view.luckyStar.LuckyStarDlg;
    import game.view.magicorbs.MagicOrb;
    import game.view.blacksmith.BlacksmithDlg;
    import game.view.newhero.HeroDlg;
    import game.view.tavern.TavernDialog;
    import game.view.uitils.Res;
    import game.view.viewBase.DailyDoRenderBase;
    import game.view.vip.VipDlg;
    import game.view.vip.VipRewardDlg;

    import starling.events.Event;

    public class DailyDoRender extends DailyDoRenderBase {
        public static var get_id:int;

        public function DailyDoRender() {
            super();
            btn_ok.addEventListener(Event.TRIGGERED, onClick);
        }

        override public function set data(value:Object):void {
            super.data = value;

            if (value == null)
                return;
            var attainData:Attain = value as Attain;
            txt_title.text = attainData.caption;
            txt_reward.text = "x" + attainData.values;

            btn_ok.visible = attainData.finish_num != -1;
            tag_finish.visible = !btn_ok.visible;
            tag_get.visible = attainData.finish_num >= attainData.condition;

            if (tag_get.visible)
                btn_ok.text = "";
            else
                btn_ok.text = Langue.getLangue("goto") + "   " + (attainData.finish_num + "/" + attainData.condition);
            tag_type.texture = Res.instance.getGoldPhoto(attainData.goodsType);
        }

        private function onClick():void {
            if (owner && owner.isScrolling)
                return;
            var attainData:Attain = data as Attain;

            if (tag_get.visible) {
                get_id = attainData.id;
                var cmd:CAttain_get = new CAttain_get();
                cmd.id = attainData.id;
                GameSocket.instance.sendData(cmd);
                ShowLoader.add();
                return;
            }

            var dialogMgr:DialogMgr = DialogMgr.instance;

            switch (attainData.name) {
                case "强化":
                    dialogMgr.open(BlacksmithDlg, [BlacksmithDlg.STRENGTHEN]);
                    break;
                case "合成":
                    dialogMgr.open(BlacksmithDlg, [BlacksmithDlg.FORGE]);
                    break;
                case "镶嵌":
                    dialogMgr.open(BlacksmithDlg, [BlacksmithDlg.GEM]);
                    break;
                case "净化":
                    dialogMgr.open(HeroDlg);
                    break;
                case "解雇英雄":
                    dialogMgr.open(HeroDlg);
                    break;
                case "幸运星":
//                    if (GameMgr.instance.tollgateID <= ConfigData.instance.luckyGuide) {
//                        RollTips.addNoOpenInfo(ConfigData.instance.luckyGuide);
//                        return;
//                    }
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep5)) //幸运星功能是否开启
                        return;
                    dialogMgr.open(LuckyStarDlg);
                    break;
                case "酒馆":
                    if (GameMgr.instance.tollgateID <= ConfigData.instance.tavernGuide) {
                        RollTips.addNoOpenInfo(ConfigData.instance.tavernGuide);
                        return;
                    }
                    dialogMgr.open(TavernDialog);
                    break;
                case "宝珠":
                    dialogMgr.open(MagicOrb);
                    break;
                case "登录奖励":
                    dialogMgr.open(LoginRewardDlg);
                    break;
                case "VIP礼包":
                    dialogMgr.open(VipRewardDlg);
                    break;
                case "副本战斗":
                    SceneMgr.instance.changeScene(NewFbScene);
                    break;
                case "主线":
                    SceneMgr.instance.changeScene(NewMainWorld);
                    break;
                case "竞技场":
                    ViewDispatcher.dispatch(EventType.OPEN_ARENA);
                    break;
                case "月卡":
                    dialogMgr.open(VipDlg, VipDlg.CHARGE);
                    break;
                default:
                    break;
            }
        }
    }
}
