package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class FestValues extends DataBase
	{
		public var id : int;  
		public var val : int;  
		public var num : int;  
		public var state : int;  
		
		public function FestValues()
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
			val=data.readInt();  
			num=data.readUnsignedByte();  
			state=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(id);  
            byte.writeInt(val);  
            byte.writeByte(num);  
            byte.writeByte(state);  
			return byte;
		}
	}
}

// vim: filetype=php :
