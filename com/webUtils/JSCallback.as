package com.webUtils
{
	import flash.external.ExternalInterface;

	/**
	 * 给js调用的接口
	 * @author Michael
	 */
	public class JSCallback
	{

		private static var MAP:Object={}

		public static function call(... arg):void
		{

			if (arg)
			{
				var functionName:String=arg.shift();
				var obj:*=MAP[functionName];

				if (obj != null && obj != undefined)
				{
					var fun:Function=obj as Function;
					fun.apply(null, arg);
				}
			}

		}

		public static function add(functionName:String, fun:Function):void
		{
			if (!MAP[functionName])
			{
				MAP[functionName]=fun;
			}

			if (fun == null)
			{
				MAP[functionName]=null;
			}
		}

		public static function init():void
		{
			if (ExternalInterface.available)
			{
				try
				{
					ExternalInterface.addCallback("callAS", JSCallback.call);
				}
				catch (error:SecurityError)
				{

				}
			}
		}

	}

}