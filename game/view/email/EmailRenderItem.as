package game.view.email
{
	import com.langue.Langue;

	import game.net.data.vo.mailItems;
	import game.net.message.MailMessage;
	import game.view.viewBase.EmailRenderItemBase;


	/**
	 * 邮件render
	 * @author hyy
	 *
	 */
	public class EmailRenderItem extends EmailRenderItemBase
	{
		private var rewardBox : EmailReward;

		public function EmailRenderItem()
		{
			super();
			read.visible = false;
			tag_normal.touchable = true;
			rewardBox = new EmailReward(box);
			this.addChildAt(rewardBox, 2);
		}

		override public function set data(value : Object) : void
		{
			super.data = value;
			var mail : MailData = value as MailData;

			if (mail == null)
				return;
			mail.parent = this;
			txt_name.text = mail.from == "@" ? Langue.getLangue("systemMrg") : mail.from;
			//剩余时间
			var time : int = mail.lastTime;
			var day : int = time / 3600 / 24;
			var hours : int = time / 3600;
			var minutes : int = Math.ceil(time / 60);
			var lastTime : String = Langue.getLangue("lave");
			lastTime += day > 0 ? day + Langue.getLangue("laveDay") : (hours > 0 ? hours + Langue.getLangue("laveHours") : minutes + Langue.getLangue("laveMinutes"))
			txt_time.text = lastTime;

			rewardBox.data = mail.items.length == 0 ? "1" : mail.items[0] as mailItems;
			onRead();
		}

		override public function set isSelected(value : Boolean) : void
		{
			var mail : MailData = data as MailData;

			if (mail && value)
			{
				var isRead : Boolean = mail.isRead;
				mail.isRead = true;

				//需要先设置成true，防止消息通知错过此条信息
				if (!isRead)
					MailMessage.updateNotice(mail.id);
				onRead();
			}
			tag_normal.visible = !value;
			tag_selected.visible = value;
			super.isSelected = value;
		}


		private function onRead() : void
		{
			read.visible = MailData(data).isRead;
			newMail.visible = !read.visible;
		}
	}
}