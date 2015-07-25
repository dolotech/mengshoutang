package game.net.data.c
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class CDiamondshop extends DataBase
	{
		public var platform : String;  
		public var receipt : String;  
		public var rand : int;  
		public var signature : String;  
        public static const CMD : int=10011;
		
		public function CDiamondshop()
		{
		}
		
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			platform=data.readUTF();  
			receipt=data.readUTF();  
			rand=data.readInt();  
			signature=data.readUTF();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeUTF(platform);  
            byte.writeUTF(receipt);  
            byte.writeInt(rand);  
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
