package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SFbData extends DataBase
	{
		public var id : int;  
		public var hightMap : int;  
		public var lowMap : int;  
		public var fbTime : int;  
		public var free : int;  
		public var monsters : Vector.<IData>;  
        public static const CMD : int=22004;
		
		public function SFbData()
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
			hightMap=data.readInt();  
			lowMap=data.readInt();  
			fbTime=data.readInt();  
			free=data.readUnsignedByte();  
			monsters=readObjectArray(MonstersVo);  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(id);  
            byte.writeInt(hightMap);  
            byte.writeInt(lowMap);  
            byte.writeInt(fbTime);  
            byte.writeByte(free);  
            writeObjects(monsters,byte);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
