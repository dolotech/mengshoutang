package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SColiseumInit extends DataBase
	{
		public var rank : int;  
		public var exp : int;  
		public var level : int;  
		public var wars : int;  
		public var chance : int;  
		public var cd : int;  
        public static const CMD : int=33004;
		
		public function SColiseumInit()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			rank=data.readInt();  
			exp=data.readInt();  
			level=data.readUnsignedByte();  
			wars=data.readUnsignedByte();  
			chance=data.readUnsignedByte();  
			cd=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(rank);  
            byte.writeInt(exp);  
            byte.writeByte(level);  
            byte.writeByte(wars);  
            byte.writeByte(chance);  
            byte.writeInt(cd);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
