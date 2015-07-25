package game.uils
{


	/**
	 * 客户端配置文件
	 * @author hyy
	 *
	 */
	public class Config
	{
		public static const windows : String = "windows";
		public static const ios : String = "ios";
		public static const android : String = "a_fun";
		public static const ios_91 : String = "i_91";
		public static const ios_tb : String = "i_tb";
		public static const android_wdj : String = "a_wdj";
		public static const android_91 : String = "a_91";
		public static const android_bd : String = "a_baidu";
		public static const android_uc : String = "a_uc";
		public static const android_xm : String = "a_xm";
		public static const android_kp : String = "a_kp";
		public static const android_huwei : String = "a_hw";
		public static const android_oppo : String = "a_oppo";
		public static const android_dl : String = "a_dl";
		public static const android_360 : String = "a_360";
		public static const android_lenovo : String = "a_lenovo";
		public static const android_pp : String = "i_pp";

		public static var device : String = "windows";
		public static var device_bar : Boolean;
		public static var isAutoLogin : Boolean;
		public static var isWarPass : Boolean;
		public static var isNewPass : Boolean;
		public static var checkUpdate : Boolean;

		/**
		 * 加载的swf地址
		 */
		public static var swf_type : String;

		/**
		 * 是否开放注册/登陆
		 */
		public static var isOpenLoginRegister : Boolean = false;

		public static function parseXml(xml : XML) : void
		{
			var ns : Namespace = xml.namespace();
			isAutoLogin = xml.ns::isAutoLogin == "true";
			isWarPass = xml.ns::isWarPass == "true";
			isNewPass = xml.ns::isNewPass == "true";
			checkUpdate = xml.ns::checkUpdate == "true";
			device_bar = xml.ns::device_bar == "true";
		}
	}
}