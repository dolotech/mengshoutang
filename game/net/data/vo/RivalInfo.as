package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class RivalInfo extends DataBase
	{
		public var id : int;  
		public var name : String;  
		public var picture : int;  
		public var beat : int;  
		
		public function RivalInfo()
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
			name=data.readUTF();  
			picture=data.readUnsignedByte();  
			beat=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(id);  
            byte.writeUTF(name);  
            byte.writeByte(picture);  
            byte.writeByte(beat);  
			return byte;
		}
	}
}

// vim: filetype=php :
