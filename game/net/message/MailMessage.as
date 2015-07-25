package game.net.message
{
	import com.data.Data;
	import com.dialog.DialogMgr;
	import com.utils.ArrayUtil;
	import com.view.base.event.EventType;
	
	import flash.utils.getTimer;
	
	import game.dialog.ShowLoader;
	import game.net.data.c.CDeleteMail;
	import game.net.data.c.CGetMailItems;
	import game.net.data.c.CMailList;
	import game.net.data.s.SDeleteMail;
	import game.net.data.s.SGetMailItems;
	import game.net.data.s.SMailList;
	import game.net.data.s.SMailNotice;
	import game.net.data.vo.newMail;
	import game.net.message.base.Message;
	import game.uils.LocalShareManager;
	import game.view.email.EmailDlg;
	import game.view.email.MailData;

	/**
	 * 邮件全局事件
	 * @author Administrator
	 *
	 */
	public class MailMessage extends Message
	{
		public static const UPDATE_MAIL_LIST : String = "m1";
		public static const NOTICE_MAIL : String = "m2";
		public static const SELECT_MAIL : String = "m3";
		/**
		 * 是否请求了邮件列表
		 */
		private static var isGetServerData : Boolean;
		public static var isNotice : Boolean; //是否有新邮件
		private static var deleteId : int = 0;
		private static var maxId : int; //邮件最大ID
		private static var sendsId : Array = []; //邮件最大ID
		private static var emails : Array = [];
		private static var receiveList : Array;

		public function MailMessage()
		{
			super();
		}

		override protected function addListenerHandler() : void
		{
			this.addHandler(SMailList.CMD, onGetMailList);
			this.addHandler(SMailNotice.CMD, onGetMailNotice);
			this.addHandler(SGetMailItems.CMD, onGetMailItems);
			this.addHandler(SDeleteMail.CMD, onGetMailDelete);
			this.addHandler(EventType.CONNNECT, onConnected);
		}

		private function onConnected() : void
		{
			deleteId = 0;
		}

		/**
		 * 邮件列表
		 * @param info
		 *
		 */
		private function onGetMailList(info : SMailList) : void
		{
			getReceiveList();
			var newmail : newMail;
			var mailData : MailData;
			var time : int = getTimer();

			for (var i : int = info.mail.length - 1; i >= 0; i--)
			{
				newmail = info.mail[i] as newMail;

				if (newmail.id > maxId)
					maxId = newmail.id;

				if (sendsId.indexOf(newmail.id) >= 0 || newmail.time < 0)
					continue;
				mailData = new MailData();
				mailData.getTime = time;
				Data.readObject(mailData, newmail);
				mailData.isRead = receiveList.indexOf(mailData.id + "") >= 0;
				emails.push(mailData);
				sendsId.push(mailData.id);
			}
			emails.sortOn(["isRead", "lastTime"], [0, Array.DESCENDING]);
			updateView();
		}



		private function onGetMailNotice(info : SMailNotice) : void
		{
			isGetServerData = false;
			sendMailList();
		}

		/**
		 * 收取附件
		 * @param data
		 *
		 */
		private function onGetMailItems(info : SGetMailItems) : void
		{
			if (info.code == 0)
			{
				clearMailList();
				addTips("signRewardSucceed");
			}
			else if (info.code == 1)
			{
				deleteId = 0;
				addTips("getLose");
			}
			else if (info.code == 3)
			{
				var mailData : MailData = ArrayUtil.getArrayObjByField(emails, deleteId, "id") as MailData;
				deleteId = 0;

				if (mailData && ArrayUtil.getArrayObjByField(mailData.items, 5, "type"))
					addTips("MaxHero");
				else
					addTips("clearPack");
			}
		}

		/**
		 * 删除邮件
		 * @param info
		 *
		 */
		private function onGetMailDelete(info : SDeleteMail) : void
		{
			if (info.code == 0)
			{
				clearMailList();
				addTips("deleteSuccess");
			}
			else if (info.code == 1)
			{
				addTips("ExpiredMail");
			}
		}

		//从邮件列表中删除一个
		private function clearMailList() : void
		{
			if (deleteId == 0)
				return;
			ArrayUtil.deleteArrayByField(emails, deleteId, "id");
			ArrayUtil.deleteArrayByField(sendsId, deleteId);
			ArrayUtil.deleteArrayByField(receiveList, deleteId);
			deleteId = 0;
			updateView();
			this.dispatch(SELECT_MAIL);
		}

		/**
		 * 更新界面
		 *
		 */
		private function updateView() : void
		{
			updateNotice();
			dispatch(UPDATE_MAIL_LIST, emails);
			ShowLoader.remove();
		}

		/**
		 * 是否播放提示动画
		 *
		 */
		public static function updateNotice(id : int = -1) : void
		{
			isNotice = false;
			var mailData : MailData;

			for (var i : int = emails.length - 1; i >= 0; i--)
			{
				mailData = emails[i] as MailData;

				if (!mailData.isRead)
					isNotice = true;
			}

			if (id != -1)
				ArrayUtil.addArray(receiveList, id);
			dispatch(NOTICE_MAIL, isNotice);
		}

		/**
		 *  请求邮件列表
		 *
		 */
		public static function sendMailList() : void
		{
			if (isGetServerData)
			{
				emails.sortOn(["isRead", "lastTime"], [0, Array.DESCENDING]);
				dispatch(UPDATE_MAIL_LIST, emails);
				return;
			}

			if (DialogMgr.instance.isShow(EmailDlg))
				showLoader(CMailList.CMD);
			var cmd : CMailList = new CMailList;
			cmd.maxId = maxId;
			sendMessage(cmd, false);
			isGetServerData = true;
		}

		/**
		 * 请求删除邮件
		 * @param id
		 *
		 */
		public static function sendDeleteMail(id : int) : void
		{
			if (deleteId != 0)
				return;
			var cmd : CDeleteMail = new CDeleteMail;
			deleteId = cmd.id = id;
			sendMessage(cmd);
		}

		public static function getReceiveList() : Array
		{
			if (receiveList == null)
			{
				var abc : String = LocalShareManager.getInstance().get("mail");

				if (abc)
					receiveList = String(abc).split(",");
			}

			if (receiveList == null)
				receiveList = [];
			return receiveList;
		}

		public static function savetReceiveList() : void
		{
			if (receiveList != null)
				LocalShareManager.getInstance().save("mail", receiveList.join(","));
		}

		/**
		 * 请求获取附件
		 * @param id
		 *
		 */
		public static function sendGetMailItmes(id : int) : void
		{
			if (deleteId != 0)
				return;
			var cmd : CGetMailItems = new CGetMailItems;
			deleteId = cmd.id = id;
			sendMessage(cmd);
		}

		/**
		 * 清理缓存时处理
		 *
		 */
		override public function clear() : void
		{
			isGetServerData = false;
			isNotice = false;
			deleteId = 0;
			maxId = 0;
			emails.length = 0;
			sendsId.length = 0;

			if (receiveList)
				receiveList.length = 0;
			receiveList = null;
		}
	}
}