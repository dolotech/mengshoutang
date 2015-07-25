package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class AotoEquipVO extends DataBase
	{
		public var heroID : int;  
		public var seat : int;  
		public var equipID : int;  
		
		public function AotoEquipVO()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			heroID=data.readInt();  
			seat=data.readUnsignedByte();  
			equipID=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(heroID);  
            byte.writeByte(seat);  
            byte.writeInt(equipID);  
			return byte;
		}
	}
}

// vim: filetype=php :
