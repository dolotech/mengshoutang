package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SXYLMLogin extends DataBase
	{
		public var status : int;  
		public var progress : int;  
		public var id : int;  
        public static const CMD : int=11000;
		
		public function SXYLMLogin()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			status=data.readUnsignedByte();  
			progress=data.readUnsignedByte();  
			id=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(status);  
            byte.writeByte(progress);  
            byte.writeInt(id);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
