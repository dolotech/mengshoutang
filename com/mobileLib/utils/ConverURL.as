/**
 * Created with IntelliJ IDEA.
 * User: turbine
 * Date: 13-9-14
 * Time: 上午12:06
 * To change this template use File | Settings | File Templates.
 */
package com.mobileLib.utils
{
	import flash.filesystem.File;
	import flash.utils.Dictionary;

	import game.uils.Config;

	public class ConverURL
	{
		public static var down_url : String;
		public static var down_list : Array = [];
		public static var update_dic : Dictionary = new Dictionary();
		private static var _list : Object = {};

		public function ConverURL()
		{
		}

		public static function conver(url : String) : File
		{
			if (DeviceType.isIOS())
			{
				url = "assets_ios/" + url;
			}
			else if (DeviceType.getType() == DeviceType.DESKTOP)
			{
				url = "assets_ft/" + url;
			}
			else
			{
//				url = "assets_android/" + url;
				url = "assets_fun/" + url;
			}

			var file : File = _list[url];

			if (file)
			{
				return file;
			}
			file = File.applicationDirectory.resolvePath(url);
			_list[url] = file;

			return file
		}

		public static function getAssets(url : String) : String
		{
			switch (Config.device)
			{
				case Config.windows:
					url += "assets/";
					break;
				default:
					url += "assets_" + Config.device + "/";
					break;
			}
			return url;
		}
	}
}
