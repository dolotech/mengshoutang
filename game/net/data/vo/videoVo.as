package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class videoVo extends DataBase
	{
		public var bout : int;  
		public var sponsor : int;  
		public var buffid : Vector.<int>;  
		public var targets : Vector.<IData>;  
		public var skill : int;  
		
		public function videoVo()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			bout=data.readUnsignedByte();  
			sponsor=data.readUnsignedByte();  
			buffid=readArrayInt();
			targets=readObjectArray(videoBattleTarget);  
			skill=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(bout);  
            byte.writeByte(sponsor);  
			writeInts(buffid,byte);  
            writeObjects(targets,byte);  
            byte.writeInt(skill);  
			return byte;
		}
	}
}

// vim: filetype=php :
