package game.net.data.c
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class COversellMagicOrbs extends DataBase
	{
		public var tab : int;  
		public var ids : Vector.<IData>;  
        public static const CMD : int=13032;
		
		public function COversellMagicOrbs()
		{
		}
		
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			tab=data.readUnsignedByte();  
			ids=readObjectArray(MagicIds);  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(tab);  
            writeObjects(ids,byte);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
