package game.net.message
{
	import com.dialog.DialogMgr;
	import com.scene.SceneMgr;
	import com.view.base.event.EventType;

	import game.data.DiamondShopData;
	import game.data.FBCDData;
	import game.data.Val;
	import game.data.VipData;
	import game.data.WidgetData;
	import game.dialog.MsgDialog;
	import game.manager.GameMgr;
	import game.manager.HeroDataMgr;
	import game.net.data.IData;
	import game.net.data.c.CAllgoods;
	import game.net.data.c.CClientInfoStore;
	import game.net.data.c.CColiseumRegister;
	import game.net.data.c.CPayDouble;
	import game.net.data.c.CRolePictrue;
	import game.net.data.c.CSign;
	import game.net.data.c.CVipInfo;
	import game.net.data.c.CVipPrize;
	import game.net.data.s.SAllgoods;
	import game.net.data.s.SClientInfoStore;
	import game.net.data.s.SColiseumRegister;
	import game.net.data.s.SCreate_role;
	import game.net.data.s.SDiamondshop;
	import game.net.data.s.SGet_all_hero;
	import game.net.data.s.SGet_game_data;
	import game.net.data.s.SGet_tired;
	import game.net.data.s.SNewNotice;
	import game.net.data.s.SPayDouble;
	import game.net.data.s.SRetrieveAllData;
	import game.net.data.s.SRolePictrue;
	import game.net.data.s.SSendFunData;
	import game.net.data.s.SSend_sign;
	import game.net.data.s.SSign;
	import game.net.data.s.SVipInfo;
	import game.net.data.s.SVipPrize;
	import game.net.data.s.SVipSend;
	import game.net.data.s.SXYLMLogin;
	import game.net.data.vo.SignState;
	import game.net.message.base.Message;
	import game.uils.LocalShareManager;
	import game.view.PVP.JTPvpComponent;
	import game.view.arena.ArenaCreateNameDlg;
	import game.view.city.CityFace;
	import game.view.dispark.DisparkControl;
	import game.view.loginReward.Dla.LoginRewardDlg;
	import game.view.new2Guide.NewGuide2Manager;


	public class RoleInfomationMessage extends Message
	{
		private static var sendMessageList : Array = [];
		public static var my_photo_id : int = -1;
		private var isCreate : int;

		/**
		 * 角色信息
		 *
		 */
		public function RoleInfomationMessage()
		{
			super();
		}

		override protected function addListenerHandler() : void
		{
			addHandler(SGet_tired.CMD, updateTiredNocification)
			addHandler(SSend_sign.CMD, updateSignNocification)
			addHandler(SNewNotice.CMD, updateNoticeNotify)
			addHandler(SRolePictrue.CMD, updateHeroPhotoList)
			addHandler(SClientInfoStore.CMD, getUserInfoNotify)
			addHandler(SVipInfo.CMD, vipInfoNotify)
			addHandler(SVipSend.CMD, sendGetVipInfo)
			addHandler(SVipPrize.CMD, sendGetVipReward)
			addHandler(CColiseumRegister.CMD, arenaRegisterNotify)
			addHandler(SDiamondshop.CMD, diamondshopNotify)
			addHandler(EventType.CONNNECT, onConnected);
			addHandler(SGet_game_data.CMD, getGameBaseINfoNotify);
			addHandler(SRetrieveAllData.CMD, retrieveAllDataNotify);
			addHandler(SXYLMLogin.CMD, loginNotification);
			addHandler(SCreate_role.CMD, onCreateRoleNofiy);
			addHandler(SAllgoods.CMD, onAllgoodsNofity);
			addHandler(SGet_all_hero.CMD, onGetAllHeroNotify);
			addHandler(SPayDouble.CMD, diamondDoubleNotify);
			addHandler(SSign.CMD, onSingNotify);
			addHandler(SSendFunData.CMD, onSendFunNotify);
		}


		private function onConnected() : void
		{
			my_photo_id = -1;
			sendGetAllGoods();
		}

		/**
		 * 请求玩家所有物品
		 *
		 */
		public static function sendGetAllGoods() : void
		{
			var cmd : CAllgoods = new CAllgoods();
			cmd.type = 1;
			sendMessage(cmd);
		}

		/**
		 * 玩家所有英雄信息
		 * @param info
		 *
		 */
		private function onGetAllHeroNotify(info : SGet_all_hero) : void
		{
			HeroDataMgr.instance.init(info.heroes);
		}

		/**
		 * 获得玩家所有物品
		 * @param info
		 *
		 */
		private function onAllgoodsNofity(info : SAllgoods) : void
		{
			if (info.type != 1)
				return;
			var equip : Vector.<IData> = info.equip;
			var props : Vector.<IData> = info.props;
			WidgetData.createProps(props);
			WidgetData.createEquip(equip);
		}

		/**
		 * 创建角色
		 * @param info
		 *
		 */
		private function onCreateRoleNofiy(info : SCreate_role) : void
		{
			if (info.state == 0)
				addTips("createSuccess"); //恭喜成功创建角色
			else
				addTips("exist_Name"); //名字已存在
		}

		private function loginNotification(info : SXYLMLogin) : void
		{
			isCreate = info.progress;
		}

		private function retrieveAllDataNotify(info : SRetrieveAllData) : void
		{
			if (isCreate >= 2)
			{
				addTips("loginSuccess"); //  登陆成功
				DialogMgr.instance.closeAllDialog();
				SceneMgr.instance.changeScene(CityFace);
			}
			else if (isCreate == 1)
			{
				ConnectMessage.sendCreateRole();
				SceneMgr.instance.changeScene(CityFace);
			}
			Message.sendMessage(new CSign()); //请求签到数据
			TaskMessage.requestTask(); //请求任务
		}

		private function getGameBaseINfoNotify(gameData : SGet_game_data) : void
		{
			GameMgr.instance.diamond = gameData.diamond;
			GameMgr.instance.coin = gameData.coin;
			GameMgr.instance.tollgateID = gameData.tollgateid;
			GameMgr.instance.bagequ = gameData.bagequ;
			GameMgr.instance.bagmat = gameData.bagmat;
			GameMgr.instance.bagprop = gameData.bagprop;
			GameMgr.instance.arenaname = gameData.arenaname;
			GameMgr.instance.picture = gameData.picture;
			GameMgr.instance.star = gameData.lucknum;
			GameMgr.instance.horn = gameData.horn; //喇叭
			GameMgr.instance.chatTime = gameData.chattime;
			GameMgr.instance.tired = gameData.tired;
			GameMgr.instance.rankLevel = gameData.level;
			GameMgr.instance.code = gameData.verify;
			GameMgr.instance.hero_gridCount = gameData.herotab;
			GameMgr.instance.vip = gameData.viplev;
			GameMgr.instance.firstpay = gameData.firstpay;
			GameMgr.instance.tollgateprize = gameData.tollgateprize;
			GameMgr.instance.vipData.baseVip = VipData.list[GameMgr.instance.vip];
		}

		/**
		 * 删除，或者储存玩家数据
		 * @param key
		 * @param value
		 *
		 */
		public static function sendeSaveRoleInfo(key : int, value : String = null) : void
		{
			var info : CClientInfoStore = new CClientInfoStore();
			//type=1(存储),=2(获取),=3(删除)
			info.type = value ? 1 : 3;
			info.key = key;
			info.value = value ? value : "";
			sendMessage(info);
			sendMessageList.push(key);
		}

		/**
		 * 请求获得玩家数据
		 * @param key
		 *
		 */
		public static function sendeGetSaveRoleInfo(key : int) : void
		{
			var info : CClientInfoStore = new CClientInfoStore();
			//type=1(存储),=2(获取),=3(删除)
			info.type = 2;
			info.key = key;
			info.value = "";
			sendMessage(info, false);
			sendMessageList.push(key);
		}

		private function getUserInfoNotify(info : SClientInfoStore) : void
		{
			switch (sendMessageList.shift())
			{
				case Val.PASS_FB:
					if (info.custom)
					{
						FBCDData.updatePassFbList(info.custom.split(","));
						dispatch(EventType.UPDATE_PASS_FB);
					}
					break;

			}
		}

		/**
		 * 请求后台更换头像
		 */
		public static function sendeHeroPhoto(photo_id : int) : void
		{
			if (photo_id == 0 || my_photo_id >= 0)
				return;
			my_photo_id = photo_id;
			var crole : CRolePictrue = new CRolePictrue();
			crole.id = photo_id;
			sendMessage(crole);
		}

		/**
		 * 成功更换头像,就派发事件过去更新排行榜的头像
		 */
		private function updateHeroPhotoList(info : SRolePictrue) : void
		{
			switch (info.code)
			{
				case 0:
					addTips("replaceAvatarSuccess");
					GameMgr.instance.picture = my_photo_id;
					this.dispatch(EventType.UP_HEROPHOTO, my_photo_id);
					break;
				case 1:
					addTips("ArenaToContinueTheGame");
					break;
				case 127:
					addTips("operatorError");
					break;
			}
			my_photo_id = -1;
		}

		/**
		 * 公告通知
		 * @param info
		 *
		 */
		private function updateNoticeNotify(info : SNewNotice) : void
		{
			GameMgr.instance.hasNotice = true;
		}

		/**
		 * 登陆奖励
		 * @param evt
		 * @param info
		 *
		 */
		private function updateSignNocification(info : SSend_sign) : void
		{
			GameMgr.instance.sign_reward = info.code;
		}

		/**
		 * 疲劳
		 * @param evt
		 * @param info
		 *
		 */
		private function updateTiredNocification(info : SGet_tired) : void
		{
			GoodsMessage.buy_tired_count = info.num;
			GameMgr.instance.tired = info.tired;
			GameMgr.instance.time = info.time;
			this.dispatch(EventType.UPDATE_TIRED);
		}

		/**
		 * 请求VIP信息
		 *
		 */
		public static function sendGetVipInfo() : void
		{
			var cmd : CVipInfo = new CVipInfo();
			sendMessage(cmd, false);
		}

		private function vipInfoNotify(info : SVipInfo) : void
		{
			if (GameMgr.instance.vip != info.lev && info.lev > 0)
				addTips(getLangue("upgrade_vip").replace("*", info.lev));
			GameMgr.instance.vip = info.lev;
			var vipData : VipData = GameMgr.instance.vipData;
			vipData.tired_buy = info.tired;
			vipData.jingji_buy = info.coli_buy;
			vipData.fb_buy = info.fb_buy;
			vipData.diamond = info.diamond;
			vipData.id = info.lev;
			vipData.free = info.free;
			vipData.chat = info.chattime;
			vipData.dayPrize = info.prize;
			vipData.fast = info.fast;
			vipData.baseVip = VipData.list[info.lev];
			GameMgr.instance.chatTime = vipData.baseVip.chat;
			this.dispatch(EventType.UPDATE_VIP, vipData);
		}

		/**
		 * 请求领取VIP特权礼包
		 *
		 */
		public static function sendGetVipReward() : void
		{
			var cmd : CVipPrize = new CVipPrize();
			sendMessage(cmd);
		}

		private function sendGetVipReward(info : SVipPrize) : void
		{
			switch (info.code)
			{
				case 0:
					addTips("signRewardSucceed");
					break;
				case 1:
					addTips("alreadyUse");
					break;
				case 3:
					addTips("packFulls");
					break;
				case 127:
					addTips("codeError");
					break;
			}
			sendGetVipInfo();
		}

		/**
		 * 注册竞技场
		 * @param name
		 * @param picture
		 *
		 */
		public static function sendArenaRegister(name : String, picture : int) : void
		{
			var cmd : CColiseumRegister = new CColiseumRegister;
			GameMgr.instance.arenaname = cmd.name = name;
			GameMgr.instance.picture = cmd.picture = picture;
			sendMessage(cmd);
		}

		private function arenaRegisterNotify(info : SColiseumRegister) : void
		{
			switch (info.code)
			{
				case 0:
					DialogMgr.instance.closeDialog(ArenaCreateNameDlg);
					JTPvpComponent.open();
					this.dispatch(EventType.UP_HEROPHOTO);
					break;
				case 1:
					addTips("nameUse");
					break;
				default:
					addTips(getLangue("codeError") + info.code);
					break;
			}

			if (info.code != 0)
			{
				GameMgr.instance.arenaname = "";
				GameMgr.instance.picture = 0;
			}
		}

		public static var buyDiamondSuccess : Boolean = false;

		private function diamondshopNotify(info : SDiamondshop) : void
		{
			if (info.code == 0)
			{
				LocalShareManager.getInstance().clear(LocalShareManager.CHARGE);
				buyDiamondSuccess = true;
			}
			else if (info.code == 1)
			{
				LocalShareManager.getInstance().clear(LocalShareManager.CHARGE);
			}
			else
			{
				DialogMgr.instance.open(MsgDialog, getLangue("buyDiamondFail"));
			}
		}

		/**
		 * 请求充值双倍信息
		 * @param info
		 *
		 */
		public static function sendDiamondDouble() : void
		{
			var cmd : CPayDouble = new CPayDouble();
			sendMessage(cmd);
		}

		private function diamondDoubleNotify(info : SPayDouble) : void
		{
			var len : int = info.doubleids.length;

			for (var i : int = 0; i < len; i++)
			{
				if (DiamondShopData.list[i])
					DiamondShopData.list[i].double = info.doubleids[i];
			}
			this.dispatch(EventType.UPDATE_DIAMOND_DOUBLE);
		}

		/**签到信息*/
		private function onSingNotify(info : SSign) : void
		{
			var daysLen : int = info.days.length;
			var signSate : SignState = null;

			for (var i : int = 0; i < daysLen; i++)
			{
				signSate = info.days[i] as SignState;

				if (signSate.state == 1 && NewGuide2Manager.instance == null)
				{
					DialogMgr.instance.open(LoginRewardDlg, info);
					break;
				}
			}
		}

		/**功能开放状态列表*/
		private function onSendFunNotify(info : SSendFunData) : void
		{
			DisparkControl.instance.changeStatues(info.list);
		}


	}
}


