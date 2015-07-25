package game.net.data.c
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class CColiseumRivalFightInfo extends DataBase
	{
		public var id : int;  
		public var type : int;  
		public var index : int;  
        public static const CMD : int=33025;
		
		public function CColiseumRivalFightInfo()
		{
		}
		
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			id=data.readInt();  
			type=data.readUnsignedByte();  
			index=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(id);  
            byte.writeByte(type);  
            byte.writeInt(index);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
