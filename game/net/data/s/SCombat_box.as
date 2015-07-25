package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SCombat_box extends DataBase
	{
		public var code : int;  
		public var gold : int;  
		public var honor : int;  
		public var point : int;  
        public static const CMD : int=23029;
		
		public function SCombat_box()
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
			gold=data.readInt();  
			honor=data.readInt();  
			point=data.readShort();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(code);  
            byte.writeInt(gold);  
            byte.writeInt(honor);  
            byte.writeShort(point);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
