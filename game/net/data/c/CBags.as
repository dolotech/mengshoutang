package game.net.data.c
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class CBags extends DataBase
	{
		public var type : int;  
		public var line : int;  
		public var tab : int;  
        public static const CMD : int=13027;
		
		public function CBags()
		{
		}
		
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			type=data.readUnsignedByte();  
			line=data.readUnsignedByte();  
			tab=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(type);  
            byte.writeByte(line);  
            byte.writeByte(tab);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
