package game.view.email
{
	import flash.utils.getTimer;

	import game.net.data.IData;

	public class MailData
	{
		public var parent : EmailRenderItem;
		public var id : int;
		public var from : String;
		public var content : String;
		public var time : int;
		//接受邮件的事件，用于计算真实剩余时间
		public var getTime : int;
		public var isRead : Boolean;
		public var isGet : Boolean;
		public var items : Vector.<IData>;

		/**
		 * 获得真实剩余事件
		 * @return
		 *
		 */
		public function get lastTime() : int
		{
			return time - (getTimer() - getTime) / 1000;
		}
	}
}