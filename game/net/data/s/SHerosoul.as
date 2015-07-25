package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SHerosoul extends DataBase
	{
		public var code : int;  
		public var time : int;  
		public var coin_time : int;  
		public var lefttimes : int;  
		public var herosoul : Vector.<IData>;  
        public static const CMD : int=13067;
		
		public function SHerosoul()
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
			time=data.readInt();  
			coin_time=data.readInt();  
			lefttimes=data.readUnsignedByte();  
			herosoul=readObjectArray(heroSoulList);  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(code);  
            byte.writeInt(time);  
            byte.writeInt(coin_time);  
            byte.writeByte(lefttimes);  
            writeObjects(herosoul,byte);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
