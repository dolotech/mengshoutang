package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SColiseumRankInfo extends DataBase
	{
		public var rank : int;  
		public var exp : int;  
		public var level : int;  
		public var wars : int;  
		public var chance : int;  
		public var cd : int;  
		public var targets : Vector.<IData>;  
        public static const CMD : int=33037;
		
		public function SColiseumRankInfo()
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
			exp=data.readInt();  
			level=data.readUnsignedByte();  
			wars=data.readUnsignedByte();  
			chance=data.readUnsignedByte();  
			cd=data.readInt();  
			targets=readObjectArray(ColiseumRankInfo);  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(rank);  
            byte.writeInt(exp);  
            byte.writeByte(level);  
            byte.writeByte(wars);  
            byte.writeByte(chance);  
            byte.writeInt(cd);  
            writeObjects(targets,byte);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
