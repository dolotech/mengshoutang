package sdk
{
	import com.utils.Constants;
	
	import flash.events.RemoteNotificationEvent;
	import flash.notifications.NotificationStyle;
	import flash.notifications.RemoteNotifier;
	import flash.notifications.RemoteNotifierSubscribeOptions;
	
	import game.uils.HttpClient;

	public class PushNotifications
	{
		private var notiStyles : Vector.<String> = new Vector.<String>;
		private var subscribeOptions : RemoteNotifierSubscribeOptions = new RemoteNotifierSubscribeOptions;
		private var preferredStyles : Vector.<String> = new Vector.<String>;
		private var remoteNot : RemoteNotifier = new RemoteNotifier;
		private var send_count : int = 0;
		private static var instance : PushNotifications;

		public static function getInstance() : PushNotifications
		{
			if (instance == null)
				instance = new PushNotifications();
			return instance;
		}

		public function start() : void
		{
			preferredStyles.push(NotificationStyle.ALERT, NotificationStyle.BADGE, NotificationStyle.SOUND);
			subscribeOptions.notificationStyles = preferredStyles;
			remoteNot.addEventListener(RemoteNotificationEvent.TOKEN, tokenHandler);
			//订阅推送;
			remoteNot.subscribe(subscribeOptions);
		}

		public function tokenHandler(e : RemoteNotificationEvent) : void
		{
			sendPushMsg();

			function sendPushMsg(value : Object = null) : void
			{
				if (send_count >= 2)
					return;
				send_count++;
				var data : Object = {};
				data.pid = e.tokenId;
				data.sid = Constants.SID;
				data.rid = Constants.username;
				HttpClient.send("http://szturbotech.com/push/", data, null, sendPushMsg);
			}
		}
	}
}