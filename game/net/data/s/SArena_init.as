package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SArena_init extends DataBase
	{
		public var rank : int;  
		public var point : int;  
		public var honor : int;  
		public var level : int;  
        public static const CMD : int=23004;
		
		public function SArena_init()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			rank=data.readInt();  
			point=data.readInt();  
			honor=data.readInt();  
			level=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(rank);  
            byte.writeInt(point);  
            byte.writeInt(honor);  
            byte.writeByte(level);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
