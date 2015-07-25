package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class TavernHeroVo extends DataBase
	{
		public var id : int;  
		public var type : int;  
		public var lock : int;  
		public var quality : int;  
		public var ravity : int;  
		
		public function TavernHeroVo()
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
			type=data.readInt();  
			lock=data.readUnsignedByte();  
			quality=data.readUnsignedByte();  
			ravity=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(id);  
            byte.writeInt(type);  
            byte.writeByte(lock);  
            byte.writeByte(quality);  
            byte.writeByte(ravity);  
			return byte;
		}
	}
}

// vim: filetype=php :
