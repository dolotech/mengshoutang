package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class heroSoulList extends DataBase
	{
		public var pos : int;  
		public var id : int;  
		public var type : int;  
		public var rare : int;  
		
		public function heroSoulList()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			pos=data.readUnsignedByte();  
			id=data.readInt();  
			type=data.readUnsignedByte();  
			rare=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(pos);  
            byte.writeInt(id);  
            byte.writeByte(type);  
            byte.writeByte(rare);  
			return byte;
		}
	}
}

// vim: filetype=php :
