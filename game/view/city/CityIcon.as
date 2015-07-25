package game.view.city
{
    import com.dialog.DialogMgr;
    import com.utils.Constants;
    import com.utils.StringUtil;
    import com.view.base.event.EventType;

    import flash.utils.Dictionary;

    import game.common.JTFastBuyComponent;
    import game.data.Attain;
    import game.data.ConfigData;
    import game.hero.AnimationCreator;
    import game.manager.AssetMgr;
    import game.manager.GameMgr;
    import game.manager.HeroDataMgr;
    import game.net.data.c.CGet_tired;
    import game.net.data.vo.AttainInfo;
    import game.net.message.GoodsMessage;
    import game.net.message.MailMessage;
    import game.view.FeedBack.FeedBackDlg;
    import game.view.SystemSet.SystemSetDlg;
    import game.view.achievement.Dlg.AchievementDlg;
    import game.view.achievement.data.AchievementData;
    import game.view.chat.component.JTChatControllerComponent;
    import game.view.dispark.DisparkControl;
    import game.view.dispark.data.ConfigDisparkStep;
    import game.view.email.EmailDlg;
    import game.view.loginReward.Dla.LoginRewardDlg;
    import game.view.magicorbs.MagicOrb;
    import game.view.notice.NoticeDlg;
    import game.view.pack.PackDlg;
    import game.view.picture.PictureView;
    import game.view.strategy.StrategyDlg;
    import game.view.task.TaskDialog;
    import game.view.uitils.Res;
    import game.view.viewBase.CityIconBase;
    import game.view.vip.VipDlg;
    import game.view.vip.VipRewardDlg;

    import starling.display.Button;
    import starling.display.DisplayObject;
    import starling.events.Event;
    import starling.text.TextField;

    import treefortress.spriter.SpriterClip;


    public class CityIcon extends CityIconBase
    {
        public static const CREATE_DIALOG:String="create_dialog";

        /**
         * 是否缩进
         */
        public static var isInside:Boolean=false;
        private var isTweening:Boolean;

        /**
         * 记录动画
         */
        private var tag_dic:Dictionary=new Dictionary(true);

        public function CityIcon()
        {
            super();
        }

        override protected function init():void
        {
            btn_help.x=Constants.virtualWidth - btn_help.width - 4;
            btn_strategy.x=Constants.virtualWidth - btn_strategy.width - 4;

            view_title.x=Constants.virtualWidth * .5;
            btn_reward.x=view_title.x - view_title.width * .5;
            btn_vipReward.x=btn_reward.x + 70;
            //新手引导需要处理
            btn_welfare.addEventListener(Event.TRIGGERED, onWelfare); //福利

            var arrowAnimation:SpriterClip=AnimationCreator.instance.create("effect_renwutexiao", AssetMgr.instance);
            arrowAnimation.play("effect_renwutexiao");
            arrowAnimation.animation.looping=true;
            addQuiackChildAt(arrowAnimation, 0);
            arrowAnimation.x=btn_strategy.x + btn_strategy.width * .5;
            arrowAnimation.y=btn_strategy.y + btn_strategy.height * .5

            //添加到功能开放方便操作减低耦合性
            DisparkControl.dicDisplay["btn_bag"]=btn_bag;
            DisparkControl.dicDisplay["btn_mail"]=btn_mail;
            DisparkControl.dicDisplay["btn_pic"]=btn_pic;
            DisparkControl.dicDisplay["btn_help"]=btn_help;
            DisparkControl.dicDisplay["btn_welfare"]=btn_welfare;
            DisparkControl.dicDisplay["btn_strategy"]=btn_strategy;
        }

        override protected function show():void
        {
            //请求疲劳
            sendMessage(CGet_tired);
            updateHeroIco(null, GameMgr.instance.picture);
            updatePower();
            updateTired();
            updateMoney();
            updateSignStatus();
            updateFbStatus();
            updateVipStatus();
            updateNoticeStatus(null, GameMgr.instance.hasNotice);
            onUpdateMailState(null, MailMessage.isNotice);
            updateAchievementStatus(null, AchievementData.instance.isReceive);
            updateRankLevel();
            updateDailyStatus();
            JTChatControllerComponent.isShowCityIcon=true;
        }

        override protected function addListenerHandler():void
        {
            addViewListener(btn_bag, Event.TRIGGERED, onPake); //背包
            addViewListener(btn_mail, Event.TRIGGERED, onEmail); //邮件
            addViewListener(btn_pic, Event.TRIGGERED, onPicture); //   图鉴
            addViewListener(ico_hero, Event.TRIGGERED, icoHeadClick); //   头像点击
            addViewListener(view_title.getChildByName("btn_diamond"), Event.TRIGGERED, chongzhiClick); //   充值
            addViewListener(view_title.getChildByName("btn_money"), Event.TRIGGERED, moneyClick); //   购买金币
            addViewListener(view_title.getChildByName("btn_tired"), Event.TRIGGERED, onBuyTired); //购买疲劳
            addViewListener(btn_strategy, Event.TRIGGERED, onStrategy); //每日必做
            addViewListener(btn_vip, Event.TRIGGERED, onVipClick); //vip
            addViewListener(btn_help, Event.TRIGGERED, onHelp); //帮助			
            addViewListener(btn_notice, Event.TRIGGERED, onNotice); //公告			
            addViewListener(btn_reward, Event.TRIGGERED, onReward);
            addViewListener(btn_vipReward, Event.TRIGGERED, onVipReward);

            addContextListener(MailMessage.NOTICE_MAIL, onUpdateMailState);
            addContextListener(EventType.UPDATE_MONEY, updateMoney);
            addContextListener(EventType.UPDATE_SIGN, updateSignStatus);
            addContextListener(EventType.UPDATE_NOTICE, updateNoticeStatus);
            addContextListener(EventType.NOTIFY_ACHIEVEMENT, updateAchievementStatus);
            addContextListener(EventType.UPDATE_POWER, updatePower);
            addContextListener(EventType.UPDATE_PASS_FB, updateFbStatus);
            addContextListener(EventType.UPDATE_VIP, updateVipStatus);
            addContextListener(EventType.UPDATE_RANK_LEVEL, updateRankLevel);
            addContextListener(EventType.UPDATE_TIRED, updateTired);
            addContextListener(EventType.UP_HEROPHOTO, updateHeroIco);
        }

        /**
         * 成就
         *
         */
        private function onReward():void
        {
            DialogMgr.instance.open(AchievementDlg);
        }

        private function onVipReward():void
        {
            DialogMgr.instance.open(VipRewardDlg);
        }

        private function onNotice():void
        {
            openAssignDialog(NoticeDlg);
        }

        private function onWelfare():void
        {
            openAssignDialog(WelfareView);
        }

        /**
         * 购买疲劳
         *
         */
        private function onBuyTired():void
        {
            GoodsMessage.onBuyTiredClick();
        }

        /**
         * 购买金币
         *
         */
        private function moneyClick():void
        {
            DialogMgr.instance.open(JTFastBuyComponent, JTFastBuyComponent.FAST_BUY_MONEY);
        }

        /**
         * 竞技场等级更新
         *
         */
        private function updateRankLevel():void
        {
            tag_rankLevel.texture=Res.instance.getRankPhoto(GameMgr.instance.rankLevel);
        }

        /**
         * vip等级更新
         *
         */
        private function updateVipStatus():void
        {
            txt_vip.text=GameMgr.instance.vip + "";
            btn_vipReward.visible=GameMgr.instance.vipData.id > 1 && GameMgr.instance.vipData.dayPrize == 0;
        }

        /**
         * VIP点击
         *
         */
        private function onVipClick():void
        {
            openAssignDialog(VipDlg);
        }

        /**
         * 攻略
         *
         */
        private function onStrategy():void
        {
            openAssignDialog(TaskDialog);

        }

        private function onHelp():void
        {

            openAssignDialog(StrategyDlg);
        }

        /**
         * 更换头像
         */
        private function updateHeroIco(evt:Event, picture:int):void
        {
            ico_hero.upState=Res.instance.getRolePhoto(picture); //人物头像		
        }

        /**
         * 更新战斗力
         *
         */
        private function updatePower():void
        {
            TextField(view_title.getChildByName("txt_ability")).text=HeroDataMgr.instance.getPower() + "";
        }

        /**
         * 更新金币
         *
         */
        private function updateMoney():void
        {
            TextField(view_title.getChildByName("txt_money")).text=StringUtil.changePrice(GameMgr.instance.coin, true);
            TextField(view_title.getChildByName("txt_diamond")).text=GameMgr.instance.diamond + "";
            updateLuckyStatus();
        }

        /**
         * 更新疲劳
         * @param evt
         *
         */
        private function updateTired():void
        {
            TextField(view_title.getChildByName("txt_tired")).text=GameMgr.instance.tired + "/100";
        }

        private function icoHeadClick():void
        {
            openAssignDialog(SystemSetDlg);
        }


        private function chongzhiClick():void
        {
            openAssignDialog(VipDlg, VipDlg.CHARGE);
        }

        /**
         *
         * 背包
         *
         */
        public function onPake():void
        {
            openAssignDialog(PackDlg);
        }

        /**
         *
         * 邮件
         *
         */
        private function onEmail():void
        {
            if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep9)) //判断功能开放提示
                return;
            openAssignDialog(EmailDlg);


        }


        /**
         *签到
         *
         */
        public function onRegistration():void
        {
            openAssignDialog(LoginRewardDlg);
        }


        /**
         *  反馈
         *
         */
        private function onFeedback():void
        {
            openAssignDialog(FeedBackDlg);
        }

        /**
         *宝珠获取
         *
         */
        private function onGetorb():void
        {
            openAssignDialog(MagicOrb);
        }

        private function onPicture():void
        {
            if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep2))
            { //图鉴功能是否开启
                return;
            }
            openAssignDialog(PictureView);
        }


        private function openAssignDialog(ClassName:Class, param:Object=null):void
        {
            this.dispatch(CREATE_DIALOG, {"cls": ClassName, "data": param});
        }

        /**
         * 更新幸运星提示
         *
         */
        private function updateLuckyStatus():void
        {
            if (GameMgr.instance.star > 0 && GameMgr.instance.tollgateID >= ConfigData.instance.luckyGuide)
            {
                updateWelfareStatus(true, "lucky");
                return;
            }
            updateWelfareStatus(false, "lucky");
        }

        private function updateWelfareStatus(value:Boolean, btn:String):void
        {
            if (tag_dic["welfare"] == null)
                tag_dic["welfare"]=[];
            var list:Array=tag_dic["welfare"];
            var index:int=list.indexOf(btn);

            if (value && index == -1)
            {
                list.push(btn);
                createAction(btn_welfare, "btn_welfare");
            }
            else if (!value && index != -1)
            {
                list.splice(index, 1);
                list.length == 0 && removeAction("btn_welfare");
            }
        }

        /**
         * 检测是否有新副本可打
         *
         */
        private function updateFbStatus():void
        {
//			if (FBCDData.checkFbStatus(GameMgr.instance.tollgateID - 1))
//			{
//				createAction(btn_fb, "fb_pass");
//				return;
//			}
//			removeAction("fb_pass");
        }

        /**
         * 更新登陆奖励提示
         *
         */
        private function updateSignStatus():void
        {
            if (GameMgr.instance.sign_reward == 1)
            {
                updateWelfareStatus(true, "sign");
                return;
            }
            updateWelfareStatus(false, "sign");
        }

        /**
         * 更新邮件提示动画
         * @param evt
         * @param notice
         *
         */
        private function onUpdateMailState(evt:Event, notice:Boolean):void
        {
            if (notice)
            {
                createAction(btn_mail, "mail_notice", 50);
                return;
            }
            removeAction("mail_notice");
        }

        /**
         * 更新成就提示
         * @param isReceive
         *
         */
        private function updateAchievementStatus(evt:Event, isReceive:Boolean):void
        {
            updateDailyStatus();
            btn_reward.visible=isReceive;

            if (isReceive)
            {
                updateWelfareStatus(true, "Achievement");
                return;
            }
            updateWelfareStatus(false, "Achievement");
        }

        /**
         * 更新每日成就奖励
         *
         */
        private function updateDailyStatus():void
        {
            var tmp_list:Array=Attain.getListByType(9, GameMgr.instance.tollgateID);
            var len:int=tmp_list.length;
            var attainInfo:AttainInfo;
            var attainData:Attain;
            var needTips:Boolean=false;

            for (var i:int=0; i < len; i++)
            {
                attainData=tmp_list[i];
                attainInfo=AchievementData.instance.getAttainInfoById(attainData.id);

                if (attainInfo && attainInfo.num < attainData.condition)
                    needTips=true;
            }

            if (needTips)
            {
                createAction(btn_strategy, "btn_strategy");
                return;
            }
            removeAction("btn_strategy");
        }

        /**
         * 更新公告提示
         * @param evt
         * @param isReceive
         *
         */
        private function updateNoticeStatus(evt:Event, isReceive:Boolean):void
        {
            if (isReceive)
            {
                createAction(btn_notice, "notice");
                return;
            }
            removeAction("notice");
        }

        private function removeAction(name:String):void
        {
            CityIcon.removeAction(name, tag_dic);
        }

        private function createAction(child:Button, name:String, x:int=0, y:int=0):SpriterClip
        {
            child.name=name;
            return CityIcon.createAction(child, name, tag_dic, x, y);
        }

        /**
         * 创建动画提示
         * @param child
         * @param name
         * @param x
         * @param y
         * @return
         *
         */
        public static function createAction(child:Button, name:String, dic:Dictionary, x:int=0, y:int=0):SpriterClip
        {
            var disObj:SpriterClip=dic[name] as SpriterClip;

            if (disObj)
                return null;
            var action:SpriterClip=AnimationCreator.instance.create("effect_warning", AssetMgr.instance);
            action.play("NewAnimation");
            action.animation.looping=true;
            action.x=x > 0 ? x : (child.width - child.width * .08);
            action.y=y > 0 ? y : child.height * .2;
            child.addQuiackChild(action);
            action.touchable=false;
            action.name="tag";
            dic[name]=action;
            return action;
        }

        /**
         * 移除动画
         * @param name
         *
         */
        public static function removeAction(name:String, dic:Dictionary):void
        {
            var disObj:DisplayObject=dic[name];
            disObj && disObj.removeFromParent(true);
            delete dic[name];
        }

        override public function dispose():void
        {
            super.dispose();
            btn_welfare.removeEventListener(Event.TRIGGERED, onWelfare); //福利
            var clip:SpriterClip;

            for (var key:String in tag_dic)
            {
                clip=tag_dic[key] as SpriterClip;
                clip && clip.removeFromParent(true);
                tag_dic[key]=null;
            }
        }
    }
}
