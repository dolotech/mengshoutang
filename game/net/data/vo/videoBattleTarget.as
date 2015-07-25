package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class videoBattleTarget extends DataBase
	{
		public var id : int;  
		public var hp : int;  
		public var state : int;  
		public var buffid : Vector.<int>;  
		
		public function videoBattleTarget()
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
			hp=data.readInt();  
			state=data.readUnsignedByte();  
			buffid=readArrayInt();
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(id);  
            byte.writeInt(hp);  
            byte.writeByte(state);  
			writeInts(buffid,byte);  
			return byte;
		}
	}
}

// vim: filetype=php :
