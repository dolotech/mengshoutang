package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SColiseumPrizeSend extends DataBase
	{
		public var diamond : int;  
		public var gold : int;  
		public var honor : int;  
        public static const CMD : int=33042;
		
		public function SColiseumPrizeSend()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			diamond=data.readInt();  
			gold=data.readInt();  
			honor=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(diamond);  
            byte.writeInt(gold);  
            byte.writeInt(honor);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
