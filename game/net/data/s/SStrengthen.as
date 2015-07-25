package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SStrengthen extends DataBase
	{
		public var code : int;  
		public var equid : int;  
		public var level : int;  
		public var time : int;  
        public static const CMD : int=13005;
		
		public function SStrengthen()
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
			equid=data.readInt();  
			level=data.readUnsignedByte();  
			time=data.readShort();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(code);  
            byte.writeInt(equid);  
            byte.writeByte(level);  
            byte.writeShort(time);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
