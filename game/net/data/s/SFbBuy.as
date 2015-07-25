package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SFbBuy extends DataBase
	{
		public var code : int;  
		public var gate : int;  
		public var num : int;  
		public var num2 : int;  
        public static const CMD : int=22014;
		
		public function SFbBuy()
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
			gate=data.readShort();  
			num=data.readUnsignedByte();  
			num2=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(code);  
            byte.writeShort(gate);  
            byte.writeByte(num);  
            byte.writeByte(num2);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
