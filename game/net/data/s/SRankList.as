package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SRankList extends DataBase
	{
		public var type : int;  
		public var num : int;  
		public var lev : int;  
		public var ranks : Vector.<IData>;  
        public static const CMD : int=29010;
		
		public function SRankList()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			type=data.readUnsignedByte();  
			num=data.readInt();  
			lev=data.readUnsignedByte();  
			ranks=readObjectArray(RankInfo);  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(type);  
            byte.writeInt(num);  
            byte.writeByte(lev);  
            writeObjects(ranks,byte);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
