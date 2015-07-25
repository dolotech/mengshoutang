package com.webUtils
{
	import flash.net.*;
	import flash.utils.ByteArray;
	import flash.external.ExternalInterface;

	/**
	 * 统一资源定位符 (Uniform Resource Locator, URL) 完整的URL由这几个部分构成：
	 * scheme://host:port/path?query#fragment
	 * PS：所有获取失败时返回null或""
	 */
	public class WebUtils
	{
		private static var regWebkit:RegExp=new RegExp("(webkit)[ \\/]([\\w.]+)", "i");

		/**
		 * 整个URl字符串 EX.：返回值：http://www.test.com:80/view.html?id=123#start
		 */
		public static function get Url():String
		{
			return getUrlParams("url");
		}

		/**
		 * 整个URl字符串 EX.：返回值：http://www.test.com:80/view.html?id=123#start
		 */
		public static function get Href():String
		{
			return getUrlParams("href");
		}

		/**
		 * 获取URL中的锚点（信息片断） EX.：返回值：#start
		 */
		public static function get Hash():String
		{
			return getUrlParams("hash");
		}

		/**
		 * URL 的端口部分。如果采用默认的80端口(PS:即使手动添加了:80)，那么返回值并不是默认的80而是空字符。
		 */
		public static function get Port():String
		{
			return (getUrlParams("port") ? getUrlParams("port") : "80");
		}

		/**
		 * URL 的路径部分(就是文件地址) EX.：返回值：/view.html
		 */
		public static function get PathAndName():String
		{
			return getUrlParams("PathAndName");
		}

		/**
		 * URL 的路径部分(就是文件地址) EX.：返回值：/view.html
		 */
		public static function get Pathname():String
		{
			return getUrlParams("pathname");
		}

		/**
		 * 查询(参数)部分。除了给动态语言赋值以外的参数 EX.：返回值：?id=123
		 */
		public static function get Search():String
		{
			return getUrlParams("search");
		}

		/**
		 * 查询(参数)部分。除了给动态语言赋值以外的参数 EX.：返回值：?id=123
		 */
		public static function get QueryString():String
		{
			return getUrlParams("query");
		}

		/**
		 * URL 的协议部分 EX.：返回值：http:、https:、ftp:、maito:等
		 */
		public static function get Protocol():String
		{
			return getUrlParams("protocol");
		}

		/**
		 * URL 的主机部分，EX.：返回值：www.test.com
		 */
		public static function get Host():String
		{
			return getUrlParams("host");
		}

		public static function Request(param:String):String
		{
			var returnValue:String;

			try
			{
				var query:String=QueryString.substr(1);
				var urlv:URLVariables=new URLVariables();
				urlv.decode(query);
				returnValue=urlv[param];
			}
			catch (error:Object)
			{
			}

			if (returnValue == null)
			{
				returnValue="";
			}
			return returnValue;
		}

		private static function getUrlParams(param:String):String
		{
			var returnValue:String;

			if (ExternalInterface.available)
			{
				switch (param)
				{
					case "PathAndName":
						returnValue=ExternalInterface.call("function getUrlParams(){return window.location.pathname;}");
						break;
					case "query":
						returnValue=ExternalInterface.call("function getUrlParams(){return window.location.search;}");
						break;
					case "url":
						returnValue=ExternalInterface.call("function getUrlParams(){return window.location.href;}");
						break;
					default:
						returnValue=ExternalInterface.call("function getUrlParams(){return window.location." + param + ";}");
						break;
				}
			}

			return (returnValue ? UrlDecode(returnValue) : "");
		}

		/**
		 * 获取浏览器信息
		 */
		public static function get BrowserAgent():String
		{
			var returnValue:String=ExternalInterface.call("function BrowserAgent(){return navigator.userAgent;}");
			return (returnValue ? returnValue : "");
		}

		/**
		 * 是否IE浏览器
		 */
		public static function get IsIE():Boolean
		{
			return (BrowserMatch().browser.toLowerCase() == "msie");
		}

		/**
		 * 是否FireFox浏览器
		 */
		public static function get IsMozilla():Boolean
		{
			return (BrowserMatch().browser.toLowerCase() == "mozilla");
		}

		/**
		 * 是否Safari浏览器
		 */
		public static function get IsSafari():Boolean
		{
			return regWebkit.test(BrowserAgent);
		}

		/**
		 * 是否Opera浏览器
		 */
		public static function get IsOpera():Boolean
		{
			return (BrowserMatch().browser.toLowerCase() == "opera");
		}

		/**
		 * 获取浏览器类型及对应的版本信息 EX.：BrowserMatch().browser  BrowserMatch().version
		 */
		public static function BrowserMatch():Object
		{
			var ua:String=BrowserAgent;
			var ropera:RegExp=new RegExp("(opera)(?:.*version)?[ \\/]([\\w.]+)", "i");
			var rmsie:RegExp=new RegExp("(msie) ([\\w.]+)", "i");
			var rmozilla:RegExp=new RegExp("(mozilla)(?:.*? rv:([\\w.]+))?", "i");

			var match:Object=regWebkit.exec(ua) || ropera.exec(ua) || rmsie.exec(ua) || ua.indexOf("compatible") < 0 && rmozilla.exec(ua) || [];

			return {browser: match[1] || "", version: match[2] || "0"}
		}

		/**
		 * 获取页面编码方式，EX.：返回值：GB2312、UTF-8等;
		 */
		public static function get PageEncoding():String
		{
			var returnValue:String=ExternalInterface.call("function PageEncoding(){return window.document.charset;}"); //IE

			if (returnValue == null)
			{
				returnValue=ExternalInterface.call("function PageEncoding(){return window.document.characterSet;}");
			} //FF

			//获取成功
			if (returnValue != null)
			{
				returnValue=returnValue.toUpperCase();
			}
			return (returnValue ? returnValue : "");
		}

		/**
		 * 通过js弹出浏览器提示alert，EX.：Alert("Test");
		 */
		public static function Alert(msg:String):void
		{
			navigateToURL(new URLRequest("javascript:alert('" + msg + "');"), "_self");
		}

		/**
		 * 通过js的open新窗口打开,（PS：多标签浏览器则新建一个标签打开）
		 */
		public static function Open(url:String):void
		{
			Eval("javascript:window.open('" + url + "','newwindow')");
		}

		/**
		 * URL重定向，使用replace函数，（PS：取消浏览器的前进后退,防止刷新回发数据）
		 */
		public static function Redirect(url:String):void
		{
			Eval("window.location.replace('" + url + "')");
		}

		/**
		 * URL重定向，使用内部navigateToURL函数，（PS：简化了不用每次都new URLRequest的操作）
		 */
		public static function NavigateToURL(url:String, target:String="_self"):void
		{
			navigateToURL(new URLRequest(url), target);
		}

		/**
		 * 运行js语句，eval
		 */
		public static function Eval(code:String):Object
		{
			var rtn:Object

			if (ExternalInterface.available)
			{
				rtn=ExternalInterface.call("eval", code + ";void(0);");
			}
			return rtn;
		}

		public static function refreshWeb():void
		{
			Eval("window.location.reload()");
		}

		/**
		 * URL编码，encoding为空时应用统一的UTF-8编码处理，可设"GB2312"、"UTF-8"等，（兼容性处理，对应JS中的escape）
		 */
		public static function UrlEncode(str:String, encoding:String=""):String
		{
			if (str == null || str == "")
			{
				return "";
			}

			if (encoding == null || encoding == "")
			{
				return encodeURI(str);
			}
			var returnValue:String="";
			var byte:ByteArray=new ByteArray();
			byte.writeMultiByte(str, encoding);

			for (var i:int; i < byte.length; i++)
			{
				returnValue+=escape(String.fromCharCode(byte[i]));
			}
			return returnValue;
		}

		/**
		 * URL解码，encoding为空时应用统一的UTF-8编码处理，可设"GB2312"、"UTF-8"等，（兼容性处理，对应JS中的unescape）
		 */
		public static function UrlDecode(str:String, encoding:String=""):String
		{
			if (str == null || str == "")
			{
				return "";
			}

			if (encoding == null || encoding == "")
			{
				return decodeURI(str);
			}
			var returnValue:String="";
			var byte:ByteArray=new ByteArray();
			byte.writeMultiByte(str, encoding);

			for (var i:int; i < byte.length; i++)
			{
				returnValue+=unescape(String.fromCharCode(byte[i]));
			}
			return returnValue;
		}


	}
}