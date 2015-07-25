package game.uils
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import game.common.JTLogger;
	import game.data.Val;

	public class LoaderManger
	{
		public function LoaderManger()
		{

		}

		public static function load(url : String, complement : Function, loadError : Function = null) : void
		{
			var urlLoader : URLLoader = new URLLoader();
			var load_count : int = 0;
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onIoError);
			urlLoader.addEventListener(Event.COMPLETE, onUrlLoaderComplete);
			urlLoader.load(new URLRequest(url));

			function onUrlLoaderComplete(evt : Event) : void
			{
				complement(urlLoader.data);
			}

			function onIoError(event : Event) : void
			{
				load_count++;

				if (load_count > 3)
				{
					loadError != null && loadError();
					return;
				}
				load(url, complement);
				JTLogger.warn("IO error: " + url);
			}
		}

		public static function loadImage(url : String, complement : Function) : void
		{
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDownLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onDownloadError);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onDownloadError);
			loader.load(new URLRequest(url));

			function onDownLoadComplete(evt : Event) : void
			{
				complement(evt.target.content);
			}

			function onDownloadError(event : Event) : void
			{
				loadImage(url, complement);
				JTLogger.warn("IO error: " + url);
			}
		}

		public static function startLoaderAndSave(server_url : String, tmp_list : Array, complement : Function, onReturnProgress : Function, onError : Function) : void
		{
			if (tmp_list.length == 0)
			{
				complement();
				return;
			}
			var index : int = 0;
			var file_name : String;
			var load_count : int = 0;
			var bytesLoaded : int;
			var len : int = tmp_list.length;
			var urlLoader : URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			urlLoader.addEventListener(Event.COMPLETE, onUrlLoaderComplete);

			startLoader();

			function startLoader() : void
			{
				bytesLoaded = 0;
				file_name = tmp_list[index];
				urlLoader.load(new URLRequest(server_url + file_name + "?v" + Math.random()));
			}

			function onUrlLoaderComplete(evt : Event) : void
			{
				index++;
				LoaderManger.save(file_name, evt.target.data);

				if (index == len)
				{
					onReturnProgress != null && onReturnProgress(101, 0, Val.close_app);
					complement();
				}
				else
				{
					load_count = 0;
					startLoader();
				}
			}

			function onProgress(evt : ProgressEvent) : void
			{
				var ratio : Number = evt.bytesLoaded / evt.bytesTotal;
				onReturnProgress != null && onReturnProgress(evt.bytesLoaded / evt.bytesTotal * 100, (evt.bytesLoaded - bytesLoaded) / 1024, "(" + (index + 1) + "/" + len + ")");
				bytesLoaded = evt.bytesLoaded;
			}

			function onIoError(event : IOErrorEvent) : void
			{
				load_count++;

				//加载失败
				if (load_count > 6)
				{
					onError != null && onError();
					return;
				}

				startLoader();
			}
		}

		public static function save(url : String, data : ByteArray) : void
		{
			url = File.applicationStorageDirectory.resolvePath(url).nativePath;
			var file : File = new File(url);
			var fileStream : FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeBytes(data, 0, data.length); //使包括汉字时不会有错 gb2123 为汉字编码
			fileStream.close();
			data.clear();
		}
	}
}