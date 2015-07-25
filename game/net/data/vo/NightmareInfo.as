package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class NightmareInfo extends DataBase
	{
		public var id : int;  
		public var star : int;  
		
		public function NightmareInfo()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			id=data.readShort();  
			star=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeShort(id);  
            byte.writeByte(star);  
			return byte;
		}
	}
}

// vim: filetype=php :
