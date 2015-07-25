package game.net.data.s
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class SChat extends DataBase
	{
		public var type : int;  
		public var id : int;  
		public var name : String;  
		public var content : String;  
		public var attr : int;  
        public static const CMD : int=27020;
		
		public function SChat()
		{
		}
		
		/**
		 *
		 * @param data
		 */
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			type=data.readUnsignedByte();  
			id=data.readInt();  
			name=data.readUTF();  
			content=data.readUTF();  
			attr=data.readUnsignedByte();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(type);  
            byte.writeInt(id);  
            byte.writeUTF(name);  
            byte.writeUTF(content);  
            byte.writeByte(attr);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
