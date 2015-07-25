package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class videoRankList extends DataBase
	{
		public var name : String;  
		public var power : int;  
		public var picture : int;  
		
		public function videoRankList()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			name=data.readUTF();  
			power=data.readInt();  
			picture=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeUTF(name);  
            byte.writeInt(power);  
            byte.writeByte(picture);  
			return byte;
		}
	}
}

// vim: filetype=php :
