package game.net.data.c
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class CArena_init extends DataBase
	{
        public static const CMD : int=23004;
		
		public function CArena_init()
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
