package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class SignState extends DataBase
	{
		public var day : int;  
		public var state : int;  
		
		public function SignState()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			day=data.readUnsignedByte();  
			state=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(day);  
            byte.writeByte(state);  
			return byte;
		}
	}
}

// vim: filetype=php :
