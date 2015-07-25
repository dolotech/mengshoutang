package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SVideoInfo extends DataBase
	{
		public var heroes : Vector.<IData>;  
		public var videoData : Vector.<IData>;  
        public static const CMD : int=34020;
		
		public function SVideoInfo()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			heroes=readObjectArray(videoHeroes);  
			videoData=readObjectArray(videoDataInfo);  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            writeObjects(heroes,byte);  
            writeObjects(videoData,byte);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
