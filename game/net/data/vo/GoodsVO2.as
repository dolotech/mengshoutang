package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class GoodsVO2 extends DataBase
	{
		public var id : int;  
		public var type : int;  
		public var pile : int;  
		
		public function GoodsVO2()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			id=data.readInt();  
			type=data.readInt();  
			pile=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(id);  
            byte.writeInt(type);  
            byte.writeByte(pile);  
			return byte;
		}
	}
}

// vim: filetype=php :
