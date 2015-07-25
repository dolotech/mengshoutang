package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class ColiseumRivalMessage extends DataBase
	{
		public var type : int;  
		public var level : int;  
		public var hp : int;  
		public var seat : int;  
		public var weapon : int;  
		
		public function ColiseumRivalMessage()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			type=data.readInt();  
			level=data.readShort();  
			hp=data.readInt();  
			seat=data.readShort();  
			weapon=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(type);  
            byte.writeShort(level);  
            byte.writeInt(hp);  
            byte.writeShort(seat);  
            byte.writeInt(weapon);  
			return byte;
		}
	}
}

// vim: filetype=php :
