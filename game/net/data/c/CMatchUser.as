package game.net.data.c
{
	import flash.utils.ByteArray;
	import game.net.data.DataBase;
	import game.net.data.vo.*;
	import game.net.data.IData;

	public class CMatchUser extends DataBase
	{
		public var account : String;  
        public static const CMD : int=11103;
		
		public function CMatchUser()
		{
		}
		
		override public function deSerialize(data:ByteArray):void
		{
			super.deSerialize(data);
			account=data.readUTF();  
		}
		
		override public function serialize():ByteArray
		{
			var byte:ByteArray= new ByteArray();
            byte.writeUTF(account);  
			return byte;
		}
		
		override public function getCmd():int
		{
			return CMD;
		}
	}
}

// vim: filetype=php :
