package game.net.data.vo
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

    public class ColiseumRankInfo extends DataBase
	{
		public var pos : int;  
		public var id : int;  
		public var rid : int;  
		public var name : String;  
		public var picture : int;  
		public var power : int;  
		
		public function ColiseumRankInfo()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			pos=data.readInt();  
			id=data.readInt();  
			rid=data.readInt();  
			name=data.readUTF();  
			picture=data.readUnsignedByte();  
			power=data.readInt();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeInt(pos);  
            byte.writeInt(id);  
            byte.writeInt(rid);  
            byte.writeUTF(name);  
            byte.writeByte(picture);  
            byte.writeInt(power);  
			return byte;
		}
	}
}

// vim: filetype=php :
