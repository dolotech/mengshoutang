package game.view.SystemSet
{
	import com.components.RollTips;
	import com.dialog.DialogMgr;
	import com.langue.Langue;
	import com.mobileLib.utils.ConverURL;
	import com.scene.SceneMgr;
	import com.sound.SoundManager;
	import com.utils.Constants;
	import com.view.base.event.EventType;
	
	import flash.desktop.NativeApplication;
	import flash.geom.Rectangle;
	
	import feathers.core.PopUpManager;
	
	import game.data.ConfigData;
	import game.data.TollgateData;
	import game.manager.AssetMgr;
	import game.manager.GameMgr;
	import game.manager.HeroDataMgr;
	import game.managers.JTSingleManager;
	import game.net.GameSocket;
	import game.net.GlobalMessage;
	import game.net.message.ConnectMessage;
	import game.scene.LoginScene;
	import game.scene.world.NewMainWorld;
	import game.uils.LocalShareManager;
	import game.view.FeedBack.FeedBackDlg;
	import game.view.achievement.data.AchievementData;
	import game.view.chat.component.JTChatControllerComponent;
	import game.view.chat.component.JTMessageHornComponent;
	import game.view.chat.component.JTMessageSystemComponent;
	import game.view.city.CityFace;
	import game.view.city.CityIcon;
	import game.view.embattle.EmBattleDlg;
	import game.view.gameover.WinView;
	import game.view.loginReward.ResignDlg;
	import game.view.new2Guide.NewGuide2Manager;
	import game.view.replacePhotoList.GamePhotoDlg;
	import game.view.uitils.Res;
	import game.view.viewBase.SystemSetDlgBase;
	import game.view.viewGuide.ViewGuideManager;
	
	import sdk.AccountManager;
	import sdk.DataEyeManger;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;

	public class SystemSetDlg extends SystemSetDlgBase
	{
		private var isTween_effect : Boolean;
		private var isTween_bg : Boolean;

		private var isOpen_effect : Boolean;
		private var isOpen_bg : Boolean;

		private var picture : int;

		public function SystemSetDlg()
		{
			super();
		}

		override protected function init() : void
		{
			enableTween = true;
			isVisible = true;
			ico_hero.touchable = false;
			_closeButton = btn_close;
			addMask(btn_bgMusic);
			addMask(btn_effectMusic);
			//点击关闭界面
			clickBackroundClose();
			//版本号
			var ns : Namespace = NativeApplication.nativeApplication.applicationDescriptor.namespace();
			txt_version.text = NativeApplication.nativeApplication.applicationDescriptor.ns::versionNumber + "_" + ConfigData.data_version + "_" + ConfigData.main_version;
		}

		/**
		 * 给音效按钮添加遮罩
		 * @param child
		 *
		 */
		private function addMask(child : Button) : void
		{
			var sprite : Sprite = new Sprite();
			sprite.x = child.x;
			sprite.y = child.y;
			child.x = child.y = 0;
			sprite.addChild(child);
			sprite.clipRect = new Rectangle(0, 0, sprite.width, sprite.height);
			this.addChild(sprite);
		}

		/**
		 * 关闭打开按钮缓动
		 * @param child
		 * @param isOpen
		 *
		 */
		private function tweenTab(child : DisplayObject, isOpen : Boolean, onComplete : Function) : void
		{
			Starling.juggler.tween(child, 0.1, {x: isOpen ? 0 : -child.width * .5, onComplete: onComplete});
		}

		override protected function addListenerHandler() : void
		{
			super.addListenerHandler();
			btn_feed.addEventListener(Event.TRIGGERED, onFeedbackButtonClick);
			btn_out.addEventListener(Event.TRIGGERED, onLogoutButtonClick);
			btn_effectMusic.addEventListener(Event.TRIGGERED, onMusicEffectButtonEvent);
			btn_bgMusic.addEventListener(Event.TRIGGERED, onMusicButtonEvent);
			btn_change.addEventListener(Event.TRIGGERED, onGameHeroPhotoClick);
			addContextListener(EventType.UP_HEROPHOTO, updateHeroIco);
			addContextListener(EventType.UPDATE_VIP, updateVipStatus);
		}

		override protected function show() : void
		{
			setToCenter();
			isOpen_bg = !SoundManager.instance.getMusicState();
			isOpen_effect = !SoundManager.instance.getEffectState();
			onMusicEffectButtonEvent();
			onMusicButtonEvent();
			var gameMgr : GameMgr = GameMgr.instance;
			txt_power.text = HeroDataMgr.instance.getPower() + "";
			txt_name.text = gameMgr.arenaname;
			txt_tollgate.text = (gameMgr.tollgateID - 1) + "/" + TollgateData.tollgateCount;
			txt_herocount.text = HeroDataMgr.instance.hash.keys().length + "";
			txt_code.text = gameMgr.code + "";
			txt_rank.text = Langue.getLans("rankLevel")[gameMgr.rankLevel - 1];
			tag_rankLevel.texture = Res.instance.getRankPhoto(gameMgr.rankLevel);
			updateHeroIco(null, gameMgr.picture);
			updateVipStatus();
		}

		/**
		 * vip等级更新
		 *
		 */
		private function updateVipStatus() : void
		{
			txt_vip.text = GameMgr.instance.vip + "";
		}

		/**
		 * 更新玩家头像
		 * @param picture
		 *
		 */
		private function updateHeroIco(evt : Event, picture : int) : void
		{
			ico_hero.upState = Res.instance.getRolePhoto(picture); //人物头像
		}

		private function onMusicEffectButtonEvent(evt : Event = null) : void
		{
			if (isTween_effect)
				return;
			isTween_effect = true;
			isOpen_effect = !isOpen_effect;
			tweenTab(btn_effectMusic, isOpen_effect, onComplete);

			if (evt == null && SoundManager.instance.getEffectState() == isOpen_effect)
				return;
			SoundManager.instance.setEffectState(isOpen_effect);
			function onComplete() : void
			{
				isTween_effect = false;
			}
		}

		private function onMusicButtonEvent(evt : Event = null) : void
		{
			if (isTween_bg)
				return;
			isTween_bg = true;
			isOpen_bg = !isOpen_bg;
			tweenTab(btn_bgMusic, isOpen_bg, onComplete);

			if (evt == null && SoundManager.instance.getMusicState() == isOpen_bg)
				return;
			SoundManager.instance.setMusicState(isOpen_bg);
			function onComplete() : void
			{
				isTween_bg = false;
			}
		}

		/**
		 * 反馈
		 * @param e
		 *
		 */
		private function onFeedbackButtonClick(e : Event) : void
		{
			DialogMgr.instance.open(FeedBackDlg);
		}

		/**
		 * 更换头像
		 */
		private function onGameHeroPhotoClick(e : Event) : void
		{
			if (GameMgr.instance.tollgateID <= ConfigData.instance.arenaGuide)
			{
				RollTips.addNoOpenInfo(ConfigData.instance.arenaGuide);
				return;
			}
			else
			{
				DialogMgr.instance.open(GamePhotoDlg);
			}
		}

		/**
		 * 注销
		 *
		 */
		private function onLogoutButtonClick() : void
		{
			var tip : ResignDlg = DialogMgr.instance.open(ResignDlg) as ResignDlg;
			tip.text = getLangue("confirm");
			tip.onResign.addOnce(logout);
		}

		public static function logout() : void
		{
			AssetMgr.instance.enqueue(ConverURL.conver("loginUi/"));
			AssetMgr.instance.loadQueue(logoutComplement);
		}

		private static function logoutComplement(num : Number) : void
		{
			if (num == 1.0)
			{
				CityIcon.isInside = true;
				NewMainWorld.buy_tired = false;
				NewMainWorld.buy_goods = -1;
				ConnectMessage.isAutoLogin = false;
				TollgateData.reset();
				AccountManager.instance.loginOut();
				DataEyeManger.instance.loginOut();
				AchievementData.isFirstGuide = false;
				CityFace.isNewGuideInit = false;
				CityFace.isViewGuideInit = false;
				EmBattleDlg.seat_index = 0;
				NewMainWorld.curr_pos = -1;
				WinView.code = 0;
				WinView.achievementData = null;
				//如果缓存有保存用户文件，则删除该文件   , 清除缓存文件
				LocalShareManager.getInstance().cacheSaveData();
				Constants.userPwdMd5 = null;
				GlobalMessage.getInstance().clear();
				GameSocket.instance.close(true);
				GameMgr.instance.sign_reward = 0;
				GameMgr.instance.tollgateID = 1;
				DialogMgr.instance.closeAllDialog();
				JTChatControllerComponent.close();
				JTMessageHornComponent.close();
				JTMessageSystemComponent.close();
				JTSingleManager.clears();
				PopUpManager.removePopUps();
				ViewGuideManager.instance && ViewGuideManager.instance.dispose();
				NewGuide2Manager.instance && NewGuide2Manager.instance.dispose();
				SceneMgr.instance.changeScene(LoginScene);
			}
		}
	}
}