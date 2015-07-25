package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class FestItem extends DataBase
	{
		public var tid : int;  
		public var num : int;  
		
		public function FestItem()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			tid=data.readInt();  
			num=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(tid);  
            byte.writeByte(num);  
			return byte;
		}
	}
}

// vim: filetype=php :
