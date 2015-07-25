package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class RankInfo extends DataBase
	{
		public var index : int;  
		public var attr : int;  
		public var id : int;  
		public var name : String;  
		public var picture : int;  
		public var custom : int;  
		
		public function RankInfo()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			index=data.readInt();  
			attr=data.readInt();  
			id=data.readInt();  
			name=data.readUTF();  
			picture=data.readUnsignedByte();  
			custom=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(index);  
            byte.writeInt(attr);  
            byte.writeInt(id);  
            byte.writeUTF(name);  
            byte.writeByte(picture);  
            byte.writeInt(custom);  
			return byte;
		}
	}
}

// vim: filetype=php :
