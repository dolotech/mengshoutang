package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class MonstersVo extends DataBase
	{
		public var pos : int;  
		public var type : int;  
		public var gid : int;  
		public var status : int;  
		public var time : int;  
		
		public function MonstersVo()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			pos=data.readUnsignedByte();  
			type=data.readUnsignedByte();  
			gid=data.readShort();  
			status=data.readUnsignedByte();  
			time=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(pos);  
            byte.writeByte(type);  
            byte.writeShort(gid);  
            byte.writeByte(status);  
            byte.writeInt(time);  
			return byte;
		}
	}
}

// vim: filetype=php :
