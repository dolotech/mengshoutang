package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class videoUpgradeVo extends DataBase
	{
		public var id : int;  
		public var level : int;  
		public var exp : int;  
		
		public function videoUpgradeVo()
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
			level=data.readUnsignedByte();  
			exp=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(id);  
            byte.writeByte(level);  
            byte.writeInt(exp);  
			return byte;
		}
	}
}

// vim: filetype=php :
