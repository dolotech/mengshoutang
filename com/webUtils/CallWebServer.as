package com.webUtils
{

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	/**
	 * 呼叫web服务器
	 * @author Michael
	 */
	public class CallWebServer
	{
		private var _callbackFun:Function;
		private var _url:String;

		public function CallWebServer(url:String, callbackFun:Function=null, ispost:Boolean=false, postData:Object=null)
		{
			_callbackFun=callbackFun;
			_url=url;

			var urlRequest:URLRequest=new URLRequest(url);
			var loader:URLLoader=new URLLoader();
			if (ispost)
			{
				urlRequest.method=URLRequestMethod.POST;
			}

			if (postData)
			{
				urlRequest.data=postData;
			}

			loader.addEventListener(Event.COMPLETE, requestCompleteHdr);
			loader.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);

			loader.load(urlRequest);
		}

		protected function IOErrorHandler(e:IOErrorEvent):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
		}

		private function requestCompleteHdr(e:Event):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);

			var loader:URLLoader=e.currentTarget as URLLoader;
			var obj:Object=JSON.parse(loader.data as String);
			if (_callbackFun != null)
			{
				_callbackFun.call(null, obj);
			}
		}

		public static function call(url:String, callbackFun:Function=null, ispost:Boolean=false, postData:Object=null):CallWebServer
		{
			return new CallWebServer(url, callbackFun, ispost, postData);
		}
	}
}