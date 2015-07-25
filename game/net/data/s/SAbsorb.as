package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SAbsorb extends DataBase
	{
		public var code : int;  
		public var heroid : int;  
		public var level : int;  
		public var exp : int;  
        public static const CMD : int=14030;
		
		public function SAbsorb()
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
			heroid=data.readInt();  
			level=data.readUnsignedByte();  
			exp=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(code);  
            byte.writeInt(heroid);  
            byte.writeByte(level);  
            byte.writeInt(exp);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
