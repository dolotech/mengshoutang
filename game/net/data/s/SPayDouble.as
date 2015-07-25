package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SPayDouble extends DataBase
	{
		public var doubleids : Vector.<int>;  
        public static const CMD : int=25046;
		
		public function SPayDouble()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			doubleids=readArrayInt();
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
			writeInts(doubleids,byte);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
