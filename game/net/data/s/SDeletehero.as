package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SDeletehero extends DataBase
	{
		public var heroes : Vector.<int>;  
        public static const CMD : int=14015;
		
		public function SDeletehero()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			heroes=readArrayInt();
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
			writeInts(heroes,byte);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
