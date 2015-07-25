package com.mobileLib.utils
{
	import flash.system.Capabilities;

	public class DeviceType
	{
		public static const ITOUCH:String="itouch";
		public static const IPAD3:String="ipad3";
		public static const IPAD2:String="ipad2";
		public static const IPAD:String="ipad";
		public static const IPHONE:String="iphone";
		public static const IPHONE3:String="iphone3";
		public static const IPHONE4:String="iphone4";
		public static const ANDROID:String="linux";
		public static const DESKTOP:String="desktop";
		public static const MISC:String="misc";
		private static const MAC:String="mac";
		private static const WINDOWS:String="windows";

		private static var _type:String="";

        private static var _osType:String;
		public static function getType():String
		{
            if(_osType)
            {
                return _osType;
            }
			var _local1:String;
			var _local2:String;
			if (_type == "")
			{
				_local1=Capabilities.os;


				_local2=_local1.toLowerCase();
				if (_local2.indexOf(IPAD3) >= 0)
				{
					_type=IPAD3;
				}
				else
				{
					if (_local2.indexOf(IPAD2) >= 0)
					{
						_type=IPAD2;
					}
					else
					{
						if (_local2.indexOf(IPAD) >= 0)
						{
							_type=IPAD;
						}
						else
						{
							if (_local2.indexOf(IPHONE) >= 0)
							{
								if (Capabilities.screenDPI > 300)
								{
									_type=IPHONE4;
								}
								else
								{
									_type=IPHONE3;
								}
							}
							else
							{
								if (_local2.indexOf(ITOUCH) >= 0)
								{
									_type=ITOUCH;
								}
								else
								{
									if ((((_local2.indexOf(MAC) >= 0)) || ((_local2.indexOf(WINDOWS) >= 0))))
									{
										_type=DESKTOP;
									}
									else
									{
										_type=MISC;
									}
								}
							}
						}
					}
				}
			}
            _osType = _type;
			return (_osType);
		}

		public static function isIOS():Boolean
		{
			var _local1:String=getType();
			if (_local1 == IPAD3 || _local1 == IPAD2 || _local1 == IPAD || _local1 == IPHONE || _local1 == IPHONE3 || _local1 == IPHONE4 || _local1 == ITOUCH)
			{
				return (true);
			}
			return (false);
		}
	}
}
