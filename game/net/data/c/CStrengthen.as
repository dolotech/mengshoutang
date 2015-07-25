package game.net.data.c
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class CStrengthen extends DataBase
	{
		public var equid : int;  
		public var enId1 : int;  
		public var enId2 : int;  
		public var enId3 : int;  
		public var pay : int;  
        public static const CMD : int=13005;
		
		public function CStrengthen()
		{
		}
		
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			equid=data.readInt();  
			enId1=data.readInt();  
			enId2=data.readInt();  
			enId3=data.readInt();  
			pay=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(equid);  
            byte.writeInt(enId1);  
            byte.writeInt(enId2);  
            byte.writeInt(enId3);  
            byte.writeByte(pay);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
