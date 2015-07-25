package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SSearchhero extends DataBase
	{
		public var code : int;  
		public var cd : int;  
		public var heroes : Vector.<IData>;  
        public static const CMD : int=14020;
		
		public function SSearchhero()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			code=data.readUnsignedByte();  
			cd=data.readInt();  
			heroes=readObjectArray(TavernHeroVo);  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(code);  
            byte.writeInt(cd);  
            writeObjects(heroes,byte);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
