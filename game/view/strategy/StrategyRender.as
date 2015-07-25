package game.view.strategy
{
    import com.dialog.DialogMgr;

    import game.data.StrategyData;
    import game.view.achievement.Dlg.AchievementDlg;
    import game.view.activity.ActivityDlg;
    import game.view.blacksmith.BlacksmithDlg;
    import game.view.dispark.DisparkControl;
    import game.view.dispark.data.ConfigDisparkStep;
    import game.view.heroHall.HeroDialog;
    import game.view.loginReward.Dla.LoginRewardDlg;
    import game.view.viewBase.StrategyRenderBase;
    import game.view.vip.VipDlg;

    public class StrategyRender extends StrategyRenderBase
    {
        public function StrategyRender()
        {
            super();
        }

        override public function set data(value:Object):void
        {
            super.data=value;
            var strategyData:StrategyData=value as StrategyData;

            if (strategyData == null)
                return;
            txt_name.text=strategyData.name;
            txt_des.text=strategyData.des;

            for (var i:int=0; i < 5; i++)
            {
                this["star_" + i].visible=strategyData.starNum - 1 >= i;
            }
        }

        override public function set isSelected(value:Boolean):void
        {
//			super.isSelected = value;
            value && onClick();
        }

        private function onClick():void
        {
            switch (txt_name.text)
            {
                case "奖励":
                    DialogMgr.instance.open(AchievementDlg);
                    break;
                case "签到":
                    DialogMgr.instance.open(LoginRewardDlg);
                    break;
                case "邀请好友":
                    DialogMgr.instance.open(ActivityDlg, [1, 1]);
                    break;
                case "好友登录":
                    DialogMgr.instance.open(ActivityDlg, [1, 2]);
                    break;
                case "充值":
                    DialogMgr.instance.open(VipDlg, VipDlg.CHARGE);
                    break;
                case "强化装备":
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep1))
                        return;
                    DialogMgr.instance.open(BlacksmithDlg, [BlacksmithDlg.STRENGTHEN]);
                    break;
                case "进阶英雄":
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep12))
                        return;
                    DialogMgr.instance.open(HeroDialog);
                    break;
                case "镶嵌宝珠":
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep17))
                        return;
                    DialogMgr.instance.open(BlacksmithDlg, [BlacksmithDlg.GEM]);
                    break;
                case "合成装备":
                    if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep15))
                        return;
                    DialogMgr.instance.open(BlacksmithDlg, [BlacksmithDlg.FORGE]);
                    break;
                default:
                    break;

            }
        }
    }
}
