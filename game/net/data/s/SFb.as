package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SFb extends DataBase
	{
		public var gate : int;  
		public var num : int;  
		public var time : int;  
		public var num2 : int;  
        public static const CMD : int=22010;
		
		public function SFb()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			gate=data.readShort();  
			num=data.readUnsignedByte();  
			time=data.readInt();  
			num2=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeShort(gate);  
            byte.writeByte(num);  
            byte.writeInt(time);  
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
