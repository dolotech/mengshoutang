package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SColiseumChance extends DataBase
	{
		public var code : int;  
		public var num : int;  
		public var wars : int;  
        public static const CMD : int=33024;
		
		public function SColiseumChance()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			code=data.readUnsignedByte();  
			num=data.readUnsignedByte();  
			wars=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(code);  
            byte.writeByte(num);  
            byte.writeInt(wars);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
