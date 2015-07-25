package game.net.data.c
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class CFeedback extends DataBase
	{
		public var type : int;  
		public var content : String;  
        public static const CMD : int=10010;
		
		public function CFeedback()
		{
		}
		
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			type=data.readUnsignedByte();  
			content=data.readUTF();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(type);  
            byte.writeUTF(content);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
