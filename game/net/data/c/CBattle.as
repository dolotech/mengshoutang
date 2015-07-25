package game.net.data.c
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class CBattle extends DataBase
	{
		public var type : int;  
		public var currentCheckPoint : int;  
		public var pos : int;  
        public static const CMD : int=22002;
		
		public function CBattle()
		{
		}
		
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			type=data.readUnsignedByte();  
			currentCheckPoint=data.readShort();  
			pos=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(type);  
            byte.writeShort(currentCheckPoint);  
            byte.writeByte(pos);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
