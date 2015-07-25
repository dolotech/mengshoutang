package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SGetMagicOrbs extends DataBase
	{
		public var code : int;  
		public var level : int;  
		public var id : int;  
		public var type : int;  
        public static const CMD : int=13022;
		
		public function SGetMagicOrbs()
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
			level=data.readUnsignedByte();  
			id=data.readInt();  
			type=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(code);  
            byte.writeByte(level);  
            byte.writeInt(id);  
            byte.writeInt(type);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
