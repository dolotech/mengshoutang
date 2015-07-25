package game.uils
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * http网络请求工具
	 * @author lzm
	 */
	public class HttpClient
	{
		/**
		 * 请求url
		 * @param url
		 * @param params
		 * @param completeFunction
		 * @param method
		 *
		 */
		public static function send(url : String, params : Object, completeFunction : Function = null, timeoutFunction : Function = null, method : String = "get") : void
		{
			var request : URLRequest;

			if (method == "get")
			{
				request = getRequest(url, params);
			}
			else if (method == "post")
			{
				request = postRequest(url, params);
			}

			var loader : URLLoader = new URLLoader();

			var callback : Function = function(e : Event) : void
				{
					removeListener();
					completeFunction != null && completeFunction(loader.data);
				};

			var timeout : Function = function(e : Event) : void
				{
					removeListener();
					timeoutFunction != null && timeoutFunction(loader.data);
				};


			function removeListener() : void
			{
				loader.removeEventListener(Event.COMPLETE, callback);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, timeout);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, timeout);
			}
			loader.addEventListener(Event.COMPLETE, callback);
			loader.addEventListener(IOErrorEvent.IO_ERROR, timeout);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, timeout);
			loader.load(request);
		}


		private static function getRequest(url : String, params : Object) : URLRequest
		{
			url += "?"
			var k : String;

			for (k in params)
			{
				url += k + "=" + params[k] + "&";
			}
			return new URLRequest(url.substring(0, url.length - 1));
		}

		private static function postRequest(url : String, params : Object) : URLRequest
		{
			var data : URLVariables = new URLVariables();
			var k : String;

			for (k in params)
			{
				data[k] = params[k];
			}
			var request : URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			request.data = data;
			return request;
		}
	}
}