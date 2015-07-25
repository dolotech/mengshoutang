package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class magicOrbsStateVO extends DataBase
	{
		public var level : int;  
		public var state : int;  
		
		public function magicOrbsStateVO()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			level=data.readUnsignedByte();  
			state=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(level);  
            byte.writeByte(state);  
			return byte;
		}
	}
}

// vim: filetype=php :
