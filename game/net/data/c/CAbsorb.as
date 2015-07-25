package game.net.data.c
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class CAbsorb extends DataBase
	{
		public var heroid : int;  
		public var id1 : int;  
		public var id2 : int;  
		public var id3 : int;  
		public var id4 : int;  
        public static const CMD : int=14030;
		
		public function CAbsorb()
		{
		}
		
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			heroid=data.readInt();  
			id1=data.readInt();  
			id2=data.readInt();  
			id3=data.readInt();  
			id4=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(heroid);  
            byte.writeInt(id1);  
            byte.writeInt(id2);  
            byte.writeInt(id3);  
            byte.writeInt(id4);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
