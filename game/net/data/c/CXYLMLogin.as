package game.net.data.c
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class CXYLMLogin extends DataBase
	{
		public var type : int;  
		public var rand : int;  
		public var sid : int;  
		public var platform : String;  
		public var account : String;  
		public var password : String;  
		public var signature : String;  
        public static const CMD : int=11000;
		
		public function CXYLMLogin()
		{
		}
		
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			type=data.readUnsignedByte();  
			rand=data.readInt();  
			sid=data.readShort();  
			platform=data.readUTF();  
			account=data.readUTF();  
			password=data.readUTF();  
			signature=data.readUTF();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeByte(type);  
            byte.writeInt(rand);  
            byte.writeShort(sid);  
            byte.writeUTF(platform);  
            byte.writeUTF(account);  
            byte.writeUTF(password);  
            byte.writeUTF(signature);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
