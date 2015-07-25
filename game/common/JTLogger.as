package game.common
{
	import flash.system.Capabilities;
	
	
	/**
	 * 
	 * @author CabbageWrom
	 *  
	 * 
	 */
	
	final public class JTLogger
	{
		private static const LOGGER_TYPE_INFO:String = "[Info]:";
		private static const LOGGER_TYPE_DEBUG:String = "[Debug]:";
		private static const LOGGER_TYPE_ERROR:String = "[Error]:";
		private static const LOGGER_TYPE_ASSET:String = "[Asset]:";
		private static const LOGGER_TYPE_WARN:String = "[Warn]";
		
		/**
		 * 
		 * @param msg 输出日志信息
		 * 
		 */		
		public static function info(...msg):void
		{
			logger(LOGGER_TYPE_INFO, msg);
		}
		
		/**
		 * 
		 * @param msg 输出调试信息的
		 * 
		 */		
		public static function debug(...msg):void
		{
			logger(LOGGER_TYPE_DEBUG, msg);
		}
		
		/**
		 * 
		 * @param msg 输出错误信息的
		 * a
		 */		
		public static function error(...msg):void
		{
			logger(LOGGER_TYPE_ERROR, msg);
			throw new Error(LOGGER_TYPE_ERROR, msg);
		}
		
		/**
		 * 
		 * @param msg  输出警告错误信息的.
		 * 
		 */		
		public static function warn(...msg):void
		{
			logger(LOGGER_TYPE_WARN, msg);
		}
		
		/**
		 * 
		 * @param msg 输出资源信息的
		 * 
		 */		
		public static function asset(isflag:Boolean, ...msg):void
		{
			if (!isflag)
			{
				return;
			}
		}
		
		private static function logger(loggerType:String, msgList:Array):void
		{
			if (!Capabilities.isDebugger)
			{
				return;
			}
			if (msgList.length == 0)
			{
				error("[Sorry, print logger not Empty!]")
			}
			var loggerDate:Date = new Date();
			var loggerYear:int = loggerDate.getFullYear();
			var loggerMonth:int = loggerDate.getMonth();
			var loggerDay:int = loggerDate.getDay();
			var loggerHours:int = loggerDate.getHours();
			var loggerMinutes:int = loggerDate.getMinutes();
			var loggerSeconds:int = loggerDate.getSeconds();
			var loggerTime:String = "" + loggerYear + "-" + loggerMonth + "-" + loggerDay + "|"
				+ loggerHours + ":" + loggerMinutes + ":" + loggerSeconds;
			var loggerProperty:String = "";
			for each (var value:String in msgList)
			{
				loggerProperty += "" + value;
			}
			var loggerMsg:String = loggerType + loggerProperty;
			trace(loggerMsg);
			/*if (JTApplicationPreloader.is_internet)
				JTApplicationPreloader.msg.appendText(loggerMsg + "\n");*/
		}
	}
}
