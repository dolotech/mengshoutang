package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SColiseumRivalFightInfo extends DataBase
	{
		public var code : int;  
		public var id : int;  
		public var messege : Vector.<IData>;  
        public static const CMD : int=33025;
		
		public function SColiseumRivalFightInfo()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			code=data.readUnsignedByte();  
			id=data.readInt();  
			messege=readObjectArray(ColiseumRivalMessage);  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(code);  
            byte.writeInt(id);  
            writeObjects(messege,byte);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
