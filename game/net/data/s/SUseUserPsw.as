package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SUseUserPsw extends DataBase
	{
		public var state : int;  
		public var progress : int;  
		public var id : int;  
        public static const CMD : int=11101;
		
		public function SUseUserPsw()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			state=data.readUnsignedByte();  
			progress=data.readUnsignedByte();  
			id=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(state);  
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
