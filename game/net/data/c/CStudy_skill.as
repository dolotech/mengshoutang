package game.net.data.c
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class CStudy_skill extends DataBase
	{
		public var widgetid : int;  
		public var heroid : int;  
		public var seat : int;  
        public static const CMD : int=14005;
		
		public function CStudy_skill()
		{
		}
		
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			widgetid=data.readInt();  
			heroid=data.readInt();  
			seat=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(widgetid);  
            byte.writeInt(heroid);  
            byte.writeByte(seat);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
