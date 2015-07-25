package com.webUtils
{
	import flash.external.ExternalInterface;

	public class CallJS
	{
		public function CallJS()
		{
		}


		public static function call(... arg):*
		{
			if (ExternalInterface.available)
			{
				try
				{
					return ExternalInterface.call.apply(null, arg);
				}
				catch (error:SecurityError)
				{

				}
			}
			return null;
		}
	}
}