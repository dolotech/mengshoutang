package game.net.data.c
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class CColiseumChance extends DataBase
	{
        public static const CMD : int=33024;
		
		public function CColiseumChance()
		{
		}
		
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
