package game.net.data.c
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class CRolePictrue extends DataBase
	{
		public var id : int;  
        public static const CMD : int=13064;
		
		public function CRolePictrue()
		{
		}
		
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			id=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(id);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
