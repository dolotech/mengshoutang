package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SLuckInitInfo extends DataBase
	{
		public var id : int;  
		public var luck : int;  
		public var values : int;  
        public static const CMD : int=13045;
		
		public function SLuckInitInfo()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			id=data.readUnsignedByte();  
			luck=data.readInt();  
			values=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(id);  
            byte.writeInt(luck);  
            byte.writeInt(values);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
