package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class battleHeroesVo extends DataBase
	{
		public var pos : int;  
		public var hp : int;  
		public var power : int;  
		
		public function battleHeroesVo()
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
			hp=data.readInt();  
			power=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(pos);  
            byte.writeInt(hp);  
            byte.writeInt(power);  
			return byte;
		}
	}
}

// vim: filetype=php :
