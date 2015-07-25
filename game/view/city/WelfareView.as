package game.view.city
{
	import com.dialog.DialogMgr;
	import com.view.base.event.EventType;

	import flash.utils.Dictionary;

	import game.data.ConfigData;
	import game.manager.GameMgr;
	import game.view.achievement.Dlg.AchievementDlg;
	import game.view.achievement.data.AchievementData;
	import game.view.activity.ActivityDlg;
	import game.view.dispark.DisparkControl;
	import game.view.dispark.data.ConfigDisparkStep;
	import game.view.loginReward.Dla.LoginRewardDlg;
	import game.view.luckyStar.LuckyStarDlg;
	import game.view.new2Guide.NewGuide2Manager;
	import game.view.rank.JTRankListComponent;
	import game.view.viewBase.WelfareViewBase;
	import game.view.vip.VipDlg;
	import game.view.vip.VipRewardDlg;

	import starling.events.Event;

	/**
	 * 福利
	 * @author hyy
	 *
	 */
	public class WelfareView extends WelfareViewBase
	{
		private var tag_dic:Dictionary=new Dictionary(true);

		public function WelfareView()
		{
			super();
		}

		override protected function init():void
		{
			if (NewGuide2Manager.instance == null)
				enableTween=true;
			_closeButton=btn_close;
			clickBackroundClose();
			btn_new.disable=true;
		}

		override protected function show():void
		{
			setToCenter();
			//功能开放引导
			DisparkControl.dicDisplay["welfare_lucky"]=btn_lucky;
			//智能判断是否添加功能开放提示图标（幸运星）
			DisparkControl.instance.addDisparkHandler(ConfigDisparkStep.DisparkStep5);
		}

		override protected function addListenerHandler():void
		{
			super.addListenerHandler();
			this.addViewListener(btn_first, Event.TRIGGERED, onFirst);
			this.addViewListener(btn_lucky, Event.TRIGGERED, onLucky);
			this.addViewListener(btn_month, Event.TRIGGERED, onMonth);
			this.addViewListener(btn_new, Event.TRIGGERED, onNew);
			this.addViewListener(btn_rank, Event.TRIGGERED, onRank);
			this.addViewListener(btn_share, Event.TRIGGERED, onShare);
			this.addViewListener(btn_sign, Event.TRIGGERED, onSign);
			this.addViewListener(btn_reward, Event.TRIGGERED, onReward);
			this.addViewListener(btn_vip, Event.TRIGGERED, onVip);

			addContextListener(EventType.NOTIFY_ACHIEVEMENT, updateAchievementStatus);
			addContextListener(EventType.UPDATE_SIGN, updateSignStatus);
			addContextListener(EventType.UPDATE_MONEY, updateLuckyStatus);
			addContextListener(EventType.UPDATE_VIP, updateVipStatus);
		}

		override protected function openTweenComplete():void
		{
			updateSignStatus();
			updateLuckyStatus();
			updateVipStatus();
			updateAchievementStatus(null, AchievementData.instance.isReceive);
		}

		/**
		 * 更新成就提示
		 * @param isReceive
		 *
		 */
		private function updateAchievementStatus(evt:Event, isReceive:Boolean):void
		{
			if (isReceive)
			{
				CityIcon.createAction(btn_reward, "btn_reward", tag_dic);
				return;
			}
			CityIcon.removeAction("btn_reward", tag_dic);
		}

		/**
		 * 更新幸运星提示
		 *
		 */
		private function updateLuckyStatus():void
		{
			if (GameMgr.instance.star > 0 && GameMgr.instance.tollgateID >= ConfigData.instance.luckyGuide)
			{
				CityIcon.createAction(btn_lucky, "btn_lucky", tag_dic);
				return;
			}
			CityIcon.removeAction("btn_lucky", tag_dic);
		}

		/**
		 * 更新登陆奖励提示
		 *
		 */
		private function updateSignStatus():void
		{
			if (GameMgr.instance.sign_reward == 1)
			{
				CityIcon.createAction(btn_sign, "btn_sign", tag_dic);
				return;
			}
			CityIcon.removeAction("btn_sign", tag_dic);
		}

		private function updateVipStatus():void
		{
			if (GameMgr.instance.vipData.id > 1 && GameMgr.instance.vipData.dayPrize == 0)
			{
				CityIcon.createAction(btn_vip, "btn_vip", tag_dic);
				return;
			}
			CityIcon.removeAction("btn_vip", tag_dic);
		}

		/**
		 * 首冲
		 *
		 */
		private function onFirst():void
		{
			DialogMgr.instance.open(ActivityDlg, [0]);
		}

		/**
		 * 幸运星
		 *
		 */
		private function onLucky():void
		{
			if (!DisparkControl.instance.isOpenHandler(ConfigDisparkStep.DisparkStep5)) //幸运星功能是否开启
				return;
			DialogMgr.instance.open(LuckyStarDlg);
		}

		/**
		 * 月卡
		 *
		 */
		private function onMonth():void
		{
			DialogMgr.instance.open(VipDlg, VipDlg.CHARGE);
		}

		/**
		 * 新手
		 *
		 */
		private function onNew():void
		{

		}

		/**
		 * 排行
		 *
		 */
		private function onRank():void
		{
			JTRankListComponent.open();
		}

		/**
		 * 成就
		 *
		 */
		private function onReward():void
		{
			DialogMgr.instance.open(AchievementDlg);
		}

		/**
		 * 分享
		 *
		 */
		private function onShare():void
		{
			DialogMgr.instance.open(ActivityDlg, [1]);
		}

		/**
		 * 签到
		 *
		 */
		private function onSign():void
		{
			DialogMgr.instance.open(LoginRewardDlg);
		}

		private function onVip():void
		{
			DialogMgr.instance.open(VipRewardDlg);
		}

		override public function dispose():void
		{
			CityIcon.removeAction("btn_sign", tag_dic);
			CityIcon.removeAction("btn_lucky", tag_dic);
			CityIcon.removeAction("btn_vip", tag_dic);
			CityIcon.removeAction("btn_reward", tag_dic);
			super.dispose();
		}
	}
}
