package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SSign extends DataBase
	{
		public var code : int;  
		public var type : int;  
		public var days1 : int;  
		public var days2 : int;  
		public var days : Vector.<IData>;  
        public static const CMD : int=13052;
		
		public function SSign()
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
			type=data.readUnsignedByte();  
			days1=data.readUnsignedByte();  
			days2=data.readUnsignedByte();  
			days=readObjectArray(SignState);  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(code);  
            byte.writeByte(type);  
            byte.writeByte(days1);  
            byte.writeByte(days2);  
            writeObjects(days,byte);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
